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

ENTITY riub_only_RISC_V_tb IS
END ENTITY;

ARCHITECTURE structure OF riub_only_RISC_V_tb IS

  CONSTANT PERIOD     : TIME := 10 ns;
  CONSTANT WITH_FLUSH : STD_LOGIC := '0';
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
    
    if v_test = 7 then
      mem(19) := Asm2Std("JAL", 15, 70, 0);
      mem(20) := Asm2Std("ADDI", 1, 0, 99);
      mem(21) := Asm2Std("ADDI", 1, 0, 98);
      mem(22) := Asm2Std("ADDI", 1, 0, 97);
      mem(54) := Asm2Std("JALR", 15, 15, -56);
      mem(55) := Asm2Std("ADDI", 1, 0, 96);
      mem(56) := Asm2Std("ADDI", 1, 0, 95);
      mem(57) := Asm2Std("ADDI", 1, 0, 94);
    end if;
    if v_test = 4 then
      mem(19) := Asm2Std("JAL", 15, 70, 0);
      mem(54) := Asm2Std("JALR", 15, 15, -56);
    end if;

    if v_test >= 5 and v_test <= 6 then
      mem := (OTHERS => (OTHERS => '0'));
      mem( 1) := Asm2Std("ADDI", 1, 0, 9);
      mem( 2) := Asm2Std("ADDI", 2, 0, 9);
      mem( 6) := Asm2Std("BEQ", 1, 2, 4);
      mem( 7) := Asm2Std("ADDI", 1, 0, 666);
      mem( 8) := Asm2Std("ADDI", 1, 0, 0);

      mem( 9) := Asm2Std("ADDI", 1, 0, 16);
      mem(10) := Asm2Std("ADDI", 2, 0, 8);
      mem(14) := Asm2Std("BNE", 2, 1, 4);
      mem(15) := Asm2Std("ADDI", 1, 0, 999);
      mem(16) := Asm2Std("ADDI", 1, 0, 1);

      --rs1<rs2
      mem(17) := Asm2Std("ADDI", 1, 0, 6);
      mem(18) := Asm2Std("ADDI", 2, 0, 8);
      mem(22) := Asm2Std("BLT", 1, 2, 4);
      mem(23) := Asm2Std("ADDI", 1, 0, 666);
      mem(24) := Asm2Std("ADDI", 1, 0, 2);

      --rs1>rs2
      mem(25) := Asm2Std("ADDI", 1, 0, 9);
      mem(26) := Asm2Std("ADDI", 2, 0, 7);
      mem(30) := Asm2Std("BGE", 1, 2, 4);
      mem(31) := Asm2Std("ADDI", 1, 0, 999);
      mem(32) := Asm2Std("ADDI", 1, 0, 3);

      mem(33) := Asm2Std("ADDI", 1, 0, 11);
      mem(34) := Asm2Std("ADDI", 2, 0, 13);
      mem(38) := Asm2Std("BLTU", 1, 2, 4);
      mem(39) := Asm2Std("ADDI", 1, 0, 666);
      mem(40) := Asm2Std("ADDI", 1, 0, 4);

      mem(41) := Asm2Std("ADDI", 1, 0, 15);
      mem(42) := Asm2Std("ADDI", 2, 0, 14);
      mem(46) := Asm2Std("BGEU", 1, 2, 4);
      mem(47) := Asm2Std("ADDI", 1, 0, 999);
      mem(48) := Asm2Std("ADDI", 1, 0, 5);


      mem(48+ 1) := Asm2Std("ADDI", 1, 0, 9);
      mem(48+ 2) := Asm2Std("ADDI", 2, 0, 8);
      mem(48+ 6) := Asm2Std("BEQ", 2, 1, 4);
      mem(48+ 7) := Asm2Std("ADDI", 1, 0, 666);
      mem(48+ 8) := Asm2Std("ADDI", 1, 0, 0);

      mem(48+ 9) := Asm2Std("ADDI", 1, 0, 8);
      mem(48+10) := Asm2Std("ADDI", 2, 0, 8);
      mem(48+14) := Asm2Std("BNE", 1, 2, 4);
      mem(48+15) := Asm2Std("ADDI", 1, 0, 669);
      mem(48+16) := Asm2Std("ADDI", 1, 0, 1);

      --rs1<rs2
      mem(48+17) := Asm2Std("ADDI", 1, 0, 6);
      mem(48+18) := Asm2Std("ADDI", 2, 0, 8);
      mem(48+22) := Asm2Std("BLT", 2, 1, 4);
      mem(48+23) := Asm2Std("ADDI", 1, 0, 699);
      mem(48+24) := Asm2Std("ADDI", 1, 0, 2);

      --rs1>rs2
      mem(48+25) := Asm2Std("ADDI", 1, 0, 9);
      mem(48+26) := Asm2Std("ADDI", 2, 0, 7);
      mem(48+30) := Asm2Std("BGE", 2, 1, 4);
      mem(48+31) := Asm2Std("ADDI", 1, 0, 999);
      mem(48+32) := Asm2Std("ADDI", 1, 0, 3);

      mem(48+33) := Asm2Std("ADDI", 1, 0, 11);
      mem(48+34) := Asm2Std("ADDI", 2, 0, 13);
      mem(48+38) := Asm2Std("BLTU", 2, 1, 4);
      mem(48+39) := Asm2Std("ADDI", 1, 0, 996);
      mem(48+40) := Asm2Std("ADDI", 1, 0, 4);

      mem(48+41) := Asm2Std("ADDI", 1, 0, 15);
      mem(48+42) := Asm2Std("ADDI", 2, 0, 14);
      mem(48+46) := Asm2Std("BGEU", 2, 1, 4);
      mem(48+47) := Asm2Std("ADDI", 1, 0, 966);
      mem(48+48) := Asm2Std("ADDI", 1, 0, 5);
      mem(48+49) := Asm2Std("JAL", 15, 70, 0);
      mem(48+50) := Asm2Std("ADDI", 1, 0, 15);
      mem(48+51) := Asm2Std("ADDI", 1, 0, 14);
      mem(48+52) := Asm2Std("ADDI", 1, 0, 13);
      mem(48+49+35) := Asm2Std("JALR", 15, 15, -56);
      mem(48+49+35+1) := Asm2Std("ADDI", 1, 0, 12);
      mem(48+49+35+2) := Asm2Std("ADDI", 1, 0, 11);
      mem(48+49+35+3) := Asm2Std("ADDI", 1, 0, 10);
    end if;
  END PROCEDURE;

BEGIN

  -- DUT
  riub_only_riscv : ENTITY work.riub_only_RISC_V
    PORT MAP (
      pi_rst => s_rst,
      pi_clk => s_clk,
      pi_instruction => s_instructions,
      po_registersOut => s_registersOut
    );

  -- Taktgenerator
  PROCESS
  BEGIN
  WHILE now < 10000 ns LOOP
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
        -- === Test 5: Branches ===
    REPORT "== TEST 5: BRANCHES without FLUSH==";
    test <= 5;
    s_rst <= '1'; WAIT FOR PERIOD/2;
    s_rst <= '0'; WAIT FOR PERIOD/2;
    load_common_instructions(v_instr,test);
    s_instructions <= v_instr;

    FOR i IN 1 TO 150 LOOP
      WAIT UNTIL rising_edge(s_clk);
      cycle <= i;
    END LOOP;
    REPORT "==   PASSED   ==";
        -- === Test 6: Branches ===
    IF WITH_FLUSH THEN
    REPORT "== TEST 5: BRANCHES with FLUSH==";
    test <= 6;
    s_rst <= '1'; WAIT FOR PERIOD/2;
    s_rst <= '0'; WAIT FOR PERIOD/2;
    load_common_instructions(v_instr,test);
    s_instructions <= v_instr;

    FOR i IN 1 TO 150 LOOP
      WAIT UNTIL rising_edge(s_clk);
      cycle <= i;
    END LOOP;
    REPORT "==   PASSED   ==";
    END IF;
           -- === Test 7: JAL ===
    IF WITH_FLUSH THEN
    REPORT "== TEST 7: JUMPS with FLUSH==";
    test <= 7;
    s_rst <= '1'; WAIT FOR PERIOD/2;
    s_rst <= '0'; WAIT FOR PERIOD/2;
    load_common_instructions(v_instr,test);
    s_instructions <= v_instr;

    FOR i IN 1 TO 150 LOOP
      WAIT UNTIL rising_edge(s_clk);
      cycle <= i;
    END LOOP;
    REPORT "==   PASSED   ==";
    END IF;
    IF WITH_FLUSH THEN
    REPORT "== ALLE TESTS INKL. FLUSH ABGESCHLOSSEN ==";
    ELSE
    REPORT "== ALLE TESTS OHNE FLUSH ABGESCHLOSSEN ==";
    END IF;
    WAIT;
  END PROCESS;

  -- Prüfroutine (separat lassen für Klarheit)
  PROCESS (cycle)
  BEGIN
    IF test >= 1 and test<=4 THEN
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
    IF test >= 2 and test<=4 THEN
      -- Prüflogik für AUIPC
      --REPORT "Register " & INTEGER'image(14) &
      --       " enthaelt " & INTEGER'image(to_integer(signed(s_registersOut(14)))) 
      --        ;
      IF (cycle = 22) THEN check_register(    4164, 14, "AUIPC");END IF;
      IF (cycle = 23) THEN check_register(    4168, 14, "AUIPC");END IF;
    END IF;
    IF test = 3 THEN
      -- Prüflogik für JAL
      --REPORT "Register " & INTEGER'image(1) &
      --      " enthaelt " & INTEGER'image(to_integer(signed(s_registersOut(1))));
       
      IF (cycle = 24) THEN check_register(       80,15, "JAL"  );END IF;
      IF (cycle = 28) THEN check_register(        9, 1, "ADDI" );END IF;
      IF (cycle = 29) THEN check_register(        8, 2, "ADDI" );END IF;
      IF (cycle = 33) THEN check_register(        9,10, "OR"   );END IF;
      IF (cycle = 32) THEN check_register(       17, 8, "ADD"  ); END IF;
      IF (cycle = 33) THEN check_register(        1,11, "SUB"  ); END IF;
      IF (cycle = 36) THEN check_register(       -1,12, "SUB"  );END IF;
      IF (cycle = 38) THEN check_register(       25,12, "ADD"  );END IF;
      IF (cycle = 39) THEN check_register(       -1,12, "SUB"  );END IF;
      IF (cycle = 40) THEN check_register(         8,2, "AND"  );END IF;
      IF (cycle = 41) THEN check_register(        1,12, "XOR"  );END IF;
      IF (cycle = 42) THEN check_register( 8*2**12, 13, "LUI"  );END IF;
      IF (cycle = 43) THEN check_register(29*2**12, 13, "LUI"  );END IF;
      IF (cycle = 44) THEN check_register(     4164,14, "AUIPC");END IF;
      IF (cycle = 45) THEN check_register(     4168,14, "AUIPC");END IF;
    END IF;
    IF test = 4 THEN
      -- Prüflogik für JALR
      --  REPORT "Register " & INTEGER'image(10) &
      --  " enthaelt " & INTEGER'image(to_integer(signed(s_registersOut(10))));
      IF (cycle = 24) THEN check_register(       80,15, "JAL"  );END IF;
      IF (cycle = 28) THEN check_register(      220,15, "JALR" );END IF;
      IF (cycle = 33) THEN check_register(        8,10, "OR"   );END IF;
      IF (cycle = 34) THEN check_register(       16, 8, "ADD"  );END IF;
      IF (cycle = 35) THEN check_register(        0,11, "SUB"  );END IF;
      IF (cycle = 36) THEN check_register(        0,12, "SUB"  );END IF;
      IF (cycle = 37) THEN check_register(       24,12, "ADD"  );END IF;
      IF (cycle = 38) THEN check_register(        0,12, "SUB"  );END IF;
      IF (cycle = 39) THEN check_register(        8, 1, "AND"  );END IF;
    END IF;
    IF test >= 5 and test <= 6 THEN
      -- Prüflogik für BRANCHES
        -- REPORT "Register " & INTEGER'image(1) &
        -- " enthaelt " & INTEGER'image(to_integer(signed(s_registersOut(1))));
        IF (cycle =  6) THEN check_register(       9, 1, "ADDI"  );END IF;
        IF (cycle =  7) THEN check_register(       9, 2, "ADDI"  );END IF;
        IF (cycle = 12) and (test=6)THEN check_register(       9, 1, "Flush (EX->MEM)"   );END IF;
        IF (cycle = 13) and (test=6)THEN check_register(       9, 1, "Flush (ID->EX)"   );END IF;
        IF (cycle = 14) and (test=6)THEN check_register(       9, 1, "Flush (IF->ID)"   );END IF;
        IF (cycle = 15) THEN check_register(       0, 1, "BEQ"   );END IF;
        IF (cycle = 22) and (test=6)THEN check_register(      16, 1, "Flush" );END IF;
        IF (cycle = 25) THEN check_register(       1, 1, "BNE"   );END IF;
        IF (cycle = 32) and (test=6)THEN check_register(       6, 1, "Flush" );END IF;
        IF (cycle = 35) THEN check_register(       2, 1, "BLT"   );END IF;
        IF (cycle = 42) and (test=6)THEN check_register(       9, 1, "Flush" );END IF;
        IF (cycle = 45) THEN check_register(       3, 1, "BGE"   );END IF;
        IF (cycle = 52) and (test=6)THEN check_register(      11, 1, "Flush" );END IF;
        IF (cycle = 55) THEN check_register(       4, 1, "BLTU"  );END IF;
        IF (cycle = 62) and (test=6)THEN check_register(      15, 1, "Flush" );END IF;
        IF (cycle = 65) THEN check_register(       5, 1, "BGEU"  );END IF;

        IF (cycle = 66) THEN check_register(       9, 1, "ADDI"  );END IF;
        IF (cycle = 67) THEN check_register(       8, 2, "ADDI"  );END IF;
        IF (cycle = 72) THEN check_register(     666, 1, "BEQ"   );END IF;
        IF (cycle = 73) THEN check_register(       0, 1, "BEQ"   );END IF;
        IF (cycle = 80) THEN check_register(     669, 1, "BNE"   );END IF;
        IF (cycle = 81) THEN check_register(       1, 1, "BNE"   );END IF;
        IF (cycle = 82) THEN check_register(       6, 1, "BNE"   );END IF;
        IF (cycle = 88) THEN check_register(     699, 1, "BLT"   );END IF;
        IF (cycle = 89) THEN check_register(       2, 1, "BLT"   );END IF;
        IF (cycle = 90) THEN check_register(       9, 1, "BLT"   );END IF;
        IF (cycle = 96) THEN check_register(     999, 1, "BGE"   );END IF;
        IF (cycle = 97) THEN check_register(       3, 1, "BGE"   );END IF;
        IF (cycle = 98) THEN check_register(      11, 1, "BGE"   );END IF;
        IF (cycle =104) THEN check_register(     996, 1, "BLTU"  );END IF;
        IF (cycle =105) THEN check_register(       4, 1, "BLTU"  );END IF;
        IF (cycle =106) THEN check_register(      15, 1, "BLTU"  );END IF;
        IF (cycle =112) THEN check_register(     966, 1, "BGEU"  );END IF;
        IF (cycle =113) THEN check_register(       5, 1, "BGEU"  );END IF;
        IF (cycle =48+49+35+1+4) and (test=6)THEN check_register(      5, 1, "Flush" );END IF;
        IF (cycle =48+49+35+1+5) and (test=6)THEN check_register(      5, 1, "Flush" );END IF;
        IF (cycle =48+49+35+1+6) and (test=6)THEN check_register(      5, 1, "Flush" );END IF;
    END IF;
       IF test = 7 THEN
      -- Prüflogik für JALR 
      IF (cycle = 24) THEN check_register(       80,15, "JAL"  );END IF;
      IF (cycle = 24) THEN check_register(        8, 1, "FLUSH"  );END IF;
      IF (cycle = 25) THEN check_register(        8, 1, "FLUSH"  );END IF;
      IF (cycle = 26) THEN check_register(        8, 1, "FLUSH"  );END IF;
      IF (cycle = 28) THEN check_register(      220,15, "JALR" );END IF;
      IF (cycle = 29) THEN check_register(        8, 1, "FLUSH"  );END IF;
      IF (cycle = 30) THEN check_register(        8, 1, "FLUSH"  );END IF;
      IF (cycle = 31) THEN check_register(        8, 1, "FLUSH"  );END IF;
      IF (cycle = 33) THEN check_register(        8,10, "OR"   );END IF;
      IF (cycle = 34) THEN check_register(       16, 8, "ADD"  );END IF;
      IF (cycle = 35) THEN check_register(        0,11, "SUB"  );END IF;
      IF (cycle = 36) THEN check_register(        0,12, "SUB"  );END IF;
      IF (cycle = 37) THEN check_register(       24,12, "ADD"  );END IF;
      IF (cycle = 38) THEN check_register(        0,12, "SUB"  );END IF;
      IF (cycle = 39) THEN check_register(        8, 1, "AND"  );END IF;
    END IF;
  END PROCESS;

END ARCHITECTURE;