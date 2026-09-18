library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity lcd_display is
    Port (
        clk        : in  std_logic;
        reset      : in  std_logic;
        class_char : in  std_logic_vector(7 downto 0);

        LCD_DATA   : out std_logic_vector(7 downto 0);
        LCD_RW     : out std_logic;
        LCD_EN     : out std_logic;
        LCD_RS     : out std_logic;
        LCD_ON     : out std_logic;
        LCD_BLON   : out std_logic
    );
end lcd_display;

architecture Behavioral of lcd_display is

    type state_type is (
        WAIT_POWER,
        FUNC_SET,
        DISP_ON,
        CLEAR_DISP,
        ENTRY_MODE,
        LINE1_ADDR,
        CHAR_S,
        CHAR_I,
        CHAR_G,
        CHAR_N,
        CHAR_COLON,
        CHAR_SPACE,
        CHAR_CLASS,
        HOLD
    );

    signal state : state_type := WAIT_POWER;
    signal count : integer range 0 to 2500000 := 0;
    signal en_reg : std_logic := '0';
    signal rs_reg : std_logic := '0';
    signal data_reg : std_logic_vector(7 downto 0) := (others => '0');

begin

    LCD_ON   <= '1';
    LCD_BLON <= '1';
    LCD_RW   <= '0';

    LCD_EN   <= en_reg;
    LCD_RS   <= rs_reg;
    LCD_DATA <= data_reg;

    process(clk, reset)
    begin
        if reset = '1' then
            state <= WAIT_POWER;
            count <= 0;
            en_reg <= '0';
            rs_reg <= '0';
            data_reg <= (others => '0');

        elsif rising_edge(clk) then

            en_reg <= '0';

            if count < 250000 then
                count <= count + 1;
            else
                count <= 0;

                case state is

                    when WAIT_POWER =>
                        state <= FUNC_SET;

                    when FUNC_SET =>
                        rs_reg <= '0';
                        data_reg <= x"38";
                        en_reg <= '1';
                        state <= DISP_ON;

                    when DISP_ON =>
                        rs_reg <= '0';
                        data_reg <= x"0C";
                        en_reg <= '1';
                        state <= CLEAR_DISP;

                    when CLEAR_DISP =>
                        rs_reg <= '0';
                        data_reg <= x"01";
                        en_reg <= '1';
                        state <= ENTRY_MODE;

                    when ENTRY_MODE =>
                        rs_reg <= '0';
                        data_reg <= x"06";
                        en_reg <= '1';
                        state <= LINE1_ADDR;

                    when LINE1_ADDR =>
                        rs_reg <= '0';
                        data_reg <= x"80";
                        en_reg <= '1';
                        state <= CHAR_S;

                    when CHAR_S =>
                        rs_reg <= '1';
                        data_reg <= x"53"; -- S
                        en_reg <= '1';
                        state <= CHAR_I;

                    when CHAR_I =>
                        rs_reg <= '1';
                        data_reg <= x"49"; -- I
                        en_reg <= '1';
                        state <= CHAR_G;

                    when CHAR_G =>
                        rs_reg <= '1';
                        data_reg <= x"47"; -- G
                        en_reg <= '1';
                        state <= CHAR_N;

                    when CHAR_N =>
                        rs_reg <= '1';
                        data_reg <= x"4E"; -- N
                        en_reg <= '1';
                        state <= CHAR_COLON;

                    when CHAR_COLON =>
                        rs_reg <= '1';
                        data_reg <= x"3A"; -- :
                        en_reg <= '1';
                        state <= CHAR_SPACE;

                    when CHAR_SPACE =>
                        rs_reg <= '1';
                        data_reg <= x"20"; -- space
                        en_reg <= '1';
                        state <= CHAR_CLASS;

                    when CHAR_CLASS =>
                        rs_reg <= '1';
                        data_reg <= class_char;
                        en_reg <= '1';
                        state <= HOLD;

                    when HOLD =>
                        state <= LINE1_ADDR;

                end case;
            end if;
        end if;
    end process;

end Behavioral;