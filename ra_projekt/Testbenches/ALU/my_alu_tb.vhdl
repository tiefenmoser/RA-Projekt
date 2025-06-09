-- ============================================================================
-- Author:       Marcel Rieß
-- Last updated: 04.06.2025
-- Description:  Testbench für die ALU-Entität aus my_alu.vhdl
-- Diese Testbench prüft systematisch alle ALU-Operationen (AND, OR, XOR,
-- SHIFT, ADD, SUB, SLT, SLTU) mit sämtlichen möglichen Werte-Kombinationen
-- im Bereich der gewählten Bitbreite. Neben den Funktionsausgaben werden
-- auch die Status-Flags (Zero und CarryOut) validiert.
-- Besonderes Augenmerk liegt auf korrekter Behandlung von SUB und CarryOut,
-- inklusive Zweierkomplement-Interpretation und Borrow-Logik.
-- ============================================================================
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use ieee.math_real.all;
  use work.constant_package.all;  -- Enthält DATA_WIDTH_GEN, ALU_OPCODE_WIDTH etc.

entity my_alu_tb is
end entity my_alu_tb;

architecture behavior of my_alu_tb is

  -- Signale zur Ansteuerung und Überprüfung der ALU
  signal s_op1      : std_logic_vector(DATA_WIDTH_GEN - 1 downto 0) := (others => '0');
  signal s_op2      : std_logic_vector(DATA_WIDTH_GEN - 1 downto 0) := (others => '0');
  signal s_luOut    : std_logic_vector(DATA_WIDTH_GEN - 1 downto 0);
  signal s_expect   : std_logic_vector(DATA_WIDTH_GEN - 1 downto 0);
  signal s_luOp     : std_logic_vector(ALU_OPCODE_WIDTH - 1 downto 0) := (others => '0');
  signal s_carryOut : std_logic :='0';
  signal s_zero     : std_logic :='0';

  constant PERIOD : time := 10 ns;  -- Zeitdauer zwischen Operationen

begin

  -- Instanziierung der ALU mit Generics
  uut: entity work.alu
    generic map (
      DATA_WIDTH_GEN ,
      ALU_OPCODE_WIDTH
    )
    port map (
      pi_op1      => s_op1,
      pi_op2      => s_op2,
      pi_aluOp    => s_luOp,
      po_aluOut   => s_luOut,
      po_carryOut => s_carryOut,
      po_zero     => s_zero
    );

  -- Hauptprozess zur Testausführung
  stim_proc: process
    variable v_op1_u : unsigned(DATA_WIDTH_GEN - 1 downto 0);
    variable v_op2_u : unsigned(DATA_WIDTH_GEN - 1 downto 0);
    variable v_expected_sub_result : integer;
    variable v_expected_carry : std_logic;
  begin
    -- Alle Kombinationen von op1 und op2 im Bereich des Datentyps testen
    for op1_i in -(2**(DATA_WIDTH_GEN - 1)) to 2**(DATA_WIDTH_GEN - 1) - 1 loop
      s_op1 <= std_logic_vector(to_signed(op1_i, DATA_WIDTH_GEN));
      for op2_i in -(2**(DATA_WIDTH_GEN - 1)) to 2**(DATA_WIDTH_GEN - 1) - 1 loop
        s_op2 <= std_logic_vector(to_signed(op2_i, DATA_WIDTH_GEN));
        wait for PERIOD / 2;

        -- ========== AND ==========
        s_luOp   <= AND_ALU_OP;
        s_expect <= s_op1 and s_op2;
        wait for PERIOD / 2;
        assert s_luOut = s_expect
          report "Fehler bei AND: " & to_string(s_op1) & " AND " & to_string(s_op2)
          severity error;
        assert ((s_expect = std_logic_vector(to_signed(0, DATA_WIDTH_GEN)) and s_zero = '1') or
                (s_expect /= std_logic_vector(to_signed(0, DATA_WIDTH_GEN)) and s_zero = '0'))
          report "Zero-Flag bei AND falsch: Ergebnis = " & to_string(s_expect)
          severity error;

        -- ========== OR ==========
        s_luOp   <= OR_ALU_OP;
        s_expect <= s_op1 or s_op2;
        wait for PERIOD / 2;
        assert s_luOut = s_expect
          report "Fehler bei OR"
          severity error;
        assert ((s_expect = std_logic_vector(to_signed(0, DATA_WIDTH_GEN)) and s_zero = '1') or
                (s_expect /= std_logic_vector(to_signed(0, DATA_WIDTH_GEN)) and s_zero = '0'))
          report "Zero-Flag bei OR falsch"
          severity error;

        -- ========== XOR ==========
        s_luOp   <= XOR_ALU_OP;
        s_expect <= s_op1 xor s_op2;
        wait for PERIOD / 2;
        assert s_luOut = s_expect
          report "Fehler bei XOR"
          severity error;
        assert ((s_expect = std_logic_vector(to_signed(0, DATA_WIDTH_GEN)) and s_zero = '1') or
                (s_expect /= std_logic_vector(to_signed(0, DATA_WIDTH_GEN)) and s_zero = '0'))
          report "Zero-Flag bei XOR falsch"
          severity error;

        -- ========== SHIFT-Operationen ==========
        if op2_i >= 0 and op2_i < integer(log2(real(DATA_WIDTH_GEN))) then
          -- Logical Shift Left (SLL)
          s_luOp <= SLL_ALU_OP;
          wait for PERIOD / 2;
          s_expect <= std_logic_vector(shift_left(unsigned(s_op1), op2_i));
          wait for PERIOD / 2;
          assert s_luOut = s_expect
            report "Fehler bei SLL"
            severity error;

          -- Logical Shift Right (SRL)
          s_luOp <= SRL_ALU_OP;
          s_expect <= std_logic_vector(shift_right(unsigned(s_op1), op2_i));
          wait for PERIOD / 2;
          assert s_luOut = s_expect
            report "Fehler bei SRL"
            severity error;

          -- Arithmetic Shift Right (SRA)
          s_luOp <= SRA_ALU_OP;
          s_expect <= std_logic_vector(shift_right(signed(s_op1), op2_i));
          wait for PERIOD / 2;
          assert s_luOut = s_expect
            report "Fehler bei SRA"
            severity error;
        end if;

        -- ========== ADD ==========
        s_luOp <= ADD_ALU_OP;
        wait for PERIOD / 2;
        assert ((to_integer(signed(s_luOut)) = ((op1_i + op2_i)))or(to_integer(signed(s_luOut)) = ((op1_i + op2_i) mod 2**DATA_WIDTH_GEN ))or(
                to_integer(signed(s_luOut)) = ((op1_i + op2_i) - 2**DATA_WIDTH_GEN)))
       report "Fehler bei ADD: " & integer'image(op1_i) & " + " &
                 integer'image(op2_i) & " = " & integer'image(op1_i + op2_i) &
                 ", ALU ergibt " & integer'image(to_integer(signed(s_luOut)))
          severity error;

        -- Zero-Flag Prüfung
        assert (((op1_i + op2_i) mod 2**DATA_WIDTH_GEN = 0) and s_zero = '1') or
               (((op1_i + op2_i) mod 2**DATA_WIDTH_GEN /= 0) and s_zero = '0')
          report "Zero-Flag bei ADD falsch"
          severity error;

        -- ====================
        -- Test: SUB
        -- ====================
        s_luOp <= SUB_ALU_OP;
        wait for PERIOD / 2;

        -- Erwartetes Ergebnis als Integer
       v_expected_sub_result := to_integer(signed(s_op1)-signed(s_op2));

        -- Prüfe SUB-Ergebnis
        assert to_signed(v_expected_sub_result, DATA_WIDTH_GEN) = signed(s_luOut)
          report "Fehler im SUB-Ergebnis: " & to_string(s_op1) & " - " & to_string(s_op2)
          severity error;

        -- Prüfe Zero-Flag
        assert ((v_expected_sub_result = 0 and s_zero = '1') or
                (v_expected_sub_result /= 0 and s_zero = '0'))
          report "Fehler im Zero-Flag der SUB-Funktion"
          severity error;

        -- Prüfe CarryOut bei unsigned Interpretation (Borrow)
        -- ==========================================================================
        -- Hinweis zur Bedeutung von CarryOut bei SUB (Zweierkomplement):
        -- --------------------------------------------------------------------------
        -- In unserer ALU wird SUB als A - B = A + NOT(B) + 1 realisiert.
        -- Das CarryOut-Signal ergibt sich aus dem letzten Übertrag dieser Addition.
        -- 
        -- WICHTIG:
        -- - Bei einer SUB bedeutet CarryOut = '1', dass KEIN Borrow (Ausleihe) nötig war,
        --   also A >= B (in unsigned Darstellung).
        -- - CarryOut = '0' signalisiert, dass ein Borrow aufgetreten ist, also A < B.
        -- 
        -- Deshalb wird das CarryOut bei Subtraktion NICHT über signed-Überläufe,
        -- sondern über einen unsigned-Vergleich von A und B validiert!
        -- ======================================================================
        v_op1_u := unsigned(s_op1);
        v_op2_u := unsigned(s_op2);

        -- Erwartetes CarryOut (kein Borrow = '1', Borrow = '0')
        if v_op1_u >= v_op2_u then
          v_expected_carry := '1';  -- Kein Borrow nötig
        else
          v_expected_carry := '0';  -- Borrow nötig
        end if;

        -- Vergleich
        assert s_carryOut = v_expected_carry
          report "Fehler im CarryOut der SUB-Funktion (Borrow): " &
                "op1=" & integer'image(op1_i) & ", op2=" & integer'image(op2_i) &
                ", Erwartet Carry=" & std_logic'image(v_expected_carry) &
                ", geliefert: " & std_logic'image(s_carryOut)
          severity error;



        -- ========== SLT (signed) ==========
        s_luOp <= SLT_ALU_OP;
        wait for PERIOD / 2;
        assert ((op1_i < op2_i and to_integer(signed(s_luOut)) = 1) or
                (op1_i >= op2_i and to_integer(signed(s_luOut)) = 0))
          report "Fehler bei SLT"
          severity error;
        assert ((op1_i >= op2_i and s_zero = '1') or
                (op1_i < op2_i and s_zero = '0'))
          report "Zero-Flag bei SLT falsch"
          severity error;
      end loop;
    end loop;

    -- ========== SLTU (unsigned) ==========
    for op1_i in 0 to 2**DATA_WIDTH_GEN - 1 loop
      s_op1 <= std_logic_vector(to_unsigned(op1_i, DATA_WIDTH_GEN));
      for op2_i in 0 to 2**DATA_WIDTH_GEN - 1 loop
        s_op2 <= std_logic_vector(to_unsigned(op2_i, DATA_WIDTH_GEN));
        s_luOp <= SLTU_ALU_OP;
        wait for PERIOD / 2;

        assert (((op1_i < op2_i) and (to_integer(unsigned(s_luOut)) = 1)) or
                ((op1_i >= op2_i) and (to_integer(unsigned(s_luOut)) = 0)))
          report "Fehler bei SLTU: " & integer'image(op1_i) & " < " &
                 integer'image(op2_i) & ", ALU ergibt " & to_string(s_luOut)
          severity error;

        assert (((op1_i >= op2_i) and s_zero = '1') or
                ((op1_i < op2_i) and s_zero = '0'))
          report "Zero-Flag bei SLTU falsch"
          severity error;
      end loop;
    end loop;

    -- Abschließende Meldung
    assert false
      report "Ende des ALU-Tests erreicht!"
      severity note;

    wait; -- Endlosschleife, um Simulation zu beenden
  end process stim_proc;

end architecture behavior;
