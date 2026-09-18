library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity preprocessing is
    Port (
        clk          : in  std_logic;
        reset        : in  std_logic;
        valid_in     : in  std_logic;

        pixel_r      : in integer range 0 to 255;
        pixel_g      : in integer range 0 to 255;
        pixel_b      : in integer range 0 to 255;

        binary_pixel : out std_logic;
        valid_out    : out std_logic
    );
end preprocessing;

architecture Behv of preprocessing is
begin

process(clk, reset)
begin
    if reset = '1' then
        binary_pixel <= '0';
        valid_out <= '0';

    elsif rising_edge(clk) then
        valid_out <= valid_in;

        if valid_in = '1' then
            if (pixel_r > 95 and pixel_g > 40 and pixel_b > 20 and
                pixel_r > pixel_g and pixel_r > pixel_b and
                abs(pixel_r - pixel_g) > 15) then
					-- hand 
                binary_pixel <= '1'; 
            else
				-- background
                binary_pixel <= '0'; 
            end if;
        end if;
    end if;
end process;

end Behv;