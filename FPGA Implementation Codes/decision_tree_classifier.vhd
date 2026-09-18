use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
 
entity decision_tree_classifier is
    Port (
        r0, r1, r2, r3, r4, r5, r6, r7 : in integer range 0 to 255;
        r8, r9, r10, r11, r12, r13, r14, r15 : in integer range 0 to 255;
 
        f0, f1, f2, f3, f4, f5, f6, f7 : in integer range 0 to 255;
 
        class_out : out std_logic_vector(7 downto 0)
    );
end decision_tree_classifier;
 
architecture behv of decision_tree_classifier is
begin
 
process(r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13,r14,r15,
        f0,f1,f2,f3,f4,f5,f6,f7)
begin
 
    if r4 <= 24 then
        if r2 <= 121 then
            if r9 <= 206 then
                if f4 <= 105 then
                    if r0 <= 5 then
                        class_out <= x"76"; -- v
                    else
                        class_out <= x"39"; -- 9
                    end if;
                else
                    if f4 <= 118 then
                        class_out <= x"75"; -- u
                    else
                        class_out <= x"76"; -- v
                    end if;
                end if;
            else
                if r7 <= 39 then
                    if r2 <= 63 then
                        if r3 <= 16 then
                            if f7 <= 235 then
                                class_out <= x"76"; -- v
                            else
                                class_out <= x"75"; -- u
                            end if;
                        else
                            class_out <= x"76"; -- v
                        end if;
                    else
                        class_out <= x"76"; -- v
                    end if;
                else
                    if f6 <= 79 then
                        class_out <= x"6C"; -- l
                    else
                        if r13 <= 234 then
                            class_out <= x"38"; -- 8
                        else
                            class_out <= x"75"; -- u
                        end if;
                    end if;
                end if;
            end if;
        else
            class_out <= x"75"; -- u
        end if;
 
    else
        if r1 <= 157 then
            if r0 <= 42 then
                if r8 <= 121 then
                    if r2 <= 120 then
                        if r3 <= 2 then
                            if f1 <= 128 then
                                if r4 <= 59 then
                                    if f6 <= 86 then
                                        class_out <= x"33"; -- 3
                                    else
                                        if f5 <= 106 then
                                            class_out <= x"76"; -- v
                                        else
                                            class_out <= x"38"; -- 8
                                        end if;
                                    end if;
                                else
                                    if r2 <= 56 then
                                        class_out <= x"39"; -- 9
                                    else
                                        if f2 <= 149 then
                                            class_out <= x"35"; -- 5
                                        else
                                            class_out <= x"39"; -- 9
                                        end if;
                                    end if;
                                end if;
                            else
                                if r7 <= 122 then
                                    if r14 <= 253 then
                                        class_out <= x"39"; -- 9
                                    else
                                        class_out <= x"78"; -- x
                                    end if;
                                else
                                    class_out <= x"35"; -- 5
                                end if;
                            end if;
                        else
                            if r2 <= 69 then
                                if f3 <= 79 then
                                    class_out <= x"34"; -- 4
                                else
                                    class_out <= x"38"; -- 8
                                end if;
                            else
                                if r7 <= 61 then
                                    if f4 <= 118 then
                                        class_out <= x"35"; -- 5
                                    else
                                        class_out <= x"38"; -- 8
                                    end if;
                                else
                                    if r8 <= 93 then
                                        class_out <= x"34"; -- 4
                                    else
                                        class_out <= x"61"; -- a
                                    end if;
                                end if;
                            end if;
                        end if;
                    else
                        if r0 <= 0 then
                            if r7 <= 43 then
                                if f6 <= 121 then
                                    if f0 <= 98 then
                                        class_out <= x"63"; -- c
                                    else
                                        class_out <= x"76"; -- v
                                    end if;
                                else
                                    class_out <= x"35"; -- 5
                                end if;
                            else
                                if f6 <= 104 then
                                    class_out <= x"6F"; -- o
                                else
                                    class_out <= x"78"; -- x
                                end if;
                            end if;
                        else
                            if f7 <= 215 then
                                if r7 <= 133 then
                                    class_out <= x"61"; -- a
                                else
                                    class_out <= x"6F"; -- o
                                end if;
                            else
                                if f3 <= 102 then
                                    class_out <= x"34"; -- 4
                                else
                                    if r2 <= 150 then
                                        class_out <= x"35"; -- 5
                                    else
                                        class_out <= x"78"; -- x
                                    end if;
                                end if;
                            end if;
                        end if;
                    end if;
 
                else
                    if f6 <= 103 then
                        if r0 <= 8 then
                            if f2 <= 141 then
                                if r11 <= 6 then
                                    class_out <= x"76"; -- v
                                else
                                    class_out <= x"63"; -- c
                                end if;
                            else
                                class_out <= x"6C"; -- l
                            end if;
                        else
                            if r1 <= 128 then
                                class_out <= x"33"; -- 3
                            else
                                class_out <= x"35"; -- 5
                            end if;
                        end if;
                    else
                        class_out <= x"61"; -- a
                    end if;
                end if;
 
            else
                if r11 <= 86 then
                    if r6 <= 108 then
                        if r2 <= 3 then
                            class_out <= x"79"; -- y
                        else
                            class_out <= x"33"; -- 3
                        end if;
                    else
                        if r4 <= 71 then
                            if r7 <= 118 then
                                class_out <= x"33"; -- 3
                            else
                                class_out <= x"79"; -- y
                            end if;
                        else
                            if r1 <= 120 then
                                if r7 <= 53 then
                                    class_out <= x"69"; -- i
                                else
                                    if r15 <= 2 then
                                        class_out <= x"79"; -- y
                                    else
                                        class_out <= x"69"; -- i
                                    end if;
                                end if;
                            else
                                class_out <= x"61"; -- a
                            end if;
                        end if;
                    end if;
                else
                    if r1 <= 69 then
                        if r9 <= 208 then
                            class_out <= x"33"; -- 3
                        else
                            if f5 <= 102 then
                                class_out <= x"38"; -- 8
                            else
                                class_out <= x"69"; -- i
                            end if;
                        end if;
                    else
                        if f4 <= 118 then
                            if r13 <= 83 then
                                class_out <= x"78"; -- x
                            else
                                class_out <= x"34"; -- 4
                            end if;
                        else
                            class_out <= x"35"; -- 5
                        end if;
                    end if;
                end if;
            end if;
 
        else
            if f6 <= 81 then
                if r6 <= 135 then
                    class_out <= x"63"; -- c
                else
                    class_out <= x"6F"; -- o
                end if;
            else
                if r6 <= 25 then
                    class_out <= x"63"; -- c
                else
                    class_out <= x"6F"; -- o
                end if;
            end if;
        end if;
    end if;
 
end process;
 
end behv;