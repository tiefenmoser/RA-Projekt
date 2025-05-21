-- Laboratory RA solutions/versuch4
-- Sommersemester 25
-- Group Details
-- Lab Date:
-- 1. Participant First and Last Name: Cornelius Tiefenmoser 
-- 2. Participant First and Last Name: Maxi Gromut
-- 3. Participant First and Last Name: Rupert Honold

-- ========================================================================
-- Author:       Marcel Rieß
-- Last updated: 14.05.2025
-- Description:  R-Only-RISC-V foran incomplete RV32I implementation, support
--               only R-Instructions. 
--
-- ========================================================================

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use work.constant_package.all;
  use work.types.all;
  use work.util_asm_package.all;
  
entity R_only_RISC_V_2_tb is
end entity R_only_RISC_V_2_tb;

architecture structure of R_only_RISC_V_2_tb is

  constant PERIOD                : time                                           := 10 ns;
  -- signals
  -- begin solution:
  signal s_clk,s_rst : std_logic := '0';
  signal s_expectedOut : std_logic_vector (WORD_WIDTH-1 downto 0) := (others => '0');
  -- end solution!!
  signal   s_registersOut    : registerMemory := (others => (others => '0'));
  signal   s_instructions : memory                                     := (
    -- begin solution:
    1=> std_logic_vector'("0" & ADD_ALU_OP (ALU_OPCODE_WIDTH - 1) & "00000" & std_logic_vector(to_unsigned(2, REG_ADR_WIDTH)) & std_logic_vector(to_unsigned(1, REG_ADR_WIDTH)) & ADD_ALU_OP(ALU_OPCODE_WIDTH - 2 downto 0) & std_logic_vector(to_unsigned( 2, REG_ADR_WIDTH)) & R_INS_OP),
    5=> std_logic_vector'("0" & ADD_ALU_OP (ALU_OPCODE_WIDTH - 1) & "00000" & std_logic_vector(to_unsigned(2, REG_ADR_WIDTH)) & std_logic_vector(to_unsigned(1, REG_ADR_WIDTH)) & ADD_ALU_OP(ALU_OPCODE_WIDTH - 2 downto 0) & std_logic_vector(to_unsigned( 2, REG_ADR_WIDTH)) & R_INS_OP),
    9=> std_logic_vector'("0" & ADD_ALU_OP (ALU_OPCODE_WIDTH - 1) & "00000" & std_logic_vector(to_unsigned(2, REG_ADR_WIDTH)) & std_logic_vector(to_unsigned(1, REG_ADR_WIDTH)) & ADD_ALU_OP(ALU_OPCODE_WIDTH - 2 downto 0) & std_logic_vector(to_unsigned( 2, REG_ADR_WIDTH)) & R_INS_OP),
    13=> std_logic_vector'("0" & ADD_ALU_OP (ALU_OPCODE_WIDTH - 1) & "00000" & std_logic_vector(to_unsigned(2, REG_ADR_WIDTH)) & std_logic_vector(to_unsigned(1, REG_ADR_WIDTH)) & ADD_ALU_OP(ALU_OPCODE_WIDTH - 2 downto 0) & std_logic_vector(to_unsigned( 2, REG_ADR_WIDTH)) & R_INS_OP),
    17=> std_logic_vector'("0" & ADD_ALU_OP (ALU_OPCODE_WIDTH - 1) & "00000" & std_logic_vector(to_unsigned(2, REG_ADR_WIDTH)) & std_logic_vector(to_unsigned(1, REG_ADR_WIDTH)) & ADD_ALU_OP(ALU_OPCODE_WIDTH - 2 downto 0) & std_logic_vector(to_unsigned( 2, REG_ADR_WIDTH)) & R_INS_OP),

    others => (others => '0')
  -- end solution!!
                                  );

begin
-- Instanziierung der Entity
riscv_inst : entity work.R_only_RISC_V
  port map (
    pi_rst             => s_rst,
    pi_clk             => s_clk,
    pi_instruction     => s_instructions,
    po_registersOut    => s_registersOut
  );

  process is
  variable v_expected : integer := 0;

  begin
   wait for PERIOD/2;
   for i in 1 to 21 loop
      s_clk <= '1';
      wait for PERIOD / 2;
      s_clk <= '0';
      wait for PERIOD / 2;

    -- begin solution:
    if (i = 5) then
        assert (to_integer(signed(s_registersOut(2))) = 9 + 8 )
         report " Error  value in registry is: " & integer'image(to_integer(signed(s_registersOut(2)))) & " but should contain " & integer'image(9+8) & " after cycle" & to_string(i)
          severity error;
    end if;      
    if (i = 9) then
        assert (to_integer(signed(s_registersOut(2))) = 9*2 + 8 )
         report " Error  value in registry is: " & integer'image(to_integer(signed(s_registersOut(2)))) & " but should contain " & integer'image(9 *2 +8) & " after cycle" & to_string(i)
          severity error;
    end if;
    if (i = 13) then
        assert (to_integer(signed(s_registersOut(2))) = 9*3 + 8 )
         report " Error  value in registry is: " & integer'image(to_integer(signed(s_registersOut(2)))) & " but should contain " & integer'image(9 *3 +8) & " after cycle" & to_string(i)
          severity error;
    end if;
    if (i = 17) then
        assert (to_integer(signed(s_registersOut(2))) = 9*4 + 8 )
         report " Error  value in registry is: " & integer'image(to_integer(signed(s_registersOut(2)))) & " but should contain " & integer'image(9 *4 +8) & " after cycle" & to_string(i)
          severity error;
    end if;
    
-- end solution!!

    end loop;
    report "End of test!!!";
wait;

  end process;

end architecture;
