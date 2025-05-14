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
  end record controlWord;

  -- allows initialization of control words, used in decoder
  constant control_word_init : controlWord :=
  (
  ALU_OP => (others => '0'),
  I_IMM_SEL  => '0',
  REG_WRITE   => '0'
  );

  -- enum containig all instruction formats, used in decoder
  type t_instruction_type is (rFormat, iFormat, uFormat, bFormat, sFormat, jFormat, nullFormat);

  type memory is array (0 to 2 ** 10 - 1) of std_logic_vector(WORD_WIDTH - 1 downto 0); -- Used for instruction cache

  type registermemory is array (0 to 2 ** REG_ADR_WIDTH - 1) of std_logic_vector(WORD_WIDTH - 1 downto 0); -- used in register file

end package types;