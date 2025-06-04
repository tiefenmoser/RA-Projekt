-- Laboratory RA solutions/versuch6
-- Sommersemester 25
-- Group Details
-- Lab Date: 4.5.25
-- 1. Participant First and Last Name: Cornelius Tiefenmoser
-- 2. Participant First and Last Name: Maxi Gromut
-- 3. Participant First and Last Name: Rupert Honold

-- ========================================================================
-- Author:       Marcel Rieß
-- Last updated: 23.05.2025
-- Description:  RIU-Only-RISC-V (incomplete RV32I implementation)
--               Supports only R-, I- and U-Instructions.
-- ========================================================================

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.constant_package.ALL;
USE work.types.ALL;
USE work.util_asm_package.ALL;

ENTITY riu_only_RISC_V_tb IS
END ENTITY;

ARCHITECTURE structure OF riu_only_RISC_V_tb IS

  CONSTANT PERIOD : TIME := 10 ns;

  SIGNAL s_clk        : STD_LOGIC := '0';
  SIGNAL s_rst        : STD_LOGIC;
  SIGNAL cycle        : INTEGER := 0;
  SIGNAL test         : INTEGER := 0;

  SIGNAL s_registersOut     : registerMemory := (OTHERS => (OTHERS => '0'));
  SIGNAL s_instructions     : memory := (OTHERS => (OTHERS => '0'));

  -- Registerprüfung
  PROCEDURE check_register(expected : INTEGER; reg_num : INTEGER; instr : STRING) IS
  BEGIN
    ASSERT (to_integer(signed(s_registersOut(reg_num))) = expected)
      REPORT instr & " fehlgeschlagen. Register " & INTEGER'image(reg_num) &
             " enthaelt " & INTEGER'image(to_integer(signed(s_registersOut(reg_num)))) &
             ", sollte aber " & INTEGER'image(expected) & " enthalten!"
      SEVERITY error;
  END PROCEDURE;

  -- Wiederverwendbares Instruktionsset (ADDI, OR, ADD, etc.)
  PROCEDURE load_common_instructions(mem : INOUT memory;v_test : INTEGER) IS
  BEGIN
    mem(1)  := Asm2Std("ADDI", 1, 0, 9);
    mem(2)  := Asm2Std("ADDI", 2, 0, 8);
    mem(6)  := Asm2Std("OR", 10, 1, 2);
    mem(7)  := Asm2Std("ADD", 8, 1, 2);
    mem(8)  := Asm2Std("SUB", 11, 1, 2);
    mem(9)  := Asm2Std("SUB", 12, 2, 1);
    mem(11) := Asm2Std("ADD", 12, 2, 8);
    mem(12) := Asm2Std("SUB", 12, 2, 1);
    mem(13) := Asm2Std("AND", 1, 2, 1);
    mem(14) := Asm2Std("XOR", 12, 1, 2);
    mem(15) := Asm2Std("LUI", 13, 8, 0);
    mem(16) := Asm2Std("LUI", 13, 29, 0);
    if v_test >= 2 then
      mem(17) := Asm2Std("AUIPC", 14, 1, 0);
      mem(18) := Asm2Std("AUIPC", 14, 1, 0);
    end if;
    
    if v_test = 3 then
      mem(19) := Asm2Std("JAL", 15, -36, 0);
    end if;
    
    if v_test = 4 then
      mem(19) := Asm2Std("JAL", 15, 70, 0);
      mem(54) := Asm2Std("JALR", 15, 15, -56);
    end if;

  END PROCEDURE;

BEGIN

  -- DUT
  riub_only_riscv : ENTITY work.riu_only_RISC_V
    PORT MAP (
      pi_rst => s_rst,
      pi_clk => s_clk,
      pi_instruction => s_instructions,
      po_registersOut => s_registersOut
    );

  -- Taktgenerator
  PROCESS
  BEGIN
  WHILE now < 5000 ns LOOP
    WAIT FOR PERIOD / 2;
    s_clk <= NOT s_clk;
    END LOOP;
  WAIT; -- Prozess beenden
  END PROCESS;

  -- Testlaufprozess
  PROCESS
  VARIABLE v_instr : memory := (OTHERS => (OTHERS => '0'));
  BEGIN
    -- === Test 1: LUI ===
    REPORT "== TEST 1: LUI ==";
    test <= 1;
    s_rst <= '1'; WAIT FOR PERIOD;
    s_rst <= '0';
    load_common_instructions(v_instr,test);
    s_instructions <= v_instr;
    FOR i IN 1 TO 100 LOOP
      WAIT UNTIL rising_edge(s_clk);
      cycle <= i;
    END LOOP;

    -- === Test 2: AUIPC ===
    REPORT "== TEST 2: AUIPC ==";
    test <= 2;
    s_rst <= '1'; WAIT FOR PERIOD/2;
    s_rst <= '0'; WAIT FOR PERIOD/2;
    load_common_instructions(v_instr,test);
    s_instructions <= v_instr;
    

    FOR i IN 1 TO 100 LOOP
      WAIT UNTIL rising_edge(s_clk);
      cycle <= i;
    END LOOP;
    REPORT "==   PASSED   ==";     
    -- === Test 3: JAL ===
    REPORT "== TEST 3: JAL ==";
    test <= 3;
    s_rst <= '1'; WAIT FOR PERIOD/2;
    s_rst <= '0'; WAIT FOR PERIOD/2;
    load_common_instructions(v_instr,test);
    s_instructions <= v_instr;
    

    FOR i IN 1 TO 100 LOOP
      WAIT UNTIL rising_edge(s_clk);
      cycle <= i;
    END LOOP;
    REPORT "==   PASSED   ==";
    -- === Test 4: JALR ===
    REPORT "== TEST 4: JALR ==";
    test <= 4;
    s_rst <= '1'; WAIT FOR PERIOD/2;
    s_rst <= '0'; WAIT FOR PERIOD/2;
    load_common_instructions(v_instr,test);
    s_instructions <= v_instr;

    FOR i IN 1 TO 100 LOOP
      WAIT UNTIL rising_edge(s_clk);
      cycle <= i;
    END LOOP;
    REPORT "==   PASSED   ==";
    REPORT "== ALLE TESTS ABGESCHLOSSEN ==";
    WAIT;
  END PROCESS;

  -- Prüfroutine (separat lassen für Klarheit)
  PROCESS (cycle)
  BEGIN
    IF test >= 1 THEN
      -- Prüflogik für LUI
      IF (cycle =  6) THEN check_register(       9,  1, "ADDI" );END IF;
      IF (cycle =  7) THEN check_register(       8,  2, "ADDI" );END IF;
      IF (cycle = 11) THEN check_register(       9, 10, "OR"   );END IF;
      IF (cycle = 12) THEN check_register(      17,  8, "ADD"  );END IF;
      IF (cycle = 13) THEN check_register(       1, 11, "SUB"  );END IF;
      IF (cycle = 14) THEN check_register(      -1, 12, "SUB"  );END IF;
      IF (cycle = 16) THEN check_register(      25, 12, "ADD"  );END IF;
      IF (cycle = 17) THEN check_register(      -1, 12, "SUB"  );END IF;
      IF (cycle = 18) THEN check_register(       8,  1, "AND"  );END IF;
      IF (cycle = 19) THEN check_register(       1, 12, "XOR"  );END IF;
      IF (cycle = 20) THEN check_register( 8*2**12, 13, "LUI"  );END IF;
      IF (cycle = 21) THEN check_register(29*2**12, 13, "LUI"  );END IF;
      end if;
    IF test >= 2 THEN
      -- Prüflogik für AUIPC
      --REPORT "Register " & INTEGER'image(14) &
      --       " enthaelt " & INTEGER'image(to_integer(signed(s_registersOut(14)))) 
      --        ;
      IF (cycle = 22) THEN check_register(    4164, 14, "AUIPC");END IF;
      IF (cycle = 23) THEN check_register(    4168, 14, "AUIPC");END IF;
    END IF;
    IF test = 3 THEN
      -- Prüflogik für JAL
      IF (cycle =    24) THEN check_register( 80, 15, "JAL" );END IF;
      IF (cycle = 23+5) THEN check_register(  9, 1, "ADDI" );END IF;
      IF (cycle = 22+7) THEN check_register(  8, 2, "ADDI" );END IF;
      IF (cycle = 22+11) THEN check_register(  9,10, "OR" );END IF;
      IF (cycle = 22+12) THEN check_register(  17, 8, "ADD" ); END IF;
      IF (cycle = 22+13) THEN check_register(  1,11, "SUB" ); END IF;
      IF (cycle = 22+14) THEN check_register( -1,12, "SUB" );END IF;
      IF (cycle = 22+16) THEN check_register( 25,12, "ADD" );END IF;
      IF (cycle = 22+17) THEN check_register( -1,12, "SUB" );END IF;
      IF (cycle = 22+18) THEN check_register(  8,2, "AND" );END IF;
      IF (cycle = 22+19) THEN check_register(  1,12, "XOR" );END IF;
      IF (cycle = 22+20) THEN check_register(8*2**12, 13, "LUI" );END IF;
      IF (cycle = 22+21) THEN check_register(29*2**12, 13, "LUI" );END IF;
      IF (cycle = 22+22) THEN check_register(4164,14, "AUIPC" );END IF;
      IF (cycle = 22+23) THEN check_register(4168,14, "AUIPC" );END IF;
    END IF;
    IF test = 4 THEN
      -- Prüflogik für JALR
      IF (cycle = 24) THEN check_register(      80, 15, "JAL"  );END IF;
      IF (cycle = 28) THEN check_register(220,15, "JALR" );END IF;
      IF (cycle = 32) THEN check_register(  8, 1, "JALR" );END IF;
      IF (cycle = 32) THEN check_register(  8, 2, "JALR" );END IF;
      IF (cycle = 33) THEN check_register(       8, 10, "OR"   );END IF;
      IF (cycle = 34) THEN check_register(      16,  8, "ADD"  );END IF;
      IF (cycle = 35) THEN check_register(       0, 11, "SUB"  );END IF;
      IF (cycle = 36) THEN check_register(       0, 12, "SUB"  );END IF;
      IF (cycle = 37) THEN check_register(      24, 12, "ADD"  );END IF;
      IF (cycle = 38) THEN check_register(       0, 12, "SUB"  );END IF;
      IF (cycle = 39) THEN check_register(       8, 1, "AND"  );END IF;
    END IF;
  END PROCESS;

END ARCHITECTURE;