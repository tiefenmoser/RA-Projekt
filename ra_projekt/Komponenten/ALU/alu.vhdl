-- 1. Partner: Cornelius Tiefenmoser
-- 2. Partner: Maxi Gromut
-- 3. Partner: Rupert Honold
-- Teile der Logik hauptsächlich die Shifter logik von Leonard Habrom

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
        pi_op1, pi_op2 : in STD_LOGIC_VECTOR(G_DATA_WIDTH -1 downto 0) := (others => '0'); 
        pi_aluOp : in STD_LOGIC_VECTOR(G_OP_WIDTH -1 downto 0):= (others => '0');
        
        po_aluOut : out STD_LOGIC_VECTOR(G_DATA_WIDTH -1 downto 0) := (others => '0');
        po_carryOut,po_zero : out std_logic := '0'
    );
end alu;   


architecture behavior of alu is 
    signal s_op1,s_op2,s_addr,s_subr,s_andr,s_orr,s_xorr,s_shiftr,s_sltr,s_sltur : std_logic_vector(G_DATA_WIDTH -1 downto 0) := (others => '0'); 
    signal s_addc,s_subc,s_shift_type,s_shift_direction: std_logic := '0';
	begin
		s_op1 <= pi_op1;
		s_op2 <= pi_op2;

        ADD: entity work.variable_bit_add generic map (G_DATA_WIDTH) port map (s_op1,s_op2,'0',s_addr,s_addc);
        SUB: entity work.variable_bit_add generic map (G_DATA_WIDTH) port map (s_op1,s_op2,'1',s_subr,s_subc);
        ANDi:  entity work.gen_and generic map (G_DATA_WIDTH) port map (s_op1, s_op2, s_andr); 
        ORi:  entity work.gen_or generic map (G_DATA_WIDTH) port map (s_op1, s_op2, s_orr); 
        XORi:  entity work.gen_xor generic map (G_DATA_WIDTH) port map (s_op1, s_op2, s_xorr); 
        Shift: entity work.shifter generic map (G_DATA_WIDTH) port map (s_op1, s_op2, s_shift_type, s_shift_direction, s_shiftr);
        SLT: entity work.slt generic map (G_DATA_WIDTH) port map(s_op1,s_op2,s_sltr);
        SLTU: entity work.sltu generic map (G_DATA_WIDTH) port map(s_op1,s_op2,s_sltur);

        
        with pi_aluOp select
            po_aluOut <= s_addr when ADD_ALU_OP,
                         s_subr when SUB_ALU_OP,
                         s_andr when AND_ALU_OP,
                         s_orr  when OR_ALU_OP,
                         s_xorr when XOR_ALU_OP,
                         s_shiftr when SLL_ALU_OP,
                         s_shiftr when SRL_ALU_OP,
                         s_shiftr when SRA_ALU_OP,
                         s_sltr when SLT_ALU_OP,
                         s_sltur when SLTU_ALU_OP,
				 		 pi_op1 when others;

        po_zero <= '1' when po_aluOut = STD_LOGIC_VECTOR(to_unsigned(0,G_DATA_WIDTH)) else '0'; -- does this work??

		with pi_aluOp select
				po_carryOut <= s_addc when ADD_ALU_OP,
							   s_subc when SUB_ALU_OP,
							   '0'    when others;
		with pi_aluOp select
				s_shift_type <= '0' when SLL_ALU_OP,
								'0' when SRL_ALU_OP,
								'1' when SRA_ALU_OP,
								'0' when others;
		with pi_aluOp select
					s_shift_direction <= '0' when SLL_ALU_OP,
								  	     '1' when SRL_ALU_OP,
									     '1' when SRA_ALU_OP,
									     '0' when others;
                                         
end behavior;

