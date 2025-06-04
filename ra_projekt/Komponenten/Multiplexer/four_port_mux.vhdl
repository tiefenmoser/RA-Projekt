library ieee;
use IEEE.std_logic_1164.all;
use work.constant_package.all;

entity four_port_mux is
    generic(
        G_data_width: integer := DATA_WIDTH_GEN
    );
    port (
      pi_0,pi_1,pi_2,pi_3: in STD_LOGIC_VECTOR (G_data_width-1 downto  0) := (others => '0') ;
      pi_sel: in STD_LOGIC_VECTOR(1 downto 0);

      po_result: out STD_LOGIC_VECTOR(G_data_width-1 downto 0) := (others => '0') 

    );
end entity four_port_mux;



architecture behavior of four_port_mux is
    begin
        with pi_sel select 
            po_result <= pi_0 when "00",
                         pi_1 when "01",
                         pi_2 when "10",
                         pi_3 when "11",
                         (others => '0') when others;
end architecture; 