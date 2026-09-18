library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity uart_rx is
    Port (
        clk      : in  std_logic;
        reset    : in  std_logic;
        rx       : in  std_logic;
        data_out : out std_logic_vector(7 downto 0);
        valid    : out std_logic
    );
end uart_rx;

architecture Behavioral of uart_rx is

    constant CLKS_PER_BIT : integer := 434; -- 50MHz / 115200

    type state_type is (IDLE, START_BIT, DATA_BITS, STOP_BIT);
    signal state : state_type := IDLE;

    signal clk_count : integer range 0 to CLKS_PER_BIT := 0;
    signal bit_index : integer range 0 to 7 := 0;
    signal rx_shift  : std_logic_vector(7 downto 0) := (others => '0');

begin

process(clk, reset)
begin
    if reset = '1' then
        state <= IDLE;
        clk_count <= 0;
        bit_index <= 0;
        rx_shift <= (others => '0');
        data_out <= (others => '0');
        valid <= '0';

    elsif rising_edge(clk) then
        valid <= '0';

        case state is

            when IDLE =>
                clk_count <= 0;
                bit_index <= 0;

                if rx = '0' then
                    state <= START_BIT;
                end if;

            when START_BIT =>
                if clk_count = CLKS_PER_BIT / 2 then
                    if rx = '0' then
                        clk_count <= 0;
                        state <= DATA_BITS;
                    else
                        state <= IDLE;
                    end if;
                else
                    clk_count <= clk_count + 1;
                end if;

            when DATA_BITS =>
                if clk_count = CLKS_PER_BIT - 1 then
                    clk_count <= 0;
                    rx_shift(bit_index) <= rx;

                    if bit_index = 7 then
                        bit_index <= 0;
                        state <= STOP_BIT;
                    else
                        bit_index <= bit_index + 1;
                    end if;
                else
                    clk_count <= clk_count + 1;
                end if;

            when STOP_BIT =>
                if clk_count = CLKS_PER_BIT - 1 then
                    data_out <= rx_shift;
                    valid <= '1';
                    clk_count <= 0;
                    state <= IDLE;
                else
                    clk_count <= clk_count + 1;
                end if;

        end case;
    end if;
end process;

end Behavioral;