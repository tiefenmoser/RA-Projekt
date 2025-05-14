-- Laboratory RA solutions/versuch3
-- Sommersemester 25
-- Group Details
-- Lab Date:
-- 1. Participant First and Last Name: 
-- 2. Participant First and Last Name:

-- ========================================================================
-- Author:       Marcel Riess
-- Last updated: 03.05.2025
-- Description:  Testbench for signExtension, and its mutliple architectures,
--               as defined in signExtension.vhdl and signExtension*.vhdl
-- ========================================================================

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.constant_package.all;
use work.util_asm_package.all;

entity signExtension_tb is
end entity signExtension_tb;

architecture behavior of signExtension_tb is

  constant PERIOD : time := 10 ns; -- Example: ClockPERIOD of 10 ns
  signal s_clk : std_logic := '0';
  signal s_iInstruction : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
  signal s_uInstruction : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
  signal s_bInstruction : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
  signal s_Instruction : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
  signal s_iImmexpect : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
  signal s_iImmOut : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
  signal s_uImmexpect : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
  signal s_uImmOut : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
  signal s_bImmexpect : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
  signal s_bImmOut : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
  signal s_jImmOut : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
  signal s_jImmexpect : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
  signal s_sImmOut : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
  signal s_sImmexpect : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');

begin


  dut1 : entity work.signExtension

    port map(
      pi_instr => s_Instruction,
      po_jumpImm => s_jImmOut,
      po_branchImm => s_bImmOut,
      po_unsignedImm => s_uImmOut,
      po_immediateImm => s_iImmOut,
      po_storeImm => s_sImmOut
    );

  proc : process is

    variable v_uExtended : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    variable v_tmp : std_logic_vector(11 downto 0) := (others => '0');
    variable s_uImmediate : std_logic_vector(19 downto 0) := (others => '0');

  begin

    for i in - ((2 ** 12) - 1) / 2 to ((2 ** 12) - 1) / 2 loop

      s_Instruction <= Asm2Std("ADDI", 1, 2, i);
      s_iImmexpect <= std_logic_vector(to_signed((i), WORD_WIDTH));

      s_clk <= '1';
      wait for PERIOD / 2;
      s_clk <= '0';
      wait for PERIOD / 2;

      assert (s_iImmexpect = s_iImmOut)
      report "Had error in sign extender with i-format: Output is  " & to_string(s_iImmOut) & " but should be " & to_string(s_iImmexpect) & " Input is " & to_string(s_iInstruction)
        severity error;
        s_Instruction <= Asm2Std("SH", 1, 0, i);
        s_sImmexpect <= std_logic_vector(to_signed((i), WORD_WIDTH));

        s_clk <= '1';
        wait for PERIOD / 2;
        s_clk <= '0';
        wait for PERIOD / 2;
  
        assert (s_sImmexpect = s_sImmOut)
        report "Had error in sign extender with s-format"
            severity error;
    end loop;

    for i in - ((2 ** 20) - 1) / 2 to ((2 ** 20) - 1) / 2 loop

      s_Instruction <= Asm2Std("LUI", 0,i,0);
      v_uExtended := std_logic_vector(to_signed((i), WORD_WIDTH));
      s_uImmediate := (std_logic_vector(signed(v_uExtended(19 downto 0))));
      s_uImmexpect <= std_logic_vector(signed(v_uExtended(19 downto 0))) & v_tmp;
      s_clk <= '1';
      wait for PERIOD / 2;
      s_clk <= '0';
      wait for PERIOD / 2;

      assert (s_uImmexpect = s_uImmOut)
      report "Had error in sign extender with u-format" severity error;

    end loop;

    for i in - ((2 ** 12) - 1) / 2 to ((2 ** 12) - 1) / 2 loop

      s_Instruction <= Asm2Std("BGEU", 0, 0, i);
      s_bImmexpect <= std_logic_vector(to_signed((i * 2), WORD_WIDTH));

      s_clk <= '1';
      wait for PERIOD / 2;
      s_clk <= '0';
      wait for PERIOD / 2;

      assert (s_bImmexpect = s_bImmOut)
      report "Had error in sign extender with b-format" severity error;

    end loop;

      for i in - ((2 ** 20) - 1) / 2 to ((2 ** 20) - 1) / 2 loop

        s_Instruction <= Asm2Std("JAL",1,i,0);
        s_jImmexpect <= std_logic_vector(to_signed((i * 2), WORD_WIDTH));
  
        s_clk <= '1';
        wait for PERIOD / 2;
        s_clk <= '0';
        wait for PERIOD / 2;
  
        assert (s_jImmexpect = s_jImmOut)
        report "Had error in sign extender with j-format"
            severity error;
  


      end loop;
    

    assert false
    report "end of test"
      severity note;

    wait; --  Wait forever; this will finish the simulation.

  end process;

end architecture behavior;