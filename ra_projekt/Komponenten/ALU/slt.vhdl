library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constant_package.all;

entity slt is
    generic(
        G_data_width : integer := DATA_WIDTH_GEN
    );
    port(
        pi_val1 , pi_val2: in std_logic_vector(G_data_width-1 downto 0);

        po_value : out std_logic_vector(G_data_width-1 downto 0)
    );
end slt;


architecture behave of slt is
    begin
        -- what is the difference between signed vs to_signed
    po_value <= std_logic_vector(to_signed(1,G_data_width)) when signed(pi_val1) < signed(pi_val2) else
               std_logic_vector(to_signed(0,G_data_width));
        
end architecture;    