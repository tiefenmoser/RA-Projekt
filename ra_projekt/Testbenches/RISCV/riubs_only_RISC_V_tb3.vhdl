-- Laboratory RA solutions/versuch9
-- Sommersemester 25
-- Group Details
-- Lab Date:
-- 1. Participant First and Last Name: 
-- 2. Participant First and Last Name:

-- ========================================================================
-- Author:       Marcel Rieß
-- Last updated: 10.06.2025
-- Description:  RIUBS-Only-RISC-V (incomplete RV32I implementation)
--               Supports only R-, I-, U-, B- and S-Instructions.
-- ========================================================================

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.constant_package.ALL;
USE work.types.ALL;
USE work.util_asm_package.ALL;

ENTITY riubs_only_RISC_V_tb3 IS
END ENTITY;

ARCHITECTURE structure OF riubs_only_RISC_V_tb3 IS

  CONSTANT PERIOD     : TIME := 10 ns;
  SIGNAL s_clk,s_clk2 : STD_LOGIC := '1';
  SIGNAL s_rst        : STD_LOGIC;
  SIGNAL cycle        : INTEGER := 0;
  SIGNAL test         : INTEGER := 0;

  SIGNAL s_registersOut     : registerMemory := (OTHERS => (OTHERS => '0'));
  SIGNAL s_instructions     : memory := (OTHERS => (OTHERS => '0'));
  SIGNAL s_debugdatamemory     : memory := (OTHERS => (OTHERS => '0'));

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
  mem := (OTHERS => (OTHERS => '0'));
    mem(1)  := Asm2Std("ADDI", 1, 0, 9);
    mem(2)  := Asm2Std("ADDI", 2, 0, 8);
    mem(3)  := Asm2Std("OR", 10, 1, 2);
    mem(4)  := Asm2Std("ADD", 8, 1, 2);
    mem(5)  := Asm2Std("SUB", 11, 1, 2);
    mem(6)  := Asm2Std("SUB", 12, 2, 1);
    mem(7) := Asm2Std("ADD", 12, 2, 8);
    mem(8) := Asm2Std("SUB", 12, 2, 1);
    mem(9) := Asm2Std("AND", 1, 2, 1);
    mem(10) := Asm2Std("XOR", 12, 1, 2);
    mem(11) := Asm2Std("LUI", 13, 8, 0);
    mem(12) := Asm2Std("LUI", 13, 29, 0);
    if v_test >= 2 then
      mem(13) := Asm2Std("AUIPC", 14, 1, 0);
      mem(14) := Asm2Std("AUIPC", 14, 1, 0);
    end if;
    
    if v_test = 3 then
      mem(15) := Asm2Std("JAL", 15, -28, 0);
    end if;
    

    if v_test = 4 then
      mem(15) := Asm2Std("JAL", 15, 78, 0);
      mem(54) := Asm2Std("JALR", 15, 15, -56);
    end if;

    if v_test >= 5 and v_test <= 6 then
      mem := (OTHERS => (OTHERS => '0'));
      mem( 1) := Asm2Std("ADDI", 1, 0, 9);
      mem( 2) := Asm2Std("ADDI", 2, 0, 9);
      mem( 3) := Asm2Std("BEQ", 1, 2, 4);
      mem( 4) := Asm2Std("ADDI", 1, 0, 666);
      mem( 5) := Asm2Std("ADDI", 1, 0, 0);

      mem( 6) := Asm2Std("ADDI", 1, 0, 16);
      mem(7) := Asm2Std("ADDI", 2, 0, 8);
      mem(8) := Asm2Std("BNE", 2, 1, 4);
      mem(9) := Asm2Std("ADDI", 1, 0, 999);
      mem(10) := Asm2Std("ADDI", 1, 0, 1);

      --rs1<rs2
      mem(11) := Asm2Std("ADDI", 1, 0, 6);
      mem(12) := Asm2Std("ADDI", 2, 0, 8);
      mem(13) := Asm2Std("BLT", 1, 2, 4);
      mem(14) := Asm2Std("ADDI", 1, 0, 666);
      mem(15) := Asm2Std("ADDI", 1, 0, 2);

      --rs1>rs2
      mem(16) := Asm2Std("ADDI", 1, 0, 9);
      mem(17) := Asm2Std("ADDI", 2, 0, 7);
      mem(18) := Asm2Std("BGE", 1, 2, 4);
      mem(19) := Asm2Std("ADDI", 1, 0, 999);
      mem(20) := Asm2Std("ADDI", 1, 0, 3);

      mem(21) := Asm2Std("ADDI", 1, 0, 11);
      mem(22) := Asm2Std("ADDI", 2, 0, 13);
      mem(23) := Asm2Std("BLTU", 1, 2, 4);
      mem(24) := Asm2Std("ADDI", 1, 0, 666);
      mem(25) := Asm2Std("ADDI", 1, 0, 4);

      mem(26) := Asm2Std("ADDI", 1, 0, 15);
      mem(27) := Asm2Std("ADDI", 2, 0, 14);
      mem(28) := Asm2Std("BGEU", 1, 2, 4);
      mem(29) := Asm2Std("ADDI", 1, 0, 999);
      mem(30) := Asm2Std("ADDI", 1, 0, 5);


      mem(31) := Asm2Std("ADDI", 1, 0, 9);
      mem(32) := Asm2Std("ADDI", 2, 0, 8);
      mem(33) := Asm2Std("BEQ", 2, 1, 4);
      mem(34) := Asm2Std("ADDI", 1, 0, 666);
      mem(35) := Asm2Std("ADDI", 1, 0, 0);

      mem(36) := Asm2Std("ADDI", 1, 0, 8);
      mem(37) := Asm2Std("ADDI", 2, 0, 8);
      mem(38) := Asm2Std("BNE", 1, 2, 4);
      mem(39) := Asm2Std("ADDI", 1, 0, 669);
      mem(40) := Asm2Std("ADDI", 1, 0, 1);

      --rs1<rs2
      mem(41) := Asm2Std("ADDI", 1, 0, 6);
      mem(42) := Asm2Std("ADDI", 2, 0, 8);
      mem(43) := Asm2Std("BLT", 2, 1, 4);
      mem(44) := Asm2Std("ADDI", 1, 0, 699);
      mem(45) := Asm2Std("ADDI", 1, 0, 2);

      --rs1>rs2
      mem(46) := Asm2Std("ADDI", 1, 0, 9);
      mem(47) := Asm2Std("ADDI", 2, 0, 7);
      mem(48) := Asm2Std("BGE", 2, 1, 4);
      mem(49) := Asm2Std("ADDI", 1, 0, 999);
      mem(50) := Asm2Std("ADDI", 1, 0, 3);

      mem(51) := Asm2Std("ADDI", 1, 0, 11);
      mem(52) := Asm2Std("ADDI", 2, 0, 13);
      mem(53) := Asm2Std("BLTU", 2, 1, 4);
      mem(54) := Asm2Std("ADDI", 1, 0, 996);
      mem(55) := Asm2Std("ADDI", 1, 0, 4);

      mem(56) := Asm2Std("ADDI", 1, 0, 15);
      mem(57) := Asm2Std("ADDI", 2, 0, 14);
      mem(58) := Asm2Std("BGEU", 2, 1, 4);
      mem(59) := Asm2Std("ADDI", 1, 0, 966);
      mem(60) := Asm2Std("ADDI", 1, 0, 5);
      mem(61) := Asm2Std("JAL", 15, 8, 0);
      mem(62) := Asm2Std("ADDI", 1, 0, 15);
      mem(63) := Asm2Std("ADDI", 1, 0, 14);
      mem(64) := Asm2Std("ADDI", 1, 0, 13);
      mem(65) := Asm2Std("JALR", 15, 15, -10);
      mem(66) := Asm2Std("ADDI", 1, 0, 12);
      mem(67) := Asm2Std("ADDI", 1, 0, 11);
      mem(68) := Asm2Std("ADDI", 1, 0, 10);
    end if;
        if v_test = 7 then
      mem(16) := Asm2Std("JAL", 15, 70, 0);
      mem(17) := Asm2Std("ADDI", 1, 0, 99);
      mem(18) := Asm2Std("ADDI", 1, 0, 98);
      mem(19) := Asm2Std("ADDI", 1, 0, 97);
      mem(54) := Asm2Std("JALR", 15, 15, -56);
      mem(55) := Asm2Std("ADDI", 1, 0, 96);
      mem(56) := Asm2Std("ADDI", 1, 0, 95);
      mem(57) := Asm2Std("ADDI", 1, 0, 94);
    end if;
    if v_test = 8 then
      -- Ausgangswert setzen
      mem(1) := Asm2Std("ADDI", 1, 0, 42);  -- x1 = 42

      -- Shift-Tests
      mem(2) := Asm2Std("SLLI", 5, 1, 1);   -- x5 = x1 << 1 = 84
      mem(3) := Asm2Std("SLLI", 6, 1, 4);   -- x6 = x1 << 4 = 672
      mem(4) := Asm2Std("SRLI", 7, 1, 1);   -- x7 = x1 >> 1 = 21 (logisch)
      mem(5) := Asm2Std("SRLI", 8, 1, 4);   -- x8 = x1 >> 4 = 2
      mem(6) := Asm2Std("SRAI", 9, 1, 1);   -- x9 = x1 >> 1 = 21 (arith.)
      mem(7) := Asm2Std("SRAI", 10, 1, 4);  -- x10 = x1 >> 4 = 2

      -- Optional: negative Werte testen
      mem(8) := Asm2Std("ADDI", 1, 0, -8);   -- x1 = -8
      mem(9) := Asm2Std("SRAI", 11, 1, 1);   -- x11 = -4 (arithmetischer Shift)
    end if;

if v_test = 9 then
  -- Initialwerte vorbereiten
  mem := (OTHERS => (OTHERS => '0'));
  mem(1)  := Asm2Std("ADDI", 1, 0, 100);  -- x1 = Adresse 100 (Basisadresse)
  mem(2)  := Asm2Std("ADDI", 2, 0, 42);   -- x2 = Datenwert 42
  mem(3)  := Asm2Std("ADDI", 3, 0, -1);   -- x3 = Datenwert -1 (0xFFFFFFFF)

  -- STORE WORD
  mem(4)  := Asm2Std("SW", 1, 2, 0);      -- Mem[100] = x2 (42)

  -- LOAD WORD
  mem(5)  := Asm2Std("LW", 4, 1, 0);      -- x4 = Mem[100], sollte 42 sein
  mem(6)  := Asm2Std("ADDI", 10, 4, 1);   -- Load-Use! x10 = x4 + 1 → sollte 43

  -- STORE BYTE
  mem(7)  := Asm2Std("SB", 1, 3, 4);      -- Mem[104] = x3 (nur LSB: 0xFF)

  -- LOAD BYTE (signed)
  mem(8)  := Asm2Std("LB", 5, 1, 4);      -- x5 = Mem[104], sollte -1
  mem(9)  := Asm2Std("ADD", 11, 5, 2);    -- Load-Use! x11 = x5 + x2 → -1 + 42

  -- LOAD BYTE (unsigned)
  mem(10) := Asm2Std("LBU", 6, 1, 4);     -- x6 = Mem[104], sollte 255
  mem(11) := Asm2Std("SUB", 12, 6, 2);    -- Load-Use! x12 = x6 - x2 → 213

  -- STORE HALFWORD
  mem(12) := Asm2Std("SH", 1, 3, 8);      -- Mem[108..109] = x3 (nur LSB 16 Bit)

  -- LOAD HALFWORD (signed)
  mem(13) := Asm2Std("LH", 7, 1, 8);      -- x7 = Mem[108..109], sollte -1
  mem(14) := Asm2Std("XOR", 13, 7, 2);    -- Load-Use! x13 = x7 xor x2

  -- LOAD HALFWORD (unsigned)
  mem(15) := Asm2Std("LHU", 8, 1, 8);     -- x8 = Mem[108..109], sollte 65535
  mem(16) := Asm2Std("AND", 14, 8, 2);    -- Load-Use! x14 = x8 and x2
end if;


  END PROCEDURE;

BEGIN

  -- DUT
  riubs_bp_lu_only_RISC_V : ENTITY work.riubs_bp_lu_only_RISC_V
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
test_runner : process
  variable v_instr : memory := (others => (others => '0'));
  variable error_count : integer := 0;
  
  procedure run_test(test_nr : integer; ticks : integer; name : string) is
  begin
    report "== TEST " & integer'image(test_nr) & ": " & name & " ==";
    test <= test_nr;
    s_rst <= '1';
    wait until falling_edge(s_clk);
    s_rst <= '0';
    load_common_instructions(v_instr, test_nr);
    s_instructions <= v_instr;

    for i in 1 to ticks loop
      wait until falling_edge(s_clk);
      cycle <= i;
    end loop;

    wait until falling_edge(s_clk);
    report "==   PASSED   ==";
  end procedure;

begin
  run_test(1, 20,  "LUI");
  run_test(2, 29,  "AUIPC");
  run_test(3, 100, "JAL");
  run_test(4, 100, "JALR");
  run_test(5, 150, "BRANCHES without FLUSH");
  run_test(6, 150, "BRANCHES with FLUSH");
  run_test(7, 150, "JUMPS with FLUSH");
  run_test(8, 35,  "Immediate Shifts");
  run_test(9, 40,  "LOAD/STORE");

  report "== ALLE TESTS INKL. FLUSH & BYPASSING & FORWARDING & Load-Use-Stall ABGESCHLOSSEN ==";

  wait;
end process;

  -- Prüfroutine (separat lassen für Klarheit)
  PROCESS (cycle)
  BEGIN
    IF test >= 1 and test<=4 and s_rst='0' THEN
      -- Prüflogik für LUI0
      -- REPORT "Register " & INTEGER'image(2) &
      --        " enthaelt " & INTEGER'image(to_integer(signed(s_registersOut(2)))) ;
     
      case cycle is
        WHEN  6 => check_register(       9,  1, "ADDI" );
        WHEN  7 => check_register(       8,  2, "ADDI" );
        WHEN 8 => check_register(       9, 10, "OR"   );
        WHEN 9 => check_register(      17,  8, "ADD"  );
        WHEN 10 => check_register(       1, 11, "SUB"  );
        WHEN 11 => check_register(      -1, 12, "SUB"  );
        WHEN 12 => check_register(      25, 12, "ADD"  );
        WHEN 13 => check_register(      -1, 12, "SUB"  );
        WHEN 14 => check_register(       8,  1, "AND"  );
        WHEN 15 => check_register(       0, 12, "XOR"  );
        WHEN 16 => check_register( 8*2**12, 13, "LUI"  );
        WHEN 17 => check_register(29*2**12, 13, "LUI"  );
        WHEN others => null;
      END CASE;
      end if;
    IF test >= 2 and test<=4  and s_rst='0' THEN
      -- Prüflogik für AUIPC
      --REPORT "Register " & INTEGER'image(14) &
      --       " enthaelt " & INTEGER'image(to_integer(signed(s_registersOut(14)))) ;
      case cycle is
        WHEN 18 => check_register(    4148, 14, "AUIPC");
        WHEN 19 => check_register(    4152, 14, "AUIPC");
        WHEN others => null;
      END CASE;
    END IF;
    IF test = 3  and s_rst='0' THEN
      -- Prüflogik für JAL
      -- REPORT "Register " & INTEGER'image(15) &
      --      " enthaelt " & INTEGER'image(to_integer(signed(s_registersOut(15)))) & " cycle: " & INTEGER'image(cycle);
      case cycle is
        when 20 => check_register(       64,15, "JAL"  );
        when 24 => check_register(        9, 1, "ADDI" );
        when 25 => check_register(        8, 2, "ADDI" );
        when 26 => check_register(        9,10, "OR"   );
        when 27 => check_register(       17, 8, "ADD"  );
        when 28 => check_register(        1,11, "SUB"  );
        when 29 => check_register(       -1,12, "SUB"  );
        when 30 => check_register(       25,12, "ADD"  );
        when 31 => check_register(       -1,12, "SUB"  );
        when 32 => check_register(         8,2, "AND"  );
        when 33 => check_register(        0,12, "XOR"  );
        when 34 => check_register( 8*2**12, 13, "LUI"  );
        when 35 => check_register(29*2**12, 13, "LUI"  );
        when 36 => check_register(     4148,14, "AUIPC");
        when 37 => check_register(     4152,14, "AUIPC");
        when others => null;
      END CASE;
    END IF;
    IF test = 4 THEN
      -- Prüflogik für JALR
      -- REPORT "Register " & INTEGER'image(15) &
      --      " enthaelt " & INTEGER'image(to_integer(signed(s_registersOut(15)))) & " cycle: " & INTEGER'image(cycle);
      case cycle is
        WHEN 20 => check_register(       64,15, "JAL"  );
        WHEN 24 => check_register(      220,15, "JALR" );
        WHEN 29 => check_register(        8,10, "OR"   );
        WHEN 30 => check_register(       16, 8, "ADD"  );
        WHEN 31 => check_register(        0,11, "SUB"  );
        WHEN 32 => check_register(        0,12, "SUB"  );
        WHEN 33 => check_register(       24,12, "ADD"  );
        WHEN 34 => check_register(        0,12, "SUB"  );
        WHEN 35 => check_register(        8, 1, "AND"  );
        WHEN others => null;
      END CASE;
    END IF;
    IF test >= 5 and test <= 6  and s_rst='0' THEN
      -- Prüflogik für BRANCHES
        --            REPORT "Register " & INTEGER'image(2) &
        --    " enthaelt " & INTEGER'image(to_integer(signed(s_registersOut(2)))) & " cycle: " & INTEGER'image(cycle);
            
        case cycle is
          WHEN 6 => check_register(       9, 1, "ADDI"  );
          WHEN 7 => check_register(       9, 2, "ADDI"  );
          WHEN 8 =>  if (test=6) then check_register(       9, 1, "Flush (EX->MEM)"   );end if;
          WHEN 9 =>  if (test=6) then check_register(       9, 1, "Flush (ID->EX)"   );end if;
          WHEN 10 =>  if (test=6) then check_register(       9, 1, "Flush (IF->ID)"   );end if;
          WHEN 12 => check_register(       0, 1, "BEQ"   );
          WHEN 13 =>  if (test=6) then check_register(      16, 1, "Flush" );end if;
          WHEN 19 => check_register(       1, 1, "BNE"   );
          WHEN 20 =>  if (test=6) then check_register(       6, 1, "Flush" );end if;
          WHEN 26 => check_register(       2, 1, "BLT"   );
          WHEN 27 =>  if (test=6) then check_register(       9, 1, "Flush" );end if;
          WHEN 33 => check_register(       3, 1, "BGE"   );
          WHEN 34 =>  if (test=6) then check_register(      11, 1, "Flush" );end if;
          WHEN 40 => check_register(       4, 1, "BLTU"  );
          WHEN 41 =>  if (test=6) then check_register(      15, 1, "Flush" );end if;
          WHEN 47 => check_register(       5, 1, "BGEU"  );

          WHEN 48 => check_register(       9, 1, "ADDI"  );
          WHEN 49 => check_register(       8, 2, "ADDI"  );
          WHEN 51 => check_register(     666, 1, "BEQ"   );
          WHEN 52 => check_register(       0, 1, "BEQ"   );
          WHEN 56 => check_register(     669, 1, "BNE"   );
          WHEN 57 => check_register(       1, 1, "BNE"   );
          WHEN 58 => check_register(       6, 1, "BNE"   );
          WHEN 61 => check_register(     699, 1, "BLT"   );
          WHEN 62 => check_register(       2, 1, "BLT"   );
          WHEN 63 => check_register(       9, 1, "BLT"   );
          WHEN 66 => check_register(     999, 1, "BGE"   );
          WHEN 67 => check_register(       3, 1, "BGE"   );
          WHEN 68 => check_register(      11, 1, "BGE"   );
          WHEN 71 => check_register(     996, 1, "BLTU"  );
          WHEN 72 => check_register(       4, 1, "BLTU"  );
          WHEN 73 => check_register(      15, 1, "BLTU"  );
          WHEN 76 => check_register(     966, 1, "BGEU"  );
          WHEN 77 => check_register(       5, 1, "BGEU"  );
          WHEN 86 => check_register(     966, 1, "BGEU, JAL, JALR"  );
          WHEN 105 => check_register(     966, 1, "BGEU, JAL, JALR"  );
          WHEN 124 => check_register(     966, 1, "BGEU, JAL, JALR"  );
          WHEN 134 =>  if (test=6) then  check_register(      5, 1, "Flush" );end if;
          WHEN 135 =>  if (test=6) then  check_register(      5, 1, "Flush" );end if;
          WHEN 136 =>  if (test=6) then  check_register(      5, 1, "Flush" );end if;
          WHEN others => null;
      END CASE;
    END IF;
       IF test = 7 THEN
      -- Prüflogik für JALR 
      --  REPORT "Register " & INTEGER'image(15) &
      --   " enthaelt " & INTEGER'image(to_integer(signed(s_registersOut(15))));
        
       case cycle is
        WHEN 21 => check_register(       68,15, "JAL"  );
        WHEN 22 => check_register(        8, 1, "FLUSH"  );
        WHEN 24 => check_register(        8, 1, "FLUSH"  );
        WHEN 25 => check_register(        8, 1, "FLUSH"  );
        WHEN 28 => check_register(      220,15, "JALR" );
        WHEN 29 => check_register(        8, 1, "FLUSH"  );
        WHEN 30 => check_register(        8, 1, "FLUSH"  );
        WHEN 31 => check_register(        8, 1, "FLUSH"  );
        WHEN 32 => check_register(        8,10, "OR"   );
        WHEN 33 => check_register(       16, 8, "ADD"  );
        WHEN 34 => check_register(        0,11, "SUB"  );
        WHEN 35 => check_register(        0,12, "SUB"  );
        WHEN 36 => check_register(       24,12, "ADD"  );
        WHEN 37 => check_register(        0,12, "SUB"  );
        WHEN 38 => check_register(        8, 1, "AND"  );
        WHEN others => null;
      END CASE;
    END IF;

    if test = 8 then
    -- Prüflogik für shift
    -- REPORT "Register " & INTEGER'image(5) &
    -- " enthaelt " & INTEGER'image(to_integer(signed(s_registersOut(5))));
        
      case cycle is
        when  6 => check_register( 42,  1, "ADDI");
        when  7 => check_register( 84,  5, "SLLI");
        when  8 => check_register(672,  6, "SLLI");
        when  9 => check_register( 21,  7, "SRLI");
        when 10 => check_register(  2,  8, "SRLI");
        when 11 => check_register( 21,  9, "SRAI");
        when 12 => check_register(  2, 10, "SRAI");
        when 13 => check_register( -8,  1, "ADDI");
        when 14 => check_register( -4, 11, "SRAI");
        when others => null;
      end case;
    end if;

    IF test = 9 THEN
      --      REPORT "Register " & INTEGER'image(5) &
      --  " enthaelt " & INTEGER'image(to_integer(signed(s_registersOut(5))));
        
case cycle is
  -- Initialwerte
  when 6  => check_register(100, 1, "ADDI (BaseAddr)");
  when 7  => check_register(42,  2, "ADDI (Value42)");
  when 8  => check_register(-1,  3, "ADDI (Value-1)");

  -- LOAD WORD
  when 10 => check_register(42,  4, "LW (Load 42)");

  -- LOAD-USE: x10 = x4 + 1 => 42 + 1 = 43
  when 12 => check_register(43, 10, "Load-Use x10 = x4 + 1");

  -- LOAD BYTE (signed)
  when 14 => check_register(-1, 5, "LB (Load -1 signed)");

  -- LOAD-USE: x11 = x5 + x2 => -1 + 42 = 41
  when 16 => check_register(41, 11, "Load-Use x11 = x5 + x2");

  -- LOAD BYTE (unsigned)
  when 17 => check_register(255, 6, "LBU (Load 255 unsigned)");

  -- LOAD-USE: x12 = x6 - x2 => 255 - 42 = 213
  when 19 => check_register(213, 12, "Load-Use x12 = x6 - x2");

  -- LOAD HALFWORD (signed)
  when 21 => check_register(-1, 7, "LH (Load -1 signed)");

  -- LOAD-USE: x13 = x7 xor x2 => -1 xor 42 = -43 (0xFFFFFFD5)
  when 23 => check_register(-43, 13, "Load-Use x13 = x7 xor x2");

  -- LOAD HALFWORD (unsigned)
  when 24=> check_register(65535, 8, "LHU (Load 65535 unsigned)");

  -- LOAD-USE: x14 = x8 and x2 => 65535 and 42 = 42
  when 26 => check_register(42, 14, "Load-Use x14 = x8 and x2");

  when others => null;
end case;

    END IF;

  END PROCESS;

END ARCHITECTURE;