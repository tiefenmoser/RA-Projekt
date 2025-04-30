library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constant_package.all;

entity gen_mux_tb is
end entity;


architecture behavior of gen_mux_tb is
    signal s_op1            : std_logic_vector(31 downto 0) := (others => '0');
    signal s_op2            : std_logic_vector(31 downto 0) := (others => '0');
    signal s_sel            : std_logic;
    constant c_testWidths     : integer_vector := (5,6,8,16,32);
    begin
        testgen: for i in 0 to length(c_testWidths)-1 generate
        -- generate all the test for the given band width    
            mux: entity work.gen_mux
                generic map (c_testWidths(i))
                port map(
                    pi_first => s_op1(c_testWidths(i)-1 downto 0),
                    pi_second => s_op2(c_testWidths(i)-1 downto 0),
                    pi_sel => s_sel
                );

            mux_test: process is 
                begin
                    

            end process;
        end generate;
end architecture;