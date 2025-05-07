-- Laboratory RA solutions/versuch2
-- Sommersemester 25
-- Group Details
-- Lab Date:
-- 1. Participant First and Last Name: Cornelius Tiefenmoser
-- 2. Participant First and Last Name: Maxi Gromut

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use ieee.math_real.all;
  use work.constant_package.all;

entity register_file_tb is
    generic(
        G_reg_adr_width : integer := REG_ADR_WIDTH;
        G_word_width : integer := WORD_WIDTH
    );
end entity register_file_tb;

architecture behavior of register_file_tb is
    signal s_clk,s_rst,s_writeEnable: std_logic;    


    signal s_readAddr1,s_readAddr2,s_writeAddr : std_logic_vector (G_reg_adr_width-1 downto 0);
    signal s_writeData : std_logic_vector (G_word_width-1 downto 0);

    signal s_readData1, s_readData2 : std_logic_vector (G_word_width-1 downto 0);
    
    signal s_expected1, s_expected2 : std_logic_vector (G_word_width-1 downto 0);

    constant c_clk_period :time := 10 ns;

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
        reg: entity work.register_file
            generic map(G_reg_adr_width,G_word_width)
            port map(
                pi_clk => s_clk,
                pi_rst => s_rst,
                pi_writeEnable => s_writeEnable,
                pi_readRegAddr1 => s_readAddr1,
                pi_readRegAddr2 => s_readAddr2,
                pi_writeRegAddr => s_writeAddr,
                pi_writeRegData => s_writeData,
                po_readRegData1 => s_readData1,
                po_readRegData2 => s_readData2
            );

        reg_test: process is
            begin
                s_rst <= '0';
                s_writeData <= (others => '1');
                s_writeEnable <= '1';
                s_readAddr1 <= (others => '0');
                s_readAddr2 <= (others => '0');
                -- writing to the lower half of all the registrys
                for i in 0 to 2**(G_reg_adr_width/2) loop
                    s_writeAddr <= std_logic_vector(to_unsigned(i,s_writeAddr'length));
                    wait for c_clk_period; -- ensuring im writing to the lower half of the registrys
                    end loop;
                assert false report "Finished Writing" severity note;
                s_writeEnable <= '0'; 
                s_expected1 <= (others => '0');-- read adress is already 0
                wait for c_clk_period;
                assert(s_readData1 = s_expected1 ) report "reg 0 not 0 after writing to it" severity error;

                s_expected1 <= (others => '1');
                s_expected2 <= (others => '1');
                -- checking if were reading the right values for the lower half
                for i in 1 to 2**(G_reg_adr_width/2) loop
                    s_readAddr1 <= std_logic_vector(to_unsigned(i,s_readAddr1'length));
                    s_readAddr2 <= std_logic_vector(to_unsigned(i,s_readAddr2'length));
                    wait for c_clk_period;
                    assert(s_readData1 = s_expected1 ) report "read data 1 is not remebered for i= " & to_string(i) severity error;
                    assert(s_readData2 = s_expected2 ) report "read data 2 is not remebered for i= " & to_string(i) severity error;
                    end loop;
                assert false report "Finished Testing lower half" severity note;
                
                s_expected1 <= (others => '0');
                s_expected2 <= (others => '0');
                -- i just test that we dont randomly get 1s  
                for i in 2**(G_reg_adr_width/2)+1 to 2**(G_reg_adr_width)-1 loop
                    s_readAddr1 <= std_logic_vector(to_unsigned(i,s_readAddr1'length));
                    s_readAddr2 <= std_logic_vector(to_unsigned(i,s_readAddr2'length));
                    wait for c_clk_period;
                    assert(s_readData1 = s_expected1 ) report "read data 1 is not zero for i= " & to_string(i) severity error;
                    assert(s_readData2 = s_expected2 ) report "read data 2 is not zero for i= " & to_string(i) severity error;
                    end loop;
                assert false report "Finished Testing upper half" severity note;

                s_rst <= '1';
                for i in 0 to 2**G_reg_adr_width-1 loop
                    s_readAddr1 <= std_logic_vector(to_unsigned(i,s_readAddr1'length));
                    s_readAddr2 <= std_logic_vector(to_unsigned(i,s_readAddr2'length));
                    wait for c_clk_period;
                    assert(s_readData1 = s_expected1 ) report "didn't reset for i= " & to_string(i) severity error;
                    assert(s_readData2 = s_expected2 ) report "didn't for i= " & to_string(i) severity error;
                    end loop;
                assert false report "Finished reset test" severity note;
                wait;
        end process;    
end architecture behavior;