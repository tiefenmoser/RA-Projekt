library ieee;
use ieee.std_logic_1164.all;
use work.constant_package.all;


entity PipelineRegister_tb is
end entity;



architecture behavior of PipelineRegister_tb is
	signal s_clk, s_rst      : std_logic := '0';
	signal s_data            : std_logic_vector(31 downto 0) := (others => '0');
    signal s_dataout         : std_logic_vector(31 downto 0) := (others => '0');
    signal s_expected        : std_logic_vector(31 downto 0) := (others => '0');
 
 
    constant c_testWidths     : integer_vector := (5,6,8,16,32);

	begin

		testgen: for i in 0 to 4 generate
			pr: entity work.pipelineregister
				generic map (c_testWidths(i))
                port map(
                     pi_data => s_data(c_testWidths(i)-1 downto 0),
                     pi_clk => s_clk,
 					 pi_rst => s_rst,

                     po_data => s_dataout(c_testWidths(i)-1 downto 0)
                 );
			clock: process is
				begin
						s_clk<='0';
						wait for 1 ns;
						s_clk <= '1';
						wait for 1 ns;
			end process;	
			pr_test: process is
				begin
					s_data <= (others => '0');
					s_expected <= (others => '0');
					wait for 2 ns;
					s_rst <= '1';
					assert (s_dataout = s_expected) report "rst doesnt set to 0 with data 0" severity error;

					s_data <= (others => '1');
					s_expected <= (others => '0');
					wait for 2 ns;
					s_rst <= '1';
					assert (s_dataout = s_expected) report "rst doesnt set to 0 with data 1" severity error;
					
					s_rst <= '0';	
					s_data <= (others => '1');
					s_expected <= (others => '1');
					wait for 2 ns;
					assert (s_dataout = s_expected) report "doesnt set to 1" severity error;

					s_rst <= '0';	
					s_data <= (others => '0');
					s_expected <= (others => '0');
					wait for 2 ns;
					assert (s_dataout = s_expected) report "doesnt set to 0 through data" severity error;

					assert false report "End of test for: " & to_string(i) severity note;
					wait;
			end process;		
		end generate;
end architecture;
		
