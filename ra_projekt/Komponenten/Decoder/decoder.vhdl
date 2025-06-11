-- Laboratory RA solutions/versuch3
-- Sommersemester 25
-- Group Details
-- Lab Date: 
-- 1. Participant First and Last Name: Cornelius Tiefenmoser
-- 2. Participant First and Last Name: Maxi Gromut
-- 3. Participant First and Last Name: Rupert Honold

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.Constant_package.all;
use work.types.all;

entity decoder is
    -- begin solution:
    generic(
        G_word_width : integer := WORD_WIDTH
    );
    port(
        pi_instruction : in std_logic_vector(G_word_width-1 downto 0) := (others => '0');
        po_controlWord : out controlword := control_word_init
    );
    -- end solution!!
end entity decoder;
architecture arc of decoder is
    -- begin solution:
    begin
        decoder_process: process (pi_instruction)
            variable v_func3 : std_logic_vector (2 downto 0) := (others => '0');
            variable v_func7 : std_logic_vector (6 downto 0) := (others => '0');
            variable v_shift_I_4th_bit : std_logic := '0';
            variable v_opcode : std_logic_vector (6 downto 0) := (others => '0');
            variable v_insFormat : t_instruction_type := nullFormat;
            begin
                v_func3 := pi_instruction(14 downto 12);
                v_func7 := pi_instruction(31 downto 25);
                v_opcode := pi_instruction(6 downto 0);


                case v_opcode is
                    when R_INS_OP =>
                        v_insFormat := rFormat;
                    when I_INS_OP =>
                        v_insFormat := iFormat;
                    when LUI_INS_OP =>
                        v_insFormat := uFormat;
                    when AUIPC_INS_OP =>
                        v_insFormat := uFormat;
                    when JAL_INS_OP =>
                        v_insFormat := jFormat;    
                    when JALR_INS_OP =>
                        v_insFormat := iFormat;  
                    when B_INS_OP =>
                        v_insFormat := bFormat;
                    when others =>
                        v_insFormat := nullFormat;
                end case;

                
                po_controlWord <= control_word_init;
                v_shift_I_4th_bit := v_func7(5) when v_func3 = SRA_ALU_OP(2 downto 0);
                case v_insFormat is
                    when rFormat => 
                        po_controlWord.REG_WRITE <= '1';
                        po_controlWord.ALU_OP <= v_func7(5) & v_func3;
                    when iFormat =>
                        po_controlWord.REG_WRITE <= '1';
                        po_controlWord.I_IMM_SEL <= '1';
                        if v_opcode = JALR_INS_OP then 
                            po_controlWord.ALU_OP <= ADD_ALU_OP;
                            po_controlWord.PC_SEL <= '1';
                            po_controlWord.WB_SEL <= "10";

                        else
                            po_controlWord.ALU_OP <= v_shift_I_4th_bit & v_func3;
                            -- po_controlWord.WB_SEL <= "01"; -- i thought i neeeded this i guess not lmao
                        end if;
                    when uFormat =>
                        po_controlWord.I_IMM_SEL <= '1';
                        po_controlWord.REG_WRITE <= '1';
                        po_controlWord.WB_SEL <= "01"  when v_opcode=LUI_INS_OP ;
                        po_controlWord.ALU_OP <= ADD_ALU_OP when v_opcode=AUIPC_INS_OP; -- this is only here for readablity should already be 0 anyway
                        po_controlWord.A_SEL <= '1' when v_opcode=AUIPC_INS_OP; 
                    when jFormat =>
                        po_controlWord.I_IMM_SEL <= '1';
                        po_controlWord.REG_WRITE <= '1';
                        po_controlWord.WB_SEL <= "10";
                        po_controlWord.A_SEL <= '1';
                        po_controlWord.PC_SEL <= '1';
                    when bFormat =>
                        po_controlWord.CMP_RESULT <= v_func3(0) when v_func3(2) = '0' else not v_func3(0) ; -- das ist nachvollziehbar vertrau
                        po_controlWord.IS_BRANCH <= '1';
                        with v_func3 select 
                            po_controlWord.ALU_OP <= SUB_ALU_OP when FUNC3_BEQ,
                                                     SUB_ALU_OP when FUNC3_BNE,
                                                     SLT_ALU_op when FUNC3_BLT,
                                                     SLTU_ALU_op when FUNC3_BLTU,
                                                     SLT_ALU_OP when FUNC3_BGE,-- invert the cmp result for this
                                                     SLTU_ALU_op when FUNC3_BGEU, 
                                                     (others => '0') when others;
                    when others => 
                        po_controlWord <= control_word_init; -- doppelt hält besser oder so
                 end case;
        end process;    
    -- end solution!!
end architecture;