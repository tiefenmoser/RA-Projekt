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
use work.types.all;


entity register_file is
    generic(
        G_reg_adr_width : integer := REG_ADR_WIDTH;
        G_word_width : integer := WORD_WIDTH
    );
    port(
        pi_clk,pi_rst,pi_writeEnable : in std_logic := '0';
        pi_readRegAddr1,pi_readRegAddr2,pi_writeRegAddr: in std_logic_vector( G_reg_adr_width-1 downto 0):= (others => '0');
        pi_writeRegData : in std_logic_vector(G_word_width-1 downto 0):= (others => '0');
        
        po_readRegData1,po_readRegData2 : out std_logic_vector (G_word_width -1 downto 0):= (others => '0');
        po_registerOut: out registermemory:= (others => (others => '0'))
    );
end entity;


architecture structure of register_file is
    signal s_registers : registermemory := (1 => std_logic_vector(to_unsigned(9,G_word_width)),
                                            2 => std_logic_vector(to_unsigned(8,G_word_width)),
                                          others => (others => '0')); -- already conforms to the reg_amount required
    
    begin
        -- s_registers(1) <= std_logic_vector(to_unsigned(9,G_word_width));
        -- s_registers(2) <= std_logic_vector(to_unsigned(8,G_word_width));

        register_process : process (pi_rst,pi_clk)
            begin
                if pi_rst = '1' then 
                    s_registers <= (others => (others => '0')); 
                elsif rising_edge(pi_clk) then
                    if pi_writeEnable = '1' then
                        if to_integer(unsigned(pi_writeRegAddr)) /= 0 then -- ensures x0 will always be 0
                            s_registers(to_integer(unsigned(pi_writeRegAddr))) <= pi_writeRegData;
                        end if;
                        end if;
                end if;
            end process;                
            po_readRegData1 <= s_registers(to_integer(unsigned(pi_readRegAddr1)));
            po_readRegData2 <= s_registers(to_integer(unsigned(pi_readRegAddr2))); 
            po_registerOut <= s_registers;
end architecture;
