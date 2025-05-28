-- Laboratory RA solutions/versuch5
-- Sommersemester 25
-- Group Details
-- Lab Date:
-- 1. Participant First and Last Name: 
-- 2. Participant First and Last Name:

-- ========================================================================
-- Author:       Marcel Rieß
-- Last updated: 21.05.2025
-- Description:  RI-Only-RISC-V for an incomplete RV32I implementation, support
--               only R- and I-Instructions. 
--
-- ========================================================================

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.constant_package.ALL;
USE work.types.ALL;
USE work.util_asm_package.ALL;
ENTITY ri_only_RISC_V_tb IS

END ENTITY ri_only_RISC_V_tb;

ARCHITECTURE structure OF ri_only_RISC_V_tb IS

  CONSTANT PERIOD           : TIME            := 10 ns;
  SIGNAL s_clk              : STD_LOGIC       := '0';
  SIGNAL s_rst              : STD_LOGIC       := '0';
  SIGNAL cycle              : INTEGER         :=0;
  SIGNAL s_test             : INTEGER         := 0;
  SIGNAL s_registersOut     : registerMemory  := (OTHERS => (OTHERS => '0'));
  SIGNAL s_instructions     : memory          := (OTHERS => (OTHERS => '0'));

  -- Prozedur fuer Vergleich
 PROCEDURE check_register (
  expected : INTEGER;
  reg_num  : INTEGER;
  instr    : STRING
) IS
BEGIN
  ASSERT (to_integer(signed(s_registersOut(reg_num))) = expected)
    REPORT instr & " fehlgeschlagen. Register " & INTEGER'image(reg_num) &
           " enthaelt " & INTEGER'image(to_integer(signed(s_registersOut(reg_num)))) &
           ", sollte aber " & INTEGER'image(expected) & " enthalten!" SEVERITY error;
END PROCEDURE;

BEGIN

  DUT : ENTITY work.ri_only_RISC_V
    PORT MAP(
      pi_rst          => s_rst,
      pi_clk          => s_clk,
      pi_instruction  => s_instructions,
      po_registersOut => s_registersOut
    );

  PROCESS (cycle) IS

  BEGIN

       IF s_test = 1 THEN
        IF (cycle =  5) THEN check_register(  9, 1, "ADDI" );END IF;
        IF (cycle =  6) THEN check_register(  8, 2, "ADDI" );END IF;
        IF (cycle = 12) THEN check_register( 13, 3, "ORI"  );END IF;
        IF (cycle = 13) THEN check_register(  8, 2, "ADDI" );END IF;
        IF (cycle = 14) THEN check_register(288, 3, "SLLI" );END IF;
        IF (cycle = 15) THEN check_register(  0, 3, "SRLI" );END IF;
        IF (cycle = 16) THEN check_register( 12, 3, "XORI" );END IF;
        IF (cycle = 17) THEN check_register(  1, 3, "XOR"  );END IF;
        IF (cycle = 18) THEN check_register(  1, 3, "SLTI first" );END IF;
        IF (cycle = 19) THEN check_register(  0, 3, "SLTIU");END IF;
        IF (cycle = 20) THEN check_register(  0, 3, "SLTI second" );END IF;
        IF (cycle = 21) THEN check_register(  1, 3, "SLTIU");END IF;
        IF (cycle = 28) THEN check_register(  1, 3, "SLT"  );END IF;
        IF (cycle = 29) THEN check_register(  1, 3, "SLTU" );END IF;
        IF (cycle = 30) THEN check_register(  0, 3, "SLT"  );END IF;
        IF (cycle = 31) THEN check_register(  0, 3, "SLTU" );END IF;

      ELSIF s_test = 2 THEN
        IF (cycle =  5) THEN check_register(  9, 1, "ADDI" );END IF;
        IF (cycle =  6) THEN check_register(  8, 2, "ADDI" );END IF;
        IF (cycle = 10) THEN check_register( 17, 8, "ADD"  );END IF;
        IF (cycle = 11) THEN check_register(  1,11, "SUB"  );END IF;
        IF (cycle = 12) THEN check_register( -1,12, "SUB"  );END IF;
        IF (cycle = 13) THEN check_register(  9, 9, "OR"   );END IF;
        IF (cycle = 14) THEN check_register(  1, 9, "XOR"  );END IF;
        IF (cycle = 15) THEN check_register(  8, 9, "AND"  );END IF;
        IF (cycle = 16) THEN check_register( 16, 8, "SLL"  );END IF;
        IF (cycle = 17) THEN check_register(  8, 8, "SRL"  );END IF;
        IF (cycle = 18) THEN check_register( -8, 9, "SUB"  );END IF;
        IF (cycle = 19) THEN check_register(  0,10, "SRA"  );END IF;
      END IF;

  END PROCESS;

  PROCESS IS
  BEGIN
    -- test 1 I-Format
    s_test <= 1;
    s_instructions <= (
       1 => Asm2Std("ADDI" , 1, 0,  9),
       2 => Asm2Std("ADDI" , 2, 0,  8),
       8 => Asm2Std("ORI"  , 3, 1,  5),
       9 => Asm2Std("ANDI" , 3, 1,  5),
      10 => Asm2Std("SLLI" , 3, 1,  5),
      11 => Asm2Std("SRLI" , 3, 1,  5),
      12 => Asm2Std("XORI" , 3, 1,  5),
      13 => Asm2Std("XOR"  , 3, 1,  2),
      14 => Asm2Std("SLTI" , 3, 1, 10),
      15 => Asm2Std("SLTIU", 3, 1,  8),
      16 => Asm2Std("SLTI" , 3, 1,-10),
      17 => Asm2Std("SLTIU", 3, 1, -8),
      18 => Asm2Std("SUB"  ,14, 0,  1),
      19 => Asm2Std("SUB"  ,15, 0,  2),
      24 => Asm2Std("SLT"  , 3,14, 15),
      25 => Asm2Std("SLTU" , 3,14, 15),
      26 => Asm2Std("SLT"  , 3,15, 14),
      27 => Asm2Std("SLTU" , 3,15, 14), 
      OTHERS => (OTHERS => '0')
      );
    WAIT FOR PERIOD;
    FOR i IN 1 TO 35 LOOP
      s_clk <= '1';
      WAIT FOR PERIOD / 2;
      s_clk <= '0';
      WAIT FOR PERIOD / 2;
      cycle <= i;
    END LOOP;
    REPORT "End of tests for I-Format!";

    -- test 2 (R Befehle)
s_test <= 2;

      s_rst <= '1';
      WAIT FOR PERIOD / 2;
      s_rst <= '0';
      WAIT FOR PERIOD / 2;

    s_instructions <= (
       1 => Asm2Std("ADDI",  1, 0,  9),
       2 => Asm2Std("ADDI",  2, 0,  8),
       6 => Asm2Std("ADD" ,  8, 1,  2),
       7 => Asm2Std("SUB" , 11, 1,  2),
       8 => Asm2Std("SUB" , 12, 2,  1),
       9 => Asm2Std("OR"  ,  9, 2,  1),
      10 => Asm2Std("XOR" ,  9, 2,  1),
      11 => Asm2Std("AND" ,  9, 2,  1),
      12 => Asm2Std("SLL" ,  8, 2, 11),
      13 => Asm2Std("SRL" ,  8, 8, 11),
      14 => Asm2Std("SUB" ,  9, 0,  2),
      15 => Asm2Std("SRA" , 10, 1,  2),
      OTHERS => (OTHERS => '0')
      );

      WAIT FOR PERIOD ;

    FOR i IN 1 TO 22 LOOP
      s_clk <= '1';
      WAIT FOR PERIOD / 2;
      s_clk <= '0';
      WAIT FOR PERIOD / 2;
      cycle <= i;
    END LOOP;
    REPORT "End of tests for R-Format!";
    REPORT "End of test RI!!!";
    WAIT;

  END PROCESS;

END ARCHITECTURE;