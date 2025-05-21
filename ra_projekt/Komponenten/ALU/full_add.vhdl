library ieee;
use ieee.std_logic_1164.all;

entity full_add is
    port(
        -- in: a , b, c (carry)
        PI_A, PI_B, PI_C: in std_logic;
        PO_R, PO_C: out std_logic
    );
end full_add;    


architecture behave of full_add is
    signal s_sum , s_c1, s_c2 : std_logic;

    begin
        HA1: entity work.half_add port map (PI_A=> PI_A,PI_B => PI_B, PO_R => s_sum, PO_C =>s_c1);
        HA2: entity work.half_add port map (s_sum,PI_C,PO_R,s_c2);

        PO_C <= s_c1 OR s_c2;
end behave;
