-- Laboratory RA solutions/versuch8
-- Sommersemester 25
-- Group Details
-- Lab Date:
-- 1. Participant First and Last Name: 
-- 2. Participant First and Last Name:

-- ========================================================================
-- Author:       Marcel Rieß
-- Last updated: 06.06.2025
-- Description:  Holds various constants related to the RISC-V instruction
--               set that are used throughout the implementation
-- ========================================================================

library IEEE;
  use ieee.std_logic_1164.all;

package constant_package is

  -- General constants
  constant ALU_OPCODE_WIDTH : integer := 4;
  constant OPCODE_WIDTH     : integer := 7;
  constant DATA_WIDTH_GEN   : integer := 8;
  constant REG_ADR_WIDTH    : integer := 5;
  constant ADR_WIDTH        : integer := 32;
  constant WORD_WIDTH       : integer := 32;
  constant FUNC3_WIDTH      : integer := 3;

  -- Instruction Opcodes for ALU
  constant AND_ALU_OP : std_logic_vector(ALU_OPCODE_WIDTH - 1 downto 0) := "0111";
  constant XOR_ALU_OP : std_logic_vector(ALU_OPCODE_WIDTH - 1 downto 0) := "0100";
  constant OR_ALU_OP  : std_logic_vector(ALU_OPCODE_WIDTH - 1 downto 0) := "0110";

  constant SLL_ALU_OP : std_logic_vector(ALU_OPCODE_WIDTH - 1 downto 0) := "0001"; 
  constant SRL_ALU_OP : std_logic_vector(ALU_OPCODE_WIDTH - 1 downto 0) := "0101"; 
  constant SRA_ALU_OP : std_logic_vector(ALU_OPCODE_WIDTH - 1 downto 0) := "1101";

  constant ADD_ALU_OP : std_logic_vector(ALU_OPCODE_WIDTH - 1 downto 0) := "0000";
  constant SUB_ALU_OP : std_logic_vector(ALU_OPCODE_WIDTH - 1 downto 0) := "1000";

  constant SLT_ALU_OP  : std_logic_vector(ALU_OPCODE_WIDTH - 1 downto 0) := "0010";
  constant SLTU_ALU_OP : std_logic_vector(ALU_OPCODE_WIDTH - 1 downto 0) := "0011";

  constant EQ_ALU_OP : std_logic_vector(ALU_OPCODE_WIDTH - 1 downto 0) := "1110"; -- Added this to simplify branch implementation

  constant FUNC3_SHIFTR : std_logic_vector(FUNC3_WIDTH - 1 downto 0) := "101";
  constant FUNC3_BEQ     : std_logic_vector(FUNC3_WIDTH - 1 downto 0) := "000";
  constant FUNC3_BNE     : std_logic_vector(FUNC3_WIDTH - 1 downto 0) := "001";
  constant FUNC3_BLT     : std_logic_vector(FUNC3_WIDTH - 1 downto 0) := "100";
  constant FUNC3_BGE     : std_logic_vector(FUNC3_WIDTH - 1 downto 0) := "101";
  constant FUNC3_BLTU    : std_logic_vector(FUNC3_WIDTH - 1 downto 0) := "110";
  constant FUNC3_BGEU    : std_logic_vector(FUNC3_WIDTH - 1 downto 0) := "111";

  -- RISC-V Instruction Opcodes: Since some instructions (e.g. all R-Format instructions) share the same opcode, only one of them is declared here

  -- U-Format
  constant LUI_INS_OP   : std_logic_vector(OPCODE_WIDTH - 1 downto 0) := "0110111"; -- lui
  constant AUIPC_INS_OP : std_logic_vector(OPCODE_WIDTH - 1 downto 0) := "0010111"; -- auipc

  -- J-Format
  constant JAL_INS_OP : std_logic_vector(OPCODE_WIDTH - 1 downto 0) := "1101111";   -- jal

  -- B-Format
  constant B_INS_OP : std_logic_vector(OPCODE_WIDTH - 1 downto 0) := "1100011";     -- beq, all B-Format instructions have the same opcode

  -- S-Format
  constant S_INS_OP : std_logic_vector(OPCODE_WIDTH - 1 downto 0) := "0100011";     -- sb

  -- I-Format
  constant JALR_INS_OP : std_logic_vector(OPCODE_WIDTH - 1 downto 0) := "1100111";  -- jalr

  constant L_INS_OP : std_logic_vector(OPCODE_WIDTH - 1 downto 0) := "0000011";     -- lb

  constant I_INS_OP : std_logic_vector(OPCODE_WIDTH - 1 downto 0) := "0010011";     -- addi

  -- R-Format
  constant R_INS_OP : std_logic_vector(OPCODE_WIDTH - 1 downto 0) := "0110011";     -- add
  
  -- Load 
  constant LB_OP    : std_logic_vector(FUNC3_WIDTH - 1 downto 0) := "000";
  constant LH_OP    : std_logic_vector(FUNC3_WIDTH - 1 downto 0) := "001";
  constant LW_OP    : std_logic_vector(FUNC3_WIDTH - 1 downto 0) := "010";
  constant LBU_OP   : std_logic_vector(FUNC3_WIDTH - 1 downto 0) := "100";
  constant LHU_OP   : std_logic_vector(FUNC3_WIDTH - 1 downto 0) := "101";

  -- Store
  constant SB_OP    : std_logic_vector(FUNC3_WIDTH - 1 downto 0) := "000";
  constant SH_OP    : std_logic_vector(FUNC3_WIDTH - 1 downto 0) := "001";
  constant SW_OP    : std_logic_vector(FUNC3_WIDTH - 1 downto 0) := "010";
end package constant_package;