library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top_level is
    Port (
        CLOCK_50 : in  std_logic;
        KEY      : in  std_logic_vector(3 downto 0);
        UART_RXD : in  std_logic;

        LEDR     : out std_logic_vector(17 downto 0);

        LCD_DATA : out std_logic_vector(7 downto 0);
        LCD_RW   : out std_logic;
        LCD_EN   : out std_logic;
        LCD_RS   : out std_logic;
        LCD_ON   : out std_logic;
        LCD_BLON : out std_logic
    );
end top_level;

architecture Behavioral of top_level is

    signal reset : std_logic;

    signal rx_data  : std_logic_vector(7 downto 0);
    signal rx_valid : std_logic;

    signal frame_start  : std_logic;
    signal pixel_valid  : std_logic;
    signal binary_pixel : std_logic;
    signal frame_done   : std_logic;

    signal px : integer range 0 to 63;
    signal py : integer range 0 to 63;

    signal r0,r1,r2,r3,r4,r5,r6,r7 : integer range 0 to 255;
    signal r8,r9,r10,r11,r12,r13,r14,r15 : integer range 0 to 255;

    signal f0,f1,f2,f3,f4,f5,f6,f7 : integer range 0 to 255;

    signal class_out : std_logic_vector(7 downto 0);

begin

    reset <= not KEY(0);

    U_RX : entity work.uart_rx
        port map (
            clk      => CLOCK_50,
            reset    => reset,
            rx       => UART_RXD,
            data_out => rx_data,
            valid    => rx_valid
        );

    U_STREAM : entity work.uart_pixel_stream
        port map (
            clk          => CLOCK_50,
            reset        => reset,
            rx_data      => rx_data,
            rx_valid     => rx_valid,
            frame_start  => frame_start,
            pixel_valid  => pixel_valid,
            pixel_x      => px,
            pixel_y      => py,
            binary_pixel => binary_pixel,
            frame_done   => frame_done
        );

    U_FE : entity work.feature_extraction
        port map (
            clk          => CLOCK_50,
            reset        => reset,
            frame_start  => frame_start,
            valid_in     => pixel_valid,
            pixel_x      => px,
            pixel_y      => py,
            binary_pixel => binary_pixel,

            r0 => r0, r1 => r1, r2 => r2, r3 => r3,
            r4 => r4, r5 => r5, r6 => r6, r7 => r7,
            r8 => r8, r9 => r9, r10 => r10, r11 => r11,
            r12 => r12, r13 => r13, r14 => r14, r15 => r15,

            f0 => f0, f1 => f1, f2 => f2, f3 => f3,
            f4 => f4, f5 => f5, f6 => f6, f7 => f7
        );

    U_CLASS : entity work.decision_tree_classifier
        port map (
            r0 => r0, r1 => r1, r2 => r2, r3 => r3,
            r4 => r4, r5 => r5, r6 => r6, r7 => r7,
            r8 => r8, r9 => r9, r10 => r10, r11 => r11,
            r12 => r12, r13 => r13, r14 => r14, r15 => r15,

            f0 => f0, f1 => f1, f2 => f2, f3 => f3,
            f4 => f4, f5 => f5, f6 => f6, f7 => f7,

            class_out => class_out
        );

    U_LCD : entity work.lcd_display
        port map (
            clk        => CLOCK_50,
            reset      => reset,
            class_char => class_out,

            LCD_DATA   => LCD_DATA,
            LCD_RW     => LCD_RW,
            LCD_EN     => LCD_EN,
            LCD_RS     => LCD_RS,
            LCD_ON     => LCD_ON,
            LCD_BLON   => LCD_BLON
        );

    LEDR(7 downto 0) <= class_out;
    LEDR(8) <= frame_done;
    LEDR(9) <= rx_valid;
    LEDR(17 downto 10) <= (others => '0');

end Behavioral;