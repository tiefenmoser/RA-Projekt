library ieee;
use ieee.std_logic_1164.all;
use work.constant_package.all;


entity pipelineregister is
    generic(
        G_DATA_WIDTH: integer := DATA_WIDTH_GEN
    );
    port(
        pi_data : in std_logic_vector (G_DATA_WIDTH-1 downto 0);
        pi_clk,pi_rst: in std_logic;

        po_data : out std_logic_vector (G_DATA_WIDTH-1 downto 0)
    );
end pipelineregister;


architecture behavior of pipelineregister is    
    signal s_regcontent: std_logic_vector(G_DATA_WIDTH-1 downto 0) ;
    ATTRIBUTE KEEP : BOOLEAN;--i think this should make it so that s_regcontents content persists but idk
    ATTRIBUTE KEEP OF s_regcontent : SIGNAL IS true;

    begin
    po_data <= s_regcontent; 
    -- Der process setzt den output des registers po_data bei der steigenden flanke der clock 
    -- auf 0 falls pi_rst 1 ist sonst zum eingang des registers pi_data
    pr: process (pi_clk,pi_rst)
        begin
            if rising_edge(pi_clk) then
                if(pi_rst = '0') then
                    s_regcontent <= (others => '0');
                else
                    s_regcontent <= pi_data;
                end if;
            end if;
        end process pr;
end architecture behavior;
