library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;
use work.constant_package.all;




entity Single_Port_RAM_tb is
end entity;


architecture behavior of Single_Port_RAM_tb is
    signal s_clk, s_rst, s_we: std_logic := '0';
    
    
    signal s_addr : std_logic_vector (31 downto 0) := (others => '0');
    signal s_data : std_logic_vector(15 downto 0);
    signal s_dataout :std_logic_vector (15 downto 0);
    signal s_expected : std_logic_vector( 15 downto 0);
    
    -- Why do i get different results for different clock times??????
    constant c_clk_period : time := 10 ns;

    begin
    -- CLK Process aus der übung von Stefanie Häberle 
    clk_process : process
        begin
            while now < 200 ns loop  -- Simulation fuer 200 ns
                s_clk <= '0';
                wait for c_clk_period / 2;
                s_clk <= '1';
                wait for c_clk_period / 2;
            end loop;
            wait;
    end process;

    ram:entity work.single_port_ram
        generic map(16,32)
        port map(
            pi_data => s_data,
            pi_addr => s_addr,
            
            pi_we => s_we,
            pi_clk => s_clk,
            pi_rst => s_rst,

            po_data => s_dataout
        );


    spr_test: process is             
        begin
            s_addr <= (others => '0');
            -- cant test for 32 adr range as ghdl gives me weird range bug errors
            for i in 0 to 15 loop
                
                s_data <= (others => '1');
                s_we <= '1'; 
                s_expected <= (others => '0');
                s_rst <= '1';
                wait for c_clk_period;
                assert(s_dataout = s_expected) report ("Doesnt reset to 0") severity error;
                
                
                s_rst <= '0'; 
                s_data <= (others => '1');
                s_we <= '1'; 
                s_expected <= (others => '1');
                wait for c_clk_period;
                assert(s_dataout = s_expected) report ("Data doesnt set to 1 with we = 1 actual value of s_dataout: " & to_string(s_dataout))
                severity error;

                s_data <= (others => '0');
                s_we <= '1'; 
                s_expected <= (others => '0');
                wait for c_clk_period;
                assert(s_dataout = s_expected) report ("Data doesnt set to 0 with we = 1 actual value of s_dataout: " & to_string(s_dataout)) 
                severity error;

                s_data <= (others => '1');
                s_we <= '0'; 
                s_expected <= (others => '0');
                wait for c_clk_period;
                assert(s_dataout = s_expected) report ("Data sets to 1 despite we = 0") severity error;

                assert false report "End of test for address: " & to_string(s_addr) severity note;
                s_addr <= std_logic_vector(to_unsigned(2**i,s_addr'length) ); 
            end loop;
        end process;                


end architecture;