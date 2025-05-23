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
                    when others =>
                        v_insFormat := nullFormat;
                end case;

                
                case v_insFormat is
                    when rFormat => 
                        po_controlWord.REG_WRITE <= '1';
                        po_controlWord.ALU_OP <= v_func7(5) & v_func3;
                    when iFormat =>
                        po_controlWord.REG_WRITE <= '1';
                        po_controlWord.I_IMM_SEL <= '1';
                        po_controlWord.ALU_OP <= v_func7(5) & v_func3;
                    when others => 
                        po_controlWord.REG_WRITE <= '0';
                        po_controlWord.ALU_OP <= (others => '0');
                 end case;
        end process;    
    -- end solution!!
end architecture;