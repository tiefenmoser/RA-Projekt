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
use work.types_package.all;


entity register_file is
    generic(
        G_reg_adr_width : integer := REG_ADR_WIDTH;
        G_word_width : integer := WORD_WIDTH
    );
    port(
        pi_clk,pi_rst,pi_writeEnable : in std_logic;
        pi_readRegAddr1,pi_readRegAddr2,pi_writeRegAddr: in std_logic_vector( G_reg_adr_width-1 downto 0);
        pi_writeRegData : in std_logic_vector(G_word_width-1 downto 0);
        
        po_readRegData1,po_readRegData2 : out std_logic_vector (G_word_width -1 downto 0)
    );
end entity;


architecture structure of register_file is
    signal REG : registermemory := (others => (others => '0')); -- already conforms to the reg_amount required
    
    begin
        register_process : process (pi_rst,pi_clk)
            begin
                if pi_rst = '1' then 
                    reg <= (others => (others => '0')); 
                    po_readRegData1 <= REG(to_integer(unsigned(pi_readRegAddr1)));
                    po_readRegData2 <= REG(to_integer(unsigned(pi_readRegAddr2)));
                elsif rising_edge(pi_clk) then
                    if pi_writeEnable = '1' then
                        if to_integer(unsigned(pi_writeRegAddr)) /= 0 then -- ensures x0 will always be 0
                            REG(to_integer(unsigned(pi_writeRegAddr))) <= pi_writeRegData;
                        end if;
                        -- since i couldnt really find out what the behavior should be if we set the data of the to be read adresses
                        -- i will not do the hack fix from the single port ram and the logic to find out if the write and read adresses match 
                        end if;
                    po_readRegData1 <= REG(to_integer(unsigned(pi_readRegAddr1)));
                    po_readRegData2 <= REG(to_integer(unsigned(pi_readRegAddr2))); 
                end if;


            end process;                

end architecture;
