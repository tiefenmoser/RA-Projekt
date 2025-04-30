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

    component half_add
        port(
            a, b: in std_logic;
            r, c: out std_logic
        );
    end component;

    begin
        HA1:half_add port map (PI_A,PI_B,s_sum,s_c1);
        HA2:half_add port map (s_sum,PI_C,PO_R,s_c2);

        PO_C <= s_c1 OR s_c2;
end behave;