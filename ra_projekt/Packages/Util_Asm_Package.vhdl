-- ========================================================================
-- Author:       Marcel Riess
-- Last updated: 05.05.2025
-- Description:  Some asm-functions that help with writing shorter and more
--               readable code. They are only used in testbenches!
-- ========================================================================

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;
USE work.constant_package.ALL;
USE work.types.ALL;

PACKAGE util_asm_package IS

  -- Function interface declaration. For implemenation, see package body below

  FUNCTION Asm2Std(instr : STRING;token1 : INTEGER;token2 : INTEGER;token3 : INTEGER) RETURN STD_LOGIC_VECTOR;

END PACKAGE util_asm_package;

PACKAGE BODY util_asm_package IS

  -- construct an R-format instruction using the alu opcode (NOT the instruction opcode: see Constant_Package.vhdl)

  FUNCTION Asm2Std(instr : STRING; token1 : INTEGER; token2 : INTEGER; token3 : INTEGER) RETURN STD_LOGIC_VECTOR IS
    VARIABLE opcode : STD_LOGIC_VECTOR(6 DOWNTO 0);
    VARIABLE funct3 : STD_LOGIC_VECTOR(2 DOWNTO 0);
    VARIABLE funct7 : STD_LOGIC_VECTOR(6 DOWNTO 0);
    VARIABLE rd : STD_LOGIC_VECTOR(4 DOWNTO 0);
    VARIABLE rs1 : STD_LOGIC_VECTOR(4 DOWNTO 0);
    VARIABLE rs2 : STD_LOGIC_VECTOR(4 DOWNTO 0);
    VARIABLE imm : STD_LOGIC_VECTOR(11 DOWNTO 0);
    VARIABLE immJump : STD_LOGIC_VECTOR(19 DOWNTO 0);
    VARIABLE shamt : STD_LOGIC_VECTOR(4 DOWNTO 0);
    VARIABLE machine_word : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
  BEGIN
    --I-Format
    IF instr = "ADDI" THEN
      opcode := I_INS_OP; -- I-type
      funct3 := "000";
      rd := STD_LOGIC_VECTOR(to_unsigned(token1, 5));
      rs1 := STD_LOGIC_VECTOR(to_unsigned(token2, 5));
      -- Immediate-Wert als 12-bit 2's Komplement
      imm := STD_LOGIC_VECTOR(to_signed(((token3)), 12));
      machine_word := imm & rs1 & funct3 & rd & opcode;

    ELSIF instr = "SLTI" THEN
      opcode := I_INS_OP; -- I-type
      funct3 := "010";
      rd := STD_LOGIC_VECTOR(to_unsigned(token1, 5));
      rs1 := STD_LOGIC_VECTOR(to_unsigned(token2, 5));
      -- Immediate-Wert als 12-bit 2's Komplement
      imm := STD_LOGIC_VECTOR(to_signed(((token3)), 12));
      machine_word := imm & rs1 & funct3 & rd & opcode;

    ELSIF instr = "SLTIU" THEN
      opcode := I_INS_OP; -- I-type
      funct3 := "011";
      rd := STD_LOGIC_VECTOR(to_unsigned(token1, 5));
      rs1 := STD_LOGIC_VECTOR(to_unsigned(token2, 5));
      -- Immediate-Wert als 12-bit 2's Komplement
      imm := STD_LOGIC_VECTOR(to_signed(((token3)), 12));
      machine_word := imm & rs1 & funct3 & rd & opcode;

    ELSIF instr = "XORI" THEN
      opcode := I_INS_OP; -- I-type
      funct3 := "100";
      rd := STD_LOGIC_VECTOR(to_unsigned(token1, 5));
      rs1 := STD_LOGIC_VECTOR(to_unsigned(token2, 5));
      -- Immediate-Wert als 12-bit 2's Komplement
      imm := STD_LOGIC_VECTOR(to_signed(((token3)), 12));
      machine_word := imm & rs1 & funct3 & rd & opcode;

    ELSIF instr = "ORI" THEN
      opcode := I_INS_OP; -- I-type
      funct3 := "110";
      rd := STD_LOGIC_VECTOR(to_unsigned(token1, 5));
      rs1 := STD_LOGIC_VECTOR(to_unsigned(token2, 5));
      -- Immediate-Wert als 12-bit 2's Komplement
      imm := STD_LOGIC_VECTOR(to_signed(((token3)), 12));
      machine_word := imm & rs1 & funct3 & rd & opcode;

    ELSIF instr = "ANDI" THEN
      opcode := I_INS_OP; -- I-type
      funct3 := "111";
      rd := STD_LOGIC_VECTOR(to_unsigned(token1, 5));
      rs1 := STD_LOGIC_VECTOR(to_unsigned(token2, 5));
      -- Immediate-Wert als 12-bit 2's Komplement
      imm := STD_LOGIC_VECTOR(to_signed(((token3)), 12));
      machine_word := imm & rs1 & funct3 & rd & opcode;

    ELSIF instr = "SLLI" THEN
      opcode := I_INS_OP; -- I-type
      funct3 := "001";
      funct7 := "0000000";
      rd := STD_LOGIC_VECTOR(to_unsigned(token1, 5));
      rs1 := STD_LOGIC_VECTOR(to_unsigned(token2, 5));
      -- Shift-Ammount als 5-bit 2's Komplement Immediate
      shamt := STD_LOGIC_VECTOR(to_signed((token3), 5));
      machine_word := funct7 & shamt & rs1 & funct3 & rd & opcode;

    ELSIF instr = "SRLI" THEN
      opcode := I_INS_OP; -- I-type
      funct3 := "101";
      funct7 := "0000000";
      rd := STD_LOGIC_VECTOR(to_unsigned(token1, 5));
      rs1 := STD_LOGIC_VECTOR(to_unsigned(token2, 5));
      -- Shift-Ammount als 5-bit 2's Komplement Immediate
      shamt := STD_LOGIC_VECTOR(to_signed(((token3)), 5));
      machine_word := funct7 & shamt & rs1 & funct3 & rd & opcode;

    ELSIF instr = "SRAI" THEN
      opcode := I_INS_OP; -- I-type
      funct3 := "101";
      funct7 := "0100000";
      rd := STD_LOGIC_VECTOR(to_unsigned(token1, 5));
      rs1 := STD_LOGIC_VECTOR(to_unsigned(token2, 5));
      -- Shift-Ammount als 5-bit 2's Komplement Immediate
      shamt := STD_LOGIC_VECTOR(to_signed(((token3)), 5));
      machine_word := funct7 & shamt & rs1 & funct3 & rd & opcode;

    ELSIF instr = "LB" THEN
      opcode := L_INS_OP; -- I-type
      funct3 := "000";
      rd := STD_LOGIC_VECTOR(to_unsigned(token1, 5));
      rs1 := STD_LOGIC_VECTOR(to_unsigned(token2, 5)); --üblicherweise 0? im normalen Assembler schreibt man eigentlich nur lb rd i
      -- Immediate-Wert als 12-bit 2's Komplement
      imm := STD_LOGIC_VECTOR(to_signed(((token3)), 12));
      machine_word := imm & rs1 & funct3 & rd & opcode;
      --report to_bstring (machine_word);
    ELSIF instr = "LH" THEN
      opcode := L_INS_OP; -- I-type
      funct3 := "001";
      rd := STD_LOGIC_VECTOR(to_unsigned(token1, 5));
      rs1 := STD_LOGIC_VECTOR(to_unsigned(token2, 5));--rs2 sollte immer 0 sein, ist nur Platzhalter
      -- Immediate-Wert als 12-bit 2's Komplement
      imm := STD_LOGIC_VECTOR(to_signed(((token3)), 12));
      machine_word := imm & rs1 & funct3 & rd & opcode;
      --report to_bstring (machine_word);

    ELSIF instr = "LW" THEN
      opcode := L_INS_OP; -- I-type
      funct3 := "010";
      rd := STD_LOGIC_VECTOR(to_unsigned(token1, 5));
      rs1 := STD_LOGIC_VECTOR(to_unsigned(token2, 5));--rs2 sollte immer 0 sein, ist nur Platzhalter
      -- Immediate-Wert als 12-bit 2's Komplement
      imm := STD_LOGIC_VECTOR(to_signed(((token3)), 12));
      machine_word := imm & rs1 & funct3 & rd & opcode;
      --report to_bstring (machine_word);
    ELSIF instr = "LBU" THEN
      opcode := L_INS_OP; -- I-type
      funct3 := "100";
      rd := STD_LOGIC_VECTOR(to_unsigned(token1, 5));
      rs1 := STD_LOGIC_VECTOR(to_unsigned(token2, 5));--rs2 sollte immer 0 sein, ist nur Platzhalter
      -- Immediate-Wert als 12-bit 2's Komplement
      imm := STD_LOGIC_VECTOR(to_signed(((token3)), 12));
      machine_word := imm & rs1 & funct3 & rd & opcode;

    ELSIF instr = "LHU" THEN
      opcode := L_INS_OP; -- I-type
      funct3 := "101";
      rd := STD_LOGIC_VECTOR(to_unsigned(token1, 5));
      rs1 := STD_LOGIC_VECTOR(to_unsigned(token2, 5));--rs2 sollte immer 0 sein, ist nur Platzhalter
      -- Immediate-Wert als 12-bit 2's Komplement
      imm := STD_LOGIC_VECTOR(to_signed(((token3)), 12));
      machine_word := imm & rs1 & funct3 & rd & opcode;

    ELSIF instr = "JALR" THEN
      opcode := JALR_INS_OP; -- I-type
      funct3 := "000";
      rd := STD_LOGIC_VECTOR(to_unsigned(token1, 5));
      rs1 := STD_LOGIC_VECTOR(to_unsigned(token2, 5));
      -- Immediate-Wert als 12-bit 2's Komplement
      imm := STD_LOGIC_VECTOR(to_signed(((token3)), 12));
      machine_word := imm & rs1 & funct3 & rd & opcode;

      --J-Format
    ELSIF instr = "JAL" THEN
      opcode := JAL_INS_OP; -- J-type
      rd := STD_LOGIC_VECTOR(to_unsigned(token1, 5));
      -- Immediate-Wert als 20-bit 2's Komplement
      immJump := STD_LOGIC_VECTOR(to_signed(((token2)), 20));
      
      -- Teile zusammensetzen gemäß J-Typ
      machine_word(31)      := immJump(19);                  -- imm[20]
      machine_word(30 downto 21) := immJump(9 downto 0);     -- imm[10:1]
      machine_word(20)      := immJump(10);                  -- imm[11]
      machine_word(19 downto 12) := immJump(18 downto 11);   -- imm[19:12]
      machine_word(11 downto 7) := rd;                       -- rd
      machine_word(6 downto 0) := opcode;                    -- opcode

      --U-Format
    ELSIF instr = "LUI" THEN
      opcode := LUI_INS_OP; -- U-type
      rd := STD_LOGIC_VECTOR(to_unsigned(token1, 5));
      -- Immediate-Wert als 20-bit 2's Komplement
      immJump := STD_LOGIC_VECTOR(to_signed(((token2)), 20));
      machine_word := immJump & rd & opcode;

    ELSIF instr = "AUIPC" THEN
      opcode := AUIPC_INS_OP; -- U-type
      rd := STD_LOGIC_VECTOR(to_unsigned(token1, 5));
      -- Immediate-Wert als 20-bit 2's Komplement
      immJump := STD_LOGIC_VECTOR(to_signed(((token2)), 20));
      machine_word := immJump & rd & opcode;

      -- B Befehle

    ELSIF instr = "BEQ" THEN
      opcode := B_INS_OP; -- B-type
      funct3 := "000";
      rs1 := STD_LOGIC_VECTOR(to_unsigned(token1, 5));
      rs2 := STD_LOGIC_VECTOR(to_unsigned(token2, 5));
      imm := STD_LOGIC_VECTOR(to_signed(((token3)), 12));
      machine_word := imm(11) & imm(9 DOWNTO 4) & rs2 & rs1 & funct3 & imm(3 DOWNTO 0) & imm(10) & opcode;

    ELSIF instr = "BNE" THEN
      opcode := B_INS_OP; -- B-type
      funct3 := "001";
      rs1 := STD_LOGIC_VECTOR(to_unsigned(token1, 5));
      rs2 := STD_LOGIC_VECTOR(to_unsigned(token2, 5));
      imm := STD_LOGIC_VECTOR(to_signed(((token3)), 12));
      machine_word := imm(11) & imm(9 DOWNTO 4) & rs2 & rs1 & funct3 & imm(3 DOWNTO 0) & imm(10) & opcode;

    ELSIF instr = "BLT" THEN
      opcode := B_INS_OP; -- B-type
      funct3 := "100";
      rs1 := STD_LOGIC_VECTOR(to_unsigned(token1, 5));
      rs2 := STD_LOGIC_VECTOR(to_unsigned(token2, 5));
      imm := STD_LOGIC_VECTOR(to_signed(((token3)), 12));
      machine_word := imm(11) & imm(9 DOWNTO 4) & rs2 & rs1 & funct3 & imm(3 DOWNTO 0) & imm(10) & opcode;

    ELSIF instr = "BGE" THEN
      opcode := B_INS_OP; -- B-type
      funct3 := "101";
      rs1 := STD_LOGIC_VECTOR(to_unsigned(token1, 5));
      rs2 := STD_LOGIC_VECTOR(to_unsigned(token2, 5));
      imm := STD_LOGIC_VECTOR(to_signed(((token3)), 12));
      machine_word := imm(11) & imm(9 DOWNTO 4) & rs2 & rs1 & funct3 & imm(3 DOWNTO 0) & imm(10) & opcode;

    ELSIF instr = "BLTU" THEN
      opcode := B_INS_OP; -- B-type
      funct3 := "110";
      rs1 := STD_LOGIC_VECTOR(to_unsigned(token1, 5));
      rs2 := STD_LOGIC_VECTOR(to_unsigned(token2, 5));
      imm := STD_LOGIC_VECTOR(to_signed(((token3)), 12));
      machine_word := imm(11) & imm(9 DOWNTO 4) & rs2 & rs1 & funct3 & imm(3 DOWNTO 0) & imm(10) & opcode;

    ELSIF instr = "BGEU" THEN
      opcode := B_INS_OP; -- B-type
      funct3 := "111";
      rs1 := STD_LOGIC_VECTOR(to_unsigned(token1, 5));
      rs2 := STD_LOGIC_VECTOR(to_unsigned(token2, 5));
      imm := STD_LOGIC_VECTOR(to_signed(((token3)), 12));
      machine_word := imm(11) & imm(9 DOWNTO 4) & rs2 & rs1 & funct3 & imm(3 DOWNTO 0) & imm(10) & opcode;

      -- S Befehle
    ELSIF instr = "SB" THEN
      opcode := S_INS_OP; -- S-type
      funct3 := "000";
      rs1 := STD_LOGIC_VECTOR(to_unsigned(token1, 5));
      rs2 := STD_LOGIC_VECTOR(to_unsigned(token2, 5)); --rs2 sollte immer 0 sein, ist nur Platzhalter
      imm := STD_LOGIC_VECTOR(to_signed(((token3)), 12));
      machine_word := imm(11 DOWNTO 5) & rs2 & rs1 & funct3 & imm(4 DOWNTO 0) & opcode;
      --report to_bstring (machine_word);
    ELSIF instr = "SH" THEN
      opcode := S_INS_OP; -- S-type
      funct3 := "001";
      rs1 := STD_LOGIC_VECTOR(to_unsigned(token1, 5));
      rs2 := STD_LOGIC_VECTOR(to_unsigned(token2, 5)); --rs2 sollte immer 0 sein, ist nur Platzhalter
      imm := STD_LOGIC_VECTOR(to_signed(((token3)), 12));
      machine_word := imm(11 DOWNTO 5) & rs2 & rs1 & funct3 & imm(4 DOWNTO 0) & opcode;
      --report to_bstring (machine_word);
    ELSIF instr = "SW" THEN
      opcode := S_INS_OP; -- S-type
      funct3 := "010";
      rs1 := STD_LOGIC_VECTOR(to_unsigned(token1, 5));
      rs2 := STD_LOGIC_VECTOR(to_unsigned(token2, 5)); --rs2 sollte immer 0 sein, ist nur Platzhalter
      imm := STD_LOGIC_VECTOR(to_signed(((token3)), 12));
      machine_word := imm(11 DOWNTO 5) & rs2 & rs1 & funct3 & imm(4 DOWNTO 0) & opcode;
      --report to_bstring (machine_word);
      --R-Format
    ELSIF instr = "ADD" THEN
      opcode := R_INS_OP; -- R-type
      funct3 := "000";
      funct7 := "0000000";
      rd := STD_LOGIC_VECTOR(to_unsigned(token1, 5));
      rs1 := STD_LOGIC_VECTOR(to_unsigned(token2, 5));
      rs2 := STD_LOGIC_VECTOR(to_unsigned(token3, 5));
      machine_word := funct7 & rs2 & rs1 & funct3 & rd & opcode;

    ELSIF instr = "SUB" THEN
      opcode := R_INS_OP; -- R-type
      funct3 := "000";
      funct7 := "0100000";
      rd := STD_LOGIC_VECTOR(to_unsigned(token1, 5));
      rs1 := STD_LOGIC_VECTOR(to_unsigned(token2, 5));
      rs2 := STD_LOGIC_VECTOR(to_unsigned(token3, 5));
      machine_word := funct7 & rs2 & rs1 & funct3 & rd & opcode;

    ELSIF instr = "AND" THEN
      opcode := R_INS_OP; -- R-type
      funct3 := "111";
      funct7 := "0000000";
      rd := STD_LOGIC_VECTOR(to_unsigned(token1, 5));
      rs1 := STD_LOGIC_VECTOR(to_unsigned(token2, 5));
      rs2 := STD_LOGIC_VECTOR(to_unsigned(token3, 5));
      machine_word := funct7 & rs2 & rs1 & funct3 & rd & opcode;

    ELSIF instr = "OR" THEN
      opcode := R_INS_OP; -- R-type
      funct3 := "110";
      funct7 := "0000000";
      rd := STD_LOGIC_VECTOR(to_unsigned(token1, 5));
      rs1 := STD_LOGIC_VECTOR(to_unsigned(token2, 5));
      rs2 := STD_LOGIC_VECTOR(to_unsigned(token3, 5));
      machine_word := funct7 & rs2 & rs1 & funct3 & rd & opcode;

    ELSIF instr = "XOR" THEN
      opcode := R_INS_OP; -- R-type
      funct3 := "100";
      funct7 := "0000000";
      rd := STD_LOGIC_VECTOR(to_unsigned(token1, 5));
      rs1 := STD_LOGIC_VECTOR(to_unsigned(token2, 5));
      rs2 := STD_LOGIC_VECTOR(to_unsigned(token3, 5));
      machine_word := funct7 & rs2 & rs1 & funct3 & rd & opcode;

    ELSIF instr = "SLL" THEN
      opcode := R_INS_OP; -- R-type
      funct3 := "001";
      funct7 := "0000000";
      rd := STD_LOGIC_VECTOR(to_unsigned(token1, 5));
      rs1 := STD_LOGIC_VECTOR(to_unsigned(token2, 5));
      rs2 := STD_LOGIC_VECTOR(to_unsigned(token3, 5));
      machine_word := funct7 & rs2 & rs1 & funct3 & rd & opcode;

    ELSIF instr = "SRL" THEN
      opcode := R_INS_OP; -- R-type
      funct3 := "101";
      funct7 := "0000000";
      rd := STD_LOGIC_VECTOR(to_unsigned(token1, 5));
      rs1 := STD_LOGIC_VECTOR(to_unsigned(token2, 5));
      rs2 := STD_LOGIC_VECTOR(to_unsigned(token3, 5));
      machine_word := funct7 & rs2 & rs1 & funct3 & rd & opcode;

    ELSIF instr = "SRA" THEN
      opcode := R_INS_OP; -- R-type
      funct3 := "101";
      funct7 := "0100000";
      rd := STD_LOGIC_VECTOR(to_unsigned(token1, 5));
      rs1 := STD_LOGIC_VECTOR(to_unsigned(token2, 5));
      rs2 := STD_LOGIC_VECTOR(to_unsigned(token3, 5));
      machine_word := funct7 & rs2 & rs1 & funct3 & rd & opcode;
       -- begin solution:
    ELSIF instr = "SLT" THEN
      opcode := R_INS_OP; -- R-type
      funct3 := "010";
      funct7 := "0000000";
      rd := STD_LOGIC_VECTOR(to_unsigned(token1, 5));
      rs1 := STD_LOGIC_VECTOR(to_unsigned(token2, 5));
      rs2 := STD_LOGIC_VECTOR(to_unsigned(token3, 5));
      machine_word := funct7 & rs2 & rs1 & funct3 & rd & opcode;

    ELSIF instr = "SLTU" THEN
      opcode := R_INS_OP; -- R-type
      funct3 := "011";
      funct7 := "0000000";
      rd := STD_LOGIC_VECTOR(to_unsigned(token1, 5));
      rs1 := STD_LOGIC_VECTOR(to_unsigned(token2, 5));
      rs2 := STD_LOGIC_VECTOR(to_unsigned(token3, 5));
      machine_word := funct7 & rs2 & rs1 & funct3 & rd & opcode;
       -- end solution!!
    ELSE
      -- Unsupported instruction
      machine_word := (OTHERS => 'X');
    END IF;

    RETURN machine_word;
  END FUNCTION;

END PACKAGE BODY util_asm_package;