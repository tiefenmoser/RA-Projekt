library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constant_package.all;

entity gen_mux_tb is
end entity;


architecture behavior of gen_mux_tb is
   	signal s_op1            : std_logic_vector(31 downto 0) := (others => '0');
   	signal s_op2            : std_logic_vector(31 downto 0) := (others => '1');
	signal s_sel            : std_logic := '0';
	signal s_out 			: std_logic_vector(31 downto 0) := (others => '0');
	signal s_expected 		: std_logic_vector(31 downto 0) := (others => '0');


    constant c_testWidths     : integer_vector := (5,6,8,16,32);
    begin
        testgen: for i in 0 to 4 generate
        -- generate all the test for the given band width    
			mux: entity work.gen_mux
                generic map (c_testWidths(i))
                port map(
                    pi_first => s_op1(c_testWidths(i)-1 downto 0),
                    pi_second => s_op2(c_testWidths(i)-1 downto 0),
                    pi_sel => s_sel,

					po_result => s_out(c_testWidths(i)-1 downto 0)
                );

            mux_test: process is 
                begin
					s_sel <= '0';
					s_expected <= s_op1;
					wait for 1 ns;
					assert (s_out = s_expected) report "Error in sel 0 Operation" severity error;			

					s_sel <= '1';
					s_expected <= s_op2;
					wait for 1 ns;
					assert (s_out = s_expected) report "Error in sel 1 Operation" severity error;			
					
					assert false report "End of test for: " & to_string(i) severity note;
					wait;
            end process;
        end generate;
end architecture;
