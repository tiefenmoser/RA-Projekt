-- Laboratory RA solutions/versuch3
-- Sommersemester 25
-- Group Details
-- Lab Date:
-- 1. Participant First and Last Name: Cornelius Tiefenmoser
-- 2. Participant First and Last Name: Maxi Gromut

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
            variable v_func3 : std_logic_vector (2 downto 0);
            variable v_func7 : std_logic_vector (6 downto 0);
            variable v_opcode : std_logic_vector (6 downto 0);
            variable v_insFormat : t_instruction_type ;
            begin
                -- TODO: think of a better way to detect change not even sure if this works
                v_func3 := pi_instruction(14 downto 12);
                v_func7 := pi_instruction(31 downto 25);
                v_opcode := pi_instruction(6 downto 0);
                case v_opcode is
                    when R_INS_OP =>
                        v_insFormat := rFormat; -- i think this is right
                    when others =>
                end case;

                po_controlWord.REG_WRITE <= '1';
                po_controlWord.ALU_OP <= v_func7(5) & v_func3;
                
                
                -- case v_func3 is
                --     when "000" => 
                --         po_controlWord.REG_WRITE <= '1';
                --         if v_func7(5) = '1' then
                --             po_controlWord.ALU_OP <= SUB_ALU_OP;
                --         elsif v_func7(5) = '0' then
                --             po_controlWord.ALU_OP <= ADD_ALU_OP;
                --         end if;
                --     when others => 
                -- end case;
        end process;    
    -- end solution!!
end architecture;