-- 1. Partner: Cornelius Tiefenmoser
-- 2. Partner: Maxi Gromut
-- 3. Partner: Rupert Honold

library ieee;
use ieee.std_logic_1164.all;
use work.constant_package.all;


entity single_bit_pipelineregister is
    port(
        pi_data,pi_clk,pi_rst: in std_logic := '0';

        po_data : out std_logic := '0'
    );
end single_bit_pipelineregister;


architecture behavior of single_bit_pipelineregister is    

    begin
    -- Der process setzt den output des registers po_data bei der steigenden flanke der clock 
    -- auf 0 falls pi_rst 1 ist sonst zum eingang des registers pi_data
    pr: process (pi_clk,pi_rst)
        begin
            if(pi_rst = '1') then
                po_data  <=  '0';
			elsif rising_edge(pi_clk) then
                       po_data <= pi_data;
            end if;
        end process pr;
end architecture behavior;
