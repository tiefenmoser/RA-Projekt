-- Laboratory RA solutions/versuch1
-- Sommersemester 25
-- Group Details
-- Lab Date:
-- 1. Participant First and Last Name: Cornelius Tiefenmoser
-- 2. Participant First and Last Name: Maxi Gromut

-- ========================================================================
-- Author:       Marcel Rieß
-- Last updated: 31.03.2025
-- Description:  Testbench for the ALU declared in my_alu.vhdl
-- ========================================================================

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use ieee.math_real.all;
  use work.constant_package.all;

entity alu_tb is
end entity alu_tb;

architecture behavior of alu_tb is

  -- Signal declarations
  signal s_op1            : std_logic_vector(DATA_WIDTH_GEN - 1 downto 0) := (others => '0');
  signal s_op2            : std_logic_vector(DATA_WIDTH_GEN - 1 downto 0) := (others => '0');
  signal s_luOut          : std_logic_vector(DATA_WIDTH_GEN - 1 downto 0) := (others => '0');
  signal s_expect         : std_logic_vector(DATA_WIDTH_GEN - 1 downto 0) := (others => '0');
  signal s_luOp           : std_logic_vector(ALU_OPCODE_WIDTH - 1 downto 0) := (others => '0');
  signal s_carryOut       : std_logic;
  signal s_shiftType      : std_logic;
  signal s_shiftDirection : std_logic;
  constant PERIOD         : time := 1 ns; -- Example: Clock period of 1 ns

begin

  -- Instantiate ALU
  lu1 : entity work.alu
    generic map (DATA_WIDTH_GEN, ALU_OPCODE_WIDTH)
    port map (
      pi_op1       => s_op1,
      pi_op2       => s_op2,
      pi_aluOp     => s_luOp,
      po_aluOut    => s_luOut,
      po_carryOut  => s_carryOut
    );

  -- ALU test process
  lu : process is
  begin
    for op1_i in -(2 ** (DATA_WIDTH_GEN - 1)) to (2 ** (DATA_WIDTH_GEN - 1) - 1) loop
      s_op1 <= std_logic_vector(to_signed(op1_i, DATA_WIDTH_GEN));
      for op2_i in -(2 ** (DATA_WIDTH_GEN - 1)) to (2 ** (DATA_WIDTH_GEN - 1) - 1) loop
        s_op2 <= std_logic_vector(to_signed(op2_i, DATA_WIDTH_GEN));
        wait for PERIOD;

        -- AND operation test
        s_luOp  <= AND_ALU_OP;
        s_expect <= s_op1 and s_op2;
        wait for PERIOD;
        assert (s_expect = s_luOut) report "Error in AND operation" severity error;

        -- OR operation test
        s_luOp  <= OR_ALU_OP;
        s_expect <= s_op1 or s_op2;
        wait for PERIOD;
        assert (s_expect = s_luOut) report "Error in OR operation" severity error;

        -- XOR operation test
        s_luOp  <= XOR_ALU_OP;
        s_expect <= s_op1 xor s_op2;
        wait for PERIOD;
        assert (s_expect = s_luOut) report "Error in XOR operation" severity error;

        -- Shift operations (SLL, SRL, SRA)
        if (op2_i >= 0 and op2_i < integer(log2(real(DATA_WIDTH_GEN)))) then
          
          -- Logical shift left (SLL)
          s_luOp <= SLL_ALU_OP;
          if (op2_i <= 0) then
            s_expect <= s_op1;
          elsif (op2_i < DATA_WIDTH_GEN) then
            s_expect(op2_i - 1 downto 0) <= (others => '0');
            s_expect(DATA_WIDTH_GEN - 1 downto op2_i) <= s_op1(DATA_WIDTH_GEN - 1 - op2_i downto 0);
          end if;
          wait for PERIOD; assert (s_expect = s_luOut)   report "Error in SLL operation"   severity error;

          -- Logical shift right (SRL)
          s_luOp  <= SRL_ALU_OP;
          s_expect <= (others => '0');
          if (op2_i <= 0) then
            s_expect <= s_op1;
          elsif (op2_i < DATA_WIDTH_GEN) then
            s_expect(DATA_WIDTH_GEN - 1 - op2_i downto 0) <= s_op1(DATA_WIDTH_GEN - 1 downto op2_i);
          end if;
          wait for PERIOD;
          assert (s_expect = s_luOut)   report "Error in SRL operation"   severity error;

          -- Arithmetic shift right (SRA)
          s_luOp <= SRA_ALU_OP;
          if (op2_i <= 0) then s_expect <= s_op1;
          elsif (op2_i < DATA_WIDTH_GEN) then
            s_expect <= (others => s_op1(DATA_WIDTH_GEN - 1));
            s_expect(DATA_WIDTH_GEN - 1 - op2_i downto 0) <= s_op1(DATA_WIDTH_GEN - 1 downto op2_i);
          end if;
          wait for PERIOD;
          assert (s_expect = s_luOut)   report "Error in SRA operation"   severity error;
        end if;

        -- ADD operation test
        s_luOp <= ADD_ALU_OP;
        wait for PERIOD;
        if (((op1_i + op2_i) /= to_integer(signed(s_luOut))) and
            ((op1_i + op2_i - 2 ** DATA_WIDTH_GEN) /= to_integer(signed(s_luOut))) and
            ((to_integer(signed(s_luOut)) /= (op1_i + op2_i) mod (2 ** DATA_WIDTH_GEN)))) then
          report "Error in ADD operation"   severity error;
        end if;

        -- SUB operation test
        s_luOp <= SUB_ALU_OP;
        wait for PERIOD;
        if (((op1_i - op2_i) /= to_integer(signed(s_luOut))) and
            ((op1_i - op2_i - 2 ** DATA_WIDTH_GEN) /= to_integer(signed(s_luOut))) and
            ((to_integer(signed(s_luOut)) /= (op1_i - op2_i) mod (2 ** DATA_WIDTH_GEN)))) then
          report "Error in SUB operation" severity error;
        end if;
      end loop;
    end loop;

    -- End of test
    assert false report "End of ALU test" severity note;
    wait; -- Wait forever to stop simulation
  end process lu;

end architecture behavior;
