library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity feature_extraction is
    Port (
        clk          : in std_logic;
        reset        : in std_logic;
        frame_start  : in std_logic;
        valid_in     : in std_logic;

        pixel_x      : in integer range 0 to 63;
        pixel_y      : in integer range 0 to 63;
        binary_pixel : in std_logic;

        r0, r1, r2, r3, r4, r5, r6, r7 : out integer range 0 to 255;
        r8, r9, r10, r11, r12, r13, r14, r15 : out integer range 0 to 255;

        f0, f1, f2, f3, f4, f5, f6, f7 : out integer range 0 to 255
    );
end feature_extraction;

architecture Behavioral of feature_extraction is

    signal sr0, sr1, sr2, sr3, sr4, sr5, sr6, sr7 : integer range 0 to 4096 := 0;
    signal sr8, sr9, sr10, sr11, sr12, sr13, sr14, sr15 : integer range 0 to 4096 := 0;

    signal total_pixels  : integer range 0 to 4096 := 0;
    signal sum_x         : integer range 0 to 258048 := 0;
    signal sum_y         : integer range 0 to 258048 := 0;

    signal top_count     : integer range 0 to 4096 := 0;
    signal bottom_count  : integer range 0 to 4096 := 0;
    signal left_count    : integer range 0 to 4096 := 0;
    signal right_count   : integer range 0 to 4096 := 0;
    signal center_count  : integer range 0 to 4096 := 0;

begin

process(clk, reset)
begin
    if reset = '1' then

        sr0 <= 0; sr1 <= 0; sr2 <= 0; sr3 <= 0;
        sr4 <= 0; sr5 <= 0; sr6 <= 0; sr7 <= 0;
        sr8 <= 0; sr9 <= 0; sr10 <= 0; sr11 <= 0;
        sr12 <= 0; sr13 <= 0; sr14 <= 0; sr15 <= 0;

        total_pixels <= 0;
        sum_x <= 0;
        sum_y <= 0;

        top_count <= 0;
        bottom_count <= 0;
        left_count <= 0;
        right_count <= 0;
        center_count <= 0;

    elsif rising_edge(clk) then

        if frame_start = '1' then

            sr0 <= 0; sr1 <= 0; sr2 <= 0; sr3 <= 0;
            sr4 <= 0; sr5 <= 0; sr6 <= 0; sr7 <= 0;
            sr8 <= 0; sr9 <= 0; sr10 <= 0; sr11 <= 0;
            sr12 <= 0; sr13 <= 0; sr14 <= 0; sr15 <= 0;

            total_pixels <= 0;
            sum_x <= 0;
            sum_y <= 0;

            top_count <= 0;
            bottom_count <= 0;
            left_count <= 0;
            right_count <= 0;
            center_count <= 0;

        elsif valid_in = '1' and binary_pixel = '1' then

            total_pixels <= total_pixels + 1;
            sum_x <= sum_x + pixel_x;
            sum_y <= sum_y + pixel_y;

            if pixel_y < 32 then
                top_count <= top_count + 1;
            else
                bottom_count <= bottom_count + 1;
            end if;

            if pixel_x < 32 then
                left_count <= left_count + 1;
            else
                right_count <= right_count + 1;
            end if;

            if pixel_x >= 24 and pixel_x < 40 and
               pixel_y >= 24 and pixel_y < 40 then
                center_count <= center_count + 1;
            end if;

            if pixel_y < 16 then

                if pixel_x < 16 then
                    sr0 <= sr0 + 1;
                elsif pixel_x < 32 then
                    sr1 <= sr1 + 1;
                elsif pixel_x < 48 then
                    sr2 <= sr2 + 1;
                else
                    sr3 <= sr3 + 1;
                end if;

            elsif pixel_y < 32 then

                if pixel_x < 16 then
                    sr4 <= sr4 + 1;
                elsif pixel_x < 32 then
                    sr5 <= sr5 + 1;
                elsif pixel_x < 48 then
                    sr6 <= sr6 + 1;
                else
                    sr7 <= sr7 + 1;
                end if;

            elsif pixel_y < 48 then

                if pixel_x < 16 then
                    sr8 <= sr8 + 1;
                elsif pixel_x < 32 then
                    sr9 <= sr9 + 1;
                elsif pixel_x < 48 then
                    sr10 <= sr10 + 1;
                else
                    sr11 <= sr11 + 1;
                end if;

            else

                if pixel_x < 16 then
                    sr12 <= sr12 + 1;
                elsif pixel_x < 32 then
                    sr13 <= sr13 + 1;
                elsif pixel_x < 48 then
                    sr14 <= sr14 + 1;
                else
                    sr15 <= sr15 + 1;
                end if;

            end if;

        end if;
    end if;
end process;

f0 <= (total_pixels * 255) / 4096;

f1 <= 0 when total_pixels = 0 else
      (sum_x * 255) / (total_pixels * 63);

f2 <= 0 when total_pixels = 0 else
      (sum_y * 255) / (total_pixels * 63);

f3 <= (top_count * 255) / 2048;
f4 <= (bottom_count * 255) / 2048;
f5 <= (left_count * 255) / 2048;
f6 <= (right_count * 255) / 2048;
f7 <= (center_count * 255) / 256;

r0  <= (sr0  * 255) / 256;
r1  <= (sr1  * 255) / 256;
r2  <= (sr2  * 255) / 256;
r3  <= (sr3  * 255) / 256;

r4  <= (sr4  * 255) / 256;
r5  <= (sr5  * 255) / 256;
r6  <= (sr6  * 255) / 256;
r7  <= (sr7  * 255) / 256;

r8  <= (sr8  * 255) / 256;
r9  <= (sr9  * 255) / 256;
r10 <= (sr10 * 255) / 256;
r11 <= (sr11 * 255) / 256;

r12 <= (sr12 * 255) / 256;
r13 <= (sr13 * 255) / 256;
r14 <= (sr14 * 255) / 256;
r15 <= (sr15 * 255) / 256;

end Behavioral;