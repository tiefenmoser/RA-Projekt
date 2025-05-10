library ieee;
use ieee.std_logic_1164.all;
use work.constant_package.all;


entity gen_or is
    generic(
        G_DATA_WIDTH: integer := DATA_WIDTH_GEN
    );
    port(
      PI_A, PI_B: in std_logic_vector (G_DATA_WIDTH-1 downto 0);
      
      PO_RESULT: out std_logic_vector (G_DATA_WIDTH-1 downto 0)
    );
end gen_or;

architecture structure of gen_or is
    begin
        or_process: process (PI_A,PI_B)
        begin
            PO_RESULT <= PI_A or PI_B;
        end process;
end architecture;