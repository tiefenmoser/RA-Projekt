-- Laboratory RA solutions/versuch4
-- Sommersemester 25
-- Group Details
-- Lab Date:
-- 1. Participant First and Last Name: Cornelius Tiefenmoser 
-- 2. Participant First and Last Name: Maxi Gromut
-- 3. Participant First and Last Name: Rupert Honold

-- ========================================================================
-- Author:       Marcel Rieß
-- Last updated: 09.04.2025
-- Description:  R-Only-RISC-V foran incomplete RV32I implementation, support
--               only R-Instructions. 
--
-- ========================================================================

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use work.constant_package.all;
  use work.types.all;

entity R_only_RISC_V_tb is
end entity R_only_RISC_V_tb;

architecture structure of R_only_RISC_V_tb is

  constant PERIOD          : time                                           := 10 ns;
  -- signals
  signal   s_rst           : std_logic                                      := '0';
  signal   s_clk           : std_logic                                      := '0';

  signal   s_registersOut    : registerMemory := (others => (others => '0'));
  signal s_instructions : memory := (
    1=> std_logic_vector'("0" & OR_ALU_OP  (ALU_OPCODE_WIDTH - 1) & "00000" & std_logic_vector(to_unsigned(2, REG_ADR_WIDTH)) & std_logic_vector(to_unsigned(1, REG_ADR_WIDTH)) &  OR_ALU_OP(ALU_OPCODE_WIDTH - 2 downto 0) & std_logic_vector(to_unsigned(10, REG_ADR_WIDTH)) & R_INS_OP), -- R-Befehle haben alle den gleichen Opcode, daher hier hardkodiert
    2=> std_logic_vector'("0" & ADD_ALU_OP (ALU_OPCODE_WIDTH - 1) & "00000" & std_logic_vector(to_unsigned(2, REG_ADR_WIDTH)) & std_logic_vector(to_unsigned(1, REG_ADR_WIDTH)) & ADD_ALU_OP(ALU_OPCODE_WIDTH - 2 downto 0) & std_logic_vector(to_unsigned( 8, REG_ADR_WIDTH)) & R_INS_OP), -- R-Befehle haben alle den gleichen Opcode, daher hier hardkodiert
    3=> std_logic_vector'("0" & SUB_ALU_OP (ALU_OPCODE_WIDTH - 1) & "00000" & std_logic_vector(to_unsigned(2, REG_ADR_WIDTH)) & std_logic_vector(to_unsigned(1, REG_ADR_WIDTH)) & SUB_ALU_OP(ALU_OPCODE_WIDTH - 2 downto 0) & std_logic_vector(to_unsigned(11, REG_ADR_WIDTH)) & R_INS_OP), -- R-Befehle haben alle den gleichen Opcode, daher hier hardkodiert
    4=> std_logic_vector'("0" & SUB_ALU_OP (ALU_OPCODE_WIDTH - 1) & "00000" & std_logic_vector(to_unsigned(2, REG_ADR_WIDTH)) & std_logic_vector(to_unsigned(1, REG_ADR_WIDTH)) & SUB_ALU_OP(ALU_OPCODE_WIDTH - 2 downto 0) & std_logic_vector(to_unsigned(12, REG_ADR_WIDTH)) & R_INS_OP), -- R-Befehle haben alle den gleichen Opcode, daher hier hardkodiert
    5=> std_logic_vector'("0" & ADD_ALU_OP (ALU_OPCODE_WIDTH - 1) & "00000" & std_logic_vector(to_unsigned(8, REG_ADR_WIDTH)) & std_logic_vector(to_unsigned(2, REG_ADR_WIDTH)) & ADD_ALU_OP(ALU_OPCODE_WIDTH - 2 downto 0) & std_logic_vector(to_unsigned(12, REG_ADR_WIDTH)) & R_INS_OP), -- R-Befehle haben alle den gleichen Opcode, daher hier hardkodiert
    6=> std_logic_vector'("0" & SUB_ALU_OP (ALU_OPCODE_WIDTH - 1) & "00000" & std_logic_vector(to_unsigned(1, REG_ADR_WIDTH)) & std_logic_vector(to_unsigned(2, REG_ADR_WIDTH)) & SUB_ALU_OP(ALU_OPCODE_WIDTH - 2 downto 0) & std_logic_vector(to_unsigned(12, REG_ADR_WIDTH)) & R_INS_OP), -- R-Befehle haben alle den gleichen Opcode, daher hier hardkodiert
    7=> std_logic_vector'("0" & AND_ALU_OP (ALU_OPCODE_WIDTH - 1) & "00000" & std_logic_vector(to_unsigned(1, REG_ADR_WIDTH)) & std_logic_vector(to_unsigned(2, REG_ADR_WIDTH)) & AND_ALU_OP(ALU_OPCODE_WIDTH - 2 downto 0) & std_logic_vector(to_unsigned(12, REG_ADR_WIDTH)) & R_INS_OP), -- R-Befehle haben alle den gleichen Opcode, daher hier hardkodiert
    8=> std_logic_vector'("0" & XOR_ALU_OP (ALU_OPCODE_WIDTH - 1) & "00000" & std_logic_vector(to_unsigned(2, REG_ADR_WIDTH)) & std_logic_vector(to_unsigned(1, REG_ADR_WIDTH)) & XOR_ALU_OP(ALU_OPCODE_WIDTH - 2 downto 0) & std_logic_vector(to_unsigned(12, REG_ADR_WIDTH)) & R_INS_OP), -- R-Befehle haben alle den gleichen Opcode, daher hier hardkodiert
    9=> std_logic_vector'("0" & SUB_ALU_OP (ALU_OPCODE_WIDTH - 1) & "00000" & std_logic_vector(to_unsigned(8, REG_ADR_WIDTH)) & std_logic_vector(to_unsigned(1, REG_ADR_WIDTH)) & SUB_ALU_OP(ALU_OPCODE_WIDTH - 2 downto 0) & std_logic_vector(to_unsigned(14, REG_ADR_WIDTH)) & R_INS_OP), -- R-Befehle haben alle den gleichen Opcode, daher hier hardkodiert
    10=> std_logic_vector'("0" & SUB_ALU_OP (ALU_OPCODE_WIDTH - 1) & "00000" & std_logic_vector(to_unsigned(8, REG_ADR_WIDTH)) & std_logic_vector(to_unsigned(2, REG_ADR_WIDTH)) & SUB_ALU_OP(ALU_OPCODE_WIDTH - 2 downto 0) & std_logic_vector(to_unsigned(15, REG_ADR_WIDTH)) & R_INS_OP), -- R-Befehle haben alle den gleichen Opcode, daher hier hardkodiert
    others => (others => '0')
  );

begin

riscv_inst : entity work.R_only_RISC_V
  port map (
    pi_rst             => s_rst,
    pi_clk             => s_clk,
    pi_instruction     => s_instructions,
    po_registersOut    => s_registersOut
  );

  process is
  begin

      wait for PERIOD / 2;
   for i in 1 to 30 loop
      s_clk <= '1';
      wait for PERIOD / 2;
      s_clk <= '0';
      wait for PERIOD / 2;
     --  report "Register 10 contains " & integer'image(to_integer(signed(s_registersOut(13))));
    if (i = 5) then -- after 5 clock clock cycles
        assert (to_integer(signed(s_registersOut(10))) = 9)
         report "OR-Operation failed. Register 10 contains " & integer'image(to_integer(signed(s_registersOut(10)))) & " but should contain " & integer'image(9) & " after cycle 4"
          severity error;
     end if;

    if (i = 6) then -- after 6 clock clock cycles
        assert (to_integer(signed(s_registersOut(8)))= 17)
          report "ADD-Operation failed. Register 8 contains " & integer'image(to_integer(signed(s_registersOut(8)))) & " but should contain " & integer'image(17) & " after cycle 5"
          severity error;
     end if;

      if (i =7) then -- after 7 clock clock cycles
        assert (to_integer(signed(s_registersOut(11))) = 1)
         report "SUB-Operation failed. Register 11 contains " & integer'image(to_integer(signed(s_registersOut(11)))) & " but should contain " & integer'image(1) & " after cycle 6"
         severity error;
     end if;

      if (i = 8) then -- after 8 clock clock cycles
        assert (to_integer(signed(s_registersOut(12))) = 1)
         report "SUB-Operation failed. Register 12 contains " & integer'image(to_integer(signed(s_registersOut(12)))) & " but should contain " & integer'image(1) & " after cycle 8"
          severity error;

     end if;
      if (i = 9) then -- after 9 clock clock cycles
        assert (to_integer(signed(s_registersOut(12))) = 25)
          report "ADD-Operation failed. Register 12 contains " & integer'image(to_integer(signed(s_registersOut(12)))) & " but should contain " & integer'image(25) & " after cycle 7"
          severity error;
     end if;

           if (i = 10) then -- after 10 clock clock cycles
        assert (to_integer(signed(s_registersOut(12))) = -1)
          report "SUB-Operation failed. Register 12 contains " & integer'image(to_integer(signed(s_registersOut(12)))) & " but should contain " & integer'image(-1) & " after cycle 8"
          severity error;
     end if;
     if (i = 11) then
        assert (to_integer(signed(s_registersOut(12))) = 8)
          report "AND-Operation failed. Register 12 contains " & integer'image(to_integer(signed(s_registersOut(12)))) & " but should contain 1"
          severity error;
      end if;

      if (i = 12) then
        assert (to_integer(signed(s_registersOut(12))) = 1)
          report "XOR-Operation failed. Register 12 contains " & integer'image(to_integer(signed(s_registersOut(12)))) & " but should contain 17"
          severity error;
      end if;

      if (i = 13) then
        assert (to_integer(signed(s_registersOut(14))) = -8)
          report "SUB-Operation failed. Register 14 contains " & integer'image(to_integer(signed(s_registersOut(14)))) & " but should contain -16"
          severity error;
      end if;

      if (i = 14) then
        assert (to_integer(signed(s_registersOut(15))) = -9)
          report "SUB-Operation failed. Register 15 contains " & integer'image(to_integer(signed(s_registersOut(15)))) & " but should contain -7"
          severity error;
      end if;

    end loop;
    
    report "End of test!!!";
  wait;
  end process;
end architecture;