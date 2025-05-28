-- 1.Partner: Cornelius Tiefenmoser
-- 2.Partner: Maxi Gromut


library ieee;
use ieee.std_logic_1164.all;
use work.constant_package.all;


entity gen_mux is 
    generic(
        G_DATA_WIDTH: integer := DATA_WIDTH_GEN
    );
    port(
        pi_first,pi_second: in std_logic_vector(G_DATA_WIDTH-1 downto 0) := (others => '0');
        pi_sel: in std_logic := '0';

        po_result: out std_logic_vector(G_DATA_WIDTH-1 downto 0) := (others => '0')
    );
end gen_mux;

architecture behavior of gen_mux is
    begin
    with pi_sel select
        po_result <= pi_first when '0',
                     pi_second when '1',
					 (others => '0') when others;



end architecture;
