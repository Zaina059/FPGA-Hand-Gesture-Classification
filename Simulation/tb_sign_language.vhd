library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library STD;
use STD.TEXTIO.ALL;

entity tb_sign_language is
end tb_sign_language;

architecture sim of tb_sign_language is

    signal clk      : std_logic := '0';
    signal reset    : std_logic := '1';

    signal pixel_x  : integer range 0 to 63 := 0;
    signal pixel_y  : integer range 0 to 63 := 0;

    signal pixel_r  : integer range 0 to 255 := 0;
    signal pixel_g  : integer range 0 to 255 := 0;
    signal pixel_b  : integer range 0 to 255 := 0;

    signal valid_in  : std_logic := '0';
    signal valid_pre : std_logic := '0';

    signal binary_pixel : std_logic;

    signal r0, r1, r2, r3, r4, r5, r6, r7 : integer range 0 to 255;
    signal r8, r9, r10, r11, r12, r13, r14, r15 : integer range 0 to 255;

    signal f0, f1, f2, f3, f4, f5, f6, f7 : integer range 0 to 255;

    signal class_out : std_logic_vector(7 downto 0);

begin

    clk <= not clk after 10 ns;

    U1 : entity work.preprocessing
    port map (
        clk          => clk,
        reset        => reset,
        valid_in     => valid_in,
        pixel_r      => pixel_r,
        pixel_g      => pixel_g,
        pixel_b      => pixel_b,
        binary_pixel => binary_pixel,
        valid_out    => valid_pre
    );

    U2 : entity work.feature_extraction
    port map (
        clk          => clk,
        reset        => reset,
        valid_in     => valid_pre,

        pixel_x      => pixel_x,
        pixel_y      => pixel_y,
        binary_pixel => binary_pixel,

        r0 => r0,
        r1 => r1,
        r2 => r2,
        r3 => r3,
        r4 => r4,
        r5 => r5,
        r6 => r6,
        r7 => r7,

        r8  => r8,
        r9  => r9,
        r10 => r10,
        r11 => r11,
        r12 => r12,
        r13 => r13,
        r14 => r14,
        r15 => r15,

        f0 => f0,
        f1 => f1,
        f2 => f2,
        f3 => f3,
        f4 => f4,
        f5 => f5,
        f6 => f6,
        f7 => f7
    );

    U3 : entity work.decision_tree_classifier
    port map (

        r0 => r0,
        r1 => r1,
        r2 => r2,
        r3 => r3,
        r4 => r4,
        r5 => r5,
        r6 => r6,
        r7 => r7,

        r8  => r8,
        r9  => r9,
        r10 => r10,
        r11 => r11,
        r12 => r12,
        r13 => r13,
        r14 => r14,
        r15 => r15,

        f0 => f0,
        f1 => f1,
        f2 => f2,
        f3 => f3,
        f4 => f4,
        f5 => f5,
        f6 => f6,
        f7 => f7,

        class_out => class_out
    );


    process

        file pixel_file : text open read_mode is "y";

        variable line_data : line;

        variable vx : integer;
        variable vy : integer;

        variable vr : integer;
        variable vg : integer;
        variable vb : integer;

    begin

        reset <= '1';
        valid_in <= '0';

        wait for 50 ns;

        reset <= '0';

        wait for 20 ns;

        while not endfile(pixel_file) loop

            readline(pixel_file, line_data);

            read(line_data, vx);
            read(line_data, vy);
            read(line_data, vr);
            read(line_data, vg);
            read(line_data, vb);

            pixel_x <= vx;
            pixel_y <= vy;

            pixel_r <= vr;
            pixel_g <= vg;
            pixel_b <= vb;

            valid_in <= '1';

            wait until rising_edge(clk);

        end loop;

        valid_in <= '0';

        report "IMAGE READ COMPLETE";

        wait for 500 ns;

        report "CLASSIFIER OUTPUT = " &
       character'image(
           character'val(
               to_integer(unsigned(class_out))
           )
       );

        wait;

    end process;

end sim;
