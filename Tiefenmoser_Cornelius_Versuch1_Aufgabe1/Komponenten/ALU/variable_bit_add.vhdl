library ieee;
use ieee.std_logic_1164.all;
use work.Constant_Package.all;


entity variable_bit_add is
    Generic (
    G_DATA_WIDTH : integer := DATA_WIDTH_GEN
    );
    port(
      PI_A, PI_B: in std_logic_vector (G_DATA_WIDTH-1 downto 0);
      PI_SUBTRACT: in std_logic;
      -- for adding always 0 if you want to subtract you set it to 1


      PO_RESULT: out std_logic_vector (G_DATA_WIDTH-1 downto 0);
      PO_C: out std_logic
    );
end variable_bit_add; 

--TODO:Test it i have no idea if this works ngl
architecture structure of variable_bit_add is
    signal s_ib: std_logic_vector (G_DATA_WIDTH-1 downto 0);
    signal s_carry: std_logic_vector (G_DATA_WIDTH-1 downto 0);
    begin
    s_carry(0) <= PI_SUBTRACT;
    genthing: 
        for i in 0 to G_DATA_WIDTH-1 generate
            s_ib(i) <= PI_B(i) xor PI_SUBTRACT;
            commoncase: if i /= G_DATA_WIDTH-1 generate
                fa_behave: entity work.full_add(behave)
                port map (PI_A(i),s_ib(i),s_carry(i),PO_RESULT(i),s_carry(i+1));
            end generate;
            endcase: if i = G_DATA_WIDTH-1 generate
                fa_behave: entity work.full_add(behave)
                port map (PI_A(i),s_ib(i),s_carry(i),PO_RESULT(i),PO_C);
            end generate;
        end generate;
end structure;
