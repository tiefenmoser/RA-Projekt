-- 1. Partner: Cornelius Tiefenmoser
-- 2. Partner: Maxi Gromut

library ieee;
use ieee.std_logic_1164.all;
use work.constant_package.all;


entity pipelineregister is
    generic(
        G_DATA_WIDTH: integer := DATA_WIDTH_GEN
    );
    port(
        pi_data : in std_logic_vector (G_DATA_WIDTH-1 downto 0) := (others => '0');
        pi_clk,pi_rst: in std_logic;

        po_data : out std_logic_vector (G_DATA_WIDTH-1 downto 0) := (others => '0')
    );
end pipelineregister;


architecture behavior of pipelineregister is    

    begin
    -- Der process setzt den output des registers po_data bei der steigenden flanke der clock 
    -- auf 0 falls pi_rst 1 ist sonst zum eingang des registers pi_data
    pr: process (pi_clk,pi_rst)
        begin
            if(pi_rst = '1') then
                po_data  <= (others => '0');
			elsif rising_edge(pi_clk) then
                       po_data <= pi_data;
            end if;
        end process pr;
end architecture behavior;
