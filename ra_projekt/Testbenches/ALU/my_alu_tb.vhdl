-- ========================================================================
-- Author:       Marcel Rieß
-- Last updated: 25.03.2025
-- Description:  Testbench for the ALU declared in my_alu.vhdl
-- ========================================================================

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use ieee.math_real.all;
  use work.constant_package.all;

entity my_alu_tb is
end entity my_alu_tb;

architecture behavior of my_alu_tb is

  -- Signale für Inputs und Outputs der ALU
  signal s_op1       : std_logic_vector(DATA_WIDTH_GEN - 1 downto 0) := (others => '0');
  signal s_op2       : std_logic_vector(DATA_WIDTH_GEN - 1 downto 0) := (others => '0');
  signal s_luOut     : std_logic_vector(DATA_WIDTH_GEN - 1 downto 0) := (others => '0');
  signal s_expect    : std_logic_vector(DATA_WIDTH_GEN - 1 downto 0) := (others => '0');
  signal s_luOp      : std_logic_vector(ALU_OPCODE_WIDTH - 1 downto 0) := (others => '0');
  signal s_carryOut  : std_logic;
  signal s_shiftType : std_logic;
  signal s_zero      : std_logic;
  signal s_zeroarray : std_logic_vector(ALU_OPCODE_WIDTH - 1 downto 0) := (others => '0');

  constant PERIOD : time := 10 ns;

begin

  -- Instanziierung der ALU
  lu1 : entity work.alu
    generic map (
      DATA_WIDTH_GEN, 
      ALU_OPCODE_WIDTH
    )
    port map (
      pi_op1      => s_op1,
      pi_op2      => s_op2,
      pi_aluOp    => s_luOp,
      po_aluOut   => s_luOut,
      po_carryOut => s_carryOut
    );

  -- Haupt-Testprozess
  lu : process is
  begin

    -- Teste alle möglichen Kombinationen von op1 und op2 im signed Bereich
    for op1_i in - (2 ** (DATA_WIDTH_GEN - 1)) to (2 ** (DATA_WIDTH_GEN - 1) - 1) loop
      s_op1 <= std_logic_vector(to_signed(op1_i, DATA_WIDTH_GEN));
      wait for PERIOD/2;

      for op2_i in - (2 ** (DATA_WIDTH_GEN - 1)) to (2 ** (DATA_WIDTH_GEN - 1) - 1) loop
        s_op2 <= std_logic_vector(to_signed(op2_i, DATA_WIDTH_GEN));

        -- === Logische Operationen ===

        -- AND
        s_luOp <= AND_ALU_OP;
        wait for PERIOD / 2;
        assert ((s_op1 and s_op2) = s_luOut)
          report "Fehler bei AND: " & to_string(s_op1) & " AND " & to_string(s_op2)
          severity error;

        -- OR
        s_luOp <= OR_ALU_OP;
        wait for PERIOD / 2;
        assert ((s_op1 or s_op2) = s_luOut)
          report "Fehler bei OR"
          severity error;

        -- XOR
        s_luOp <= XOR_ALU_OP;
        s_expect <= s_op1 xor s_op2;
        wait for PERIOD / 2;
        assert (s_expect = s_luOut)
          report "Fehler bei XOR: " & to_string(s_op1) & " XOR " & to_string(s_op2)
          severity error;

        -- === Shift-Operationen ===
        if (op2_i >= 0 and op2_i < integer(log2(real(DATA_WIDTH_GEN)))) then

          -- SLL (Shift Left Logical)
          s_luOp <= SLL_ALU_OP;
          wait for PERIOD/2;
          if op2_i <= 0 then
            s_expect <= s_op1;
          elsif op2_i < DATA_WIDTH_GEN then
            s_expect(op2_i - 1 downto 0)                  <= (others => '0');
            s_expect(DATA_WIDTH_GEN - 1 downto op2_i)     <= s_op1(DATA_WIDTH_GEN - 1 - op2_i downto 0);
          end if;
          wait for PERIOD / 2;
          assert (s_expect = s_luOut)
            report "Fehler bei SLL"
            severity error;

          -- SRL (Shift Right Logical)
          s_luOp <= SRL_ALU_OP;
          wait for PERIOD/2;
          s_expect <= (others => '0');
          if op2_i <= 0 then
            s_expect <= s_op1;
          elsif op2_i < DATA_WIDTH_GEN then
            s_expect(DATA_WIDTH_GEN - 1 - op2_i downto 0) <= s_op1(DATA_WIDTH_GEN - 1 downto op2_i);
          end if;
          wait for PERIOD / 2;
          assert (s_expect = s_luOut)
            report "Fehler bei SRL"
            severity error;

          -- SRA (Shift Right Arithmetic)
          s_luOp <= SRA_ALU_OP;
          wait for PERIOD/2;
          if op2_i <= 0 then
            s_expect <= s_op1;
          elsif op2_i < DATA_WIDTH_GEN then
            s_expect <= (others => s_op1(DATA_WIDTH_GEN - 1));
            s_expect(DATA_WIDTH_GEN - 1 - op2_i downto 0) <= s_op1(DATA_WIDTH_GEN - 1 downto op2_i);
          end if;
          wait for PERIOD / 2;
          assert (s_expect = s_luOut)
            report "Fehler bei SRA"
            severity error;
        end if;

        -- === Arithmetische Operationen ===

        -- ADD mit Überlaufprüfung
        s_luOp <= ADD_ALU_OP;
        wait for PERIOD / 2;
        assert (
          (to_integer(signed(s_luOut)) = op1_i + op2_i) or
          (to_integer(signed(s_luOut)) = (op1_i + op2_i + 2**DATA_WIDTH_GEN)) or
          (to_integer(signed(s_luOut)) = (op1_i + op2_i - 2**DATA_WIDTH_GEN))
        )
        report integer'image(op1_i) & " + " & integer'image(op2_i) & " = " &
               integer'image(op1_i + op2_i) & ", aber Ergebnis: " &
               integer'image(to_integer(signed(s_luOut)))
        severity error;

        -- SUB mit Überlaufprüfung
        s_luOp <= SUB_ALU_OP;
        wait for PERIOD / 2;
        assert (
          (to_integer(signed(s_luOut)) = op1_i - op2_i) or
          (to_integer(signed(s_luOut)) = (op1_i - op2_i + 2**DATA_WIDTH_GEN)) or
          (to_integer(signed(s_luOut)) = (op1_i - op2_i - 2**DATA_WIDTH_GEN))
        )
        report integer'image(op1_i) & " - " & integer'image(op2_i) & " = " &
               integer'image(op1_i - op2_i) & ", aber Ergebnis: " &
               integer'image(to_integer(signed(s_luOut)))
        severity error;

        -- SLT (Set Less Than, signed)
        s_luOp <= SLT_ALU_OP;
        wait for PERIOD / 2;
        if op1_i < op2_i then
          assert to_integer(signed(s_luOut)) = 1
            report "Fehler bei SLT: " & integer'image(op1_i) & " < " & integer'image(op2_i)
            severity error;
        else
          assert to_integer(signed(s_luOut)) = 0
            report "Fehler bei SLT: " & integer'image(op1_i) & " >= " & integer'image(op2_i)
            severity error;
        end if;

        wait for PERIOD / 2;
      end loop;
    end loop;

    -- === SLTU (Set Less Than, unsigned) ===
    for op1_i in 0 to (2**DATA_WIDTH_GEN - 1) loop
      s_op1 <= std_logic_vector(to_unsigned(op1_i, DATA_WIDTH_GEN));
      wait for PERIOD/2;

      for op2_i in 0 to (2**DATA_WIDTH_GEN - 1) loop
        s_op2 <= std_logic_vector(to_unsigned(op2_i, DATA_WIDTH_GEN));
        wait for PERIOD/2;

        s_luOp <= SLTU_ALU_OP;
        wait for PERIOD/2;

        if (op1_i < op2_i and to_integer(unsigned(s_luOut)) /= 1) or
           (op1_i >= op2_i and to_integer(unsigned(s_luOut)) /= 0) then
          report "Fehler bei SLTU: " & integer'image(op1_i) & " < " & integer'image(op2_i)
            severity error;
        end if;
      end loop;
    end loop;

    -- Simulation beenden
    assert false
      report "Ende des ALU-Tests!"
      severity note;

    wait; -- Stoppe die Simulation

  end process lu;

end architecture behavior;
