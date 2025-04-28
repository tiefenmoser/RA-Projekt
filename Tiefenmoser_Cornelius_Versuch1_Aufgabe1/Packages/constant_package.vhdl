-- Laboratory RA solutions/versuch1
-- Sommersemester 25
-- Group Details
-- Lab Date:
-- 1. Participant First and Last Name: 
-- 2. Participant First and Last Name:

-- ========================================================================
-- Author:       Marcel Rieß
-- Last updated: 31.03.2025
-- Description:  Holds various constants related to the RV instruction
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
  constant WORD_WIDTH       : integer := 16;
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
end package constant_package;
