-- ========================================================================
-- Author:       Marcel Rieß
-- Last updated: 02.05.2025
-- Description:  Holds various custom types related to the implementation
--               that are used throughout the implementation
-- ========================================================================

library IEEE;
use ieee.std_logic_1164.all;
use work.constant_package.all;

package types is
  type controlword is record
    ALU_OP       : std_logic_vector(ALU_OPCODE_WIDTH - 1 downto 0); -- determines the ALU's operation
    I_IMM_SEL    : std_logic;                                       -- used as a MUX selector for i-Format Immediates
    REG_WRITE    : std_logic;
    CMP_RESULT   : std_logic;
    IS_BRANCH    : std_logic;
    A_SEL        : std_logic; -- used as a MUX selector for ALU
    PC_SEL        : std_logic; -- used as a MUX selector for PC
    WB_SEL       :std_logic_vector( 1 downto 0);
  end record controlWord;

  -- allows initialization of control words, used in decoder
  constant control_word_init : controlWord :=
  (
  ALU_OP => (others => '0'),
  I_IMM_SEL  => '0',
  REG_WRITE   => '0',
  A_SEL   => '0',
  IS_BRANCH => '0',
  CMP_RESULT => '0',
  PC_SEL   => '0',
  WB_SEL   => "00"
  );

  -- enum containig all instruction formats, used in decoder
  type t_instruction_type is (rFormat, iFormat, uFormat, bFormat, sFormat, jFormat, nullFormat);

  type memory is array (0 to 2 ** 10 - 1) of std_logic_vector(WORD_WIDTH - 1 downto 0); -- Used for instruction cache

  type registermemory is array (0 to 2 ** REG_ADR_WIDTH - 1) of std_logic_vector(WORD_WIDTH - 1 downto 0); -- used in register file

end package types;