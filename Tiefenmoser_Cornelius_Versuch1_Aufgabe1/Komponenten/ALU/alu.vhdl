library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.Constant_Package.all;

entity alu is
    generic (
    G_DATA_WIDTH  : integer := DATA_WIDTH_GEN;
    G_OP_WIDTH    : integer := 4
    );
    port (
        pi_op1, pi_op2 : in STD_LOGIC_VECTOR(G_DATA_WIDTH -1 downto 0); 
        pi_aluOp : in STD_LOGIC_VECTOR(G_OP_WIDTH -1 downto 0);
        
        po_aluOut : out STD_LOGIC_VECTOR(G_DATA_WIDTH -1 downto 0);
        po_carryOut : out std_logic
    );
end alu;   


architecture behavior of alu is 
    signal s_op1,s_op2,s_addr,s_subr,s_andr,s_orr,s_xorr,s_sllr,s_srlr,s_srar : std_logic_vector(G_DATA_WIDTH -1 downto 0); 
    begin
        --can i do this
        ADD: entity work.variable_bit_add generic map (G_DATA_WIDTH) port map (s_op1,s_op2,'0',s_addr);
        SUB: entity work.variable_bit_add generic map (G_DATA_WIDTH) port map (s_op1,s_op2,'1',s_addr);
        ANDi:  entity work.gen_xor generic map (G_DATA_WIDTH) port map (s_op1, s_op2, s_xorr); 
        ORi:  entity work.gen_or generic map (G_DATA_WIDTH) port map (s_op1, s_op2, s_orr); 
        XORi:  entity work.gen_xor generic map (G_DATA_WIDTH) port map (s_op1, s_op2, s_xorr); 
        
        --TODO: make the shifter
        
        with pi_aluOp select
            po_aluOut <= s_addr when ADD_ALU_OP,
                         s_subr when SUB_ALU_OP,
                         s_andr when AND_ALU_OP,
                         s_orr  when OR_ALU_OP,
                         s_xorr when XOR_ALU_OP,
                         s_sllr when SLL_ALU_OP,
                         s_srlr when SRL_ALU_OP,
                         s_srar when SRA_ALU_OP;


end behavior;

