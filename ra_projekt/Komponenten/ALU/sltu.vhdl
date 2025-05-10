library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constant_package.all;

entity sltu is
    generic(
        G_DATA_WIDTH: integer := DATA_WIDTH_GEN
    );
    port(
        PI_A,PI_B: in std_logic_vector(G_DATA_WIDTH-1 downto 0);

        PO_R: out std_logic_vector(G_DATA_WIDTH-1 downto 0)
    );
end sltu;



architecture behave of sltu is
    begin
        PO_R <=
        std_logic_vector(to_signed(1,G_DATA_WIDTH)) when (unsinged(PI_A)< unsinged(PI_B)) else
        std_logic_vector(to_signed(0,G_DATA_WIDTH)) when (unsinged(PI_A)>= unsinged(PI_B)); 
end architecture;