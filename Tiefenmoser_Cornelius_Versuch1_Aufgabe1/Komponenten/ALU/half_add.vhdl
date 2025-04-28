library ieee;
use ieee.std_logic_1164.all;


entity half_add is 
    port (
        PI_A, PI_B : in std_logic;
        PO_R, PO_C : out std_logic
    );
    begin
end half_add;

architecture behave of half_add is begin
        PO_R <= PI_A XOR PI_B;
        PO_C <= PI_A AND PI_B;
end behave;    