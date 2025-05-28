-- 1. Participant First and Last Name: Cornelius Tiefenmoser
-- 2. Participant First and Last Name: Maxi Gromut
-- 3. Participant First and Last Name: Rupert Honold
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constant_package.all;

entity sltu is
    generic(
        G_data_width : integer := DATA_WIDTH_GEN
    );
    port(
        pi_val1 , pi_val2: in std_logic_vector(G_data_width-1 downto 0) := (others => '0');

        po_dest : out std_logic_vector(G_data_width-1 downto 0) := (others => '0')
        );
end sltu;



architecture behave of sltu is
    begin
    po_dest <= std_logic_vector(to_signed(1,G_data_width)) when unsigned(pi_val1) < unsigned(pi_val2) else
               std_logic_vector(to_signed(0,G_data_width));
end architecture;