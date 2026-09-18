library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity uart_pixel_stream is
    Port (
        clk          : in  std_logic;
        reset        : in  std_logic;
        rx_data      : in  std_logic_vector(7 downto 0);
        rx_valid     : in  std_logic;

        frame_start  : out std_logic;
        pixel_valid  : out std_logic;
        pixel_x      : out integer range 0 to 63;
        pixel_y      : out integer range 0 to 63;
        binary_pixel : out std_logic;
        frame_done   : out std_logic
    );
end uart_pixel_stream;

architecture Behavioral of uart_pixel_stream is

    signal receiving : std_logic := '0';
    signal x_count   : integer range 0 to 63 := 0;
    signal y_count   : integer range 0 to 63 := 0;

begin

process(clk, reset)
begin
    if reset = '1' then
        receiving <= '0';
        x_count <= 0;
        y_count <= 0;
        frame_start <= '0';
        pixel_valid <= '0';
        binary_pixel <= '0';
        frame_done <= '0';

    elsif rising_edge(clk) then
        frame_start <= '0';
        pixel_valid <= '0';
        frame_done <= '0';

        if rx_valid = '1' then

            if rx_data = x"AA" then
                receiving <= '1';
                x_count <= 0;
                y_count <= 0;
                frame_start <= '1';

            elsif receiving = '1' then

                pixel_x <= x_count;
                pixel_y <= y_count;
                binary_pixel <= rx_data(0);
                pixel_valid <= '1';

                if x_count = 63 then
                    x_count <= 0;

                    if y_count = 63 then
                        y_count <= 0;
                        receiving <= '0';
                        frame_done <= '1';
                    else
                        y_count <= y_count + 1;
                    end if;

                else
                    x_count <= x_count + 1;
                end if;

            end if;
        end if;
    end if;
end process;

end Behavioral;