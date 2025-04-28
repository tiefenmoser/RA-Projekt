-- Laboratory RA solutions/versuch1
-- Sommersemester 25
-- Group Details
-- Lab Date:
-- 1. Participant First and Last Name: 
-- 2. Participant First and Last Name:

-------------------------------------------------------------------------------
-- Beschreibung:    Coding Conventions für das Labor-Projekt
-- Author:          Marcel Rieß
-- Version:         1.1
-- Letzte Änderung: 31.03.2025
-- Zweck:           Definiert die Programmierstandards für VHDL-Module des Labors
-------------------------------------------------------------------------------

package CodingConventions is

    ----------------------------------------------------------------------------
    -- Namenskonventionen
    ----------------------------------------------------------------------------
    -- 1. Port-Namen:
    --    - Eingänge: Präfix "pi_"
    --    - Ausgänge: Präfix "po_"
    --    - Beispiel:
    --      entity ExampleModule is
    --          port (
    --              pi_clk    : in std_logic;
    --              pi_reset  : in std_logic;
    --              pi_data   : in std_logic_vector(7 downto 0);
    --              po_result : out std_logic_vector(7 downto 0)
    --          );
    --      end ExampleModule;

    -- 2. Interne Signale:
    --    - Präfix "s_" für interne Signale
    --    - Beispiel: signal s_state : std_logic_vector(2 downto 0);

    -- 3. Variablen:
    --    - Präfix "v_" für Variablen innerhalb von Prozessen
    --    - Beispiel: variable v_counter : integer := 0;

    -- 4. Konstanten:
    --    - Nur Konstanten werden komplett in Großbuchstaben geschrieben.
    --    - Beispiel: constant MAX_VALUE : integer := 255;

    ----------------------------------------------------------------------------
    -- Formatierung & Einrückung
    ----------------------------------------------------------------------------
    -- 1. Einrückung erfolgt mit 4 Leerzeichen, keine Tabs.
    -- 2. Jeder "if", "case", "loop" wird eingerückt.
    -- 3. Kommentare beginnen mit "-- " (zwei Bindestriche und ein Leerzeichen).
    -- 4. Maximal 80 Zeichen pro Zeile für bessere Lesbarkeit.

    ----------------------------------------------------------------------------
    -- Signale & Datentypen
    ----------------------------------------------------------------------------
    -- 1. Standard-Datentypen:
    --    - std_logic für einzelne Signale
    --    - std_logic_vector für Busse
    --    - integer nur für kleine Wertebereiche (ansonsten unsigned/signed)

    -- 2. Arrays werden mit "type" definiert:
    --    type memory_array is array (0 to 15) of std_logic_vector(7 downto 0);
    
    ----------------------------------------------------------------------------
    -- Prozess- und Modulstrukturierung
    ----------------------------------------------------------------------------
    -- 1. Prozesse werden nach Sensitivitätsliste oder "rising_edge(clk)" verwendet.
    -- 2. Jeder Prozess enthält einen Kommentar, der seine Funktion beschreibt.
    -- 3. Getrennte Prozesse für:
    --    - Kombinatorische Logik
    --    - Synchronen Ablauf
    --
    -- Beispiel für einen gut strukturierten Prozess:
    -- process(pi_clk)
    -- begin
    --    if rising_edge(pi_clk) then
    --        if pi_reset = '0' then
    --            s_state <= IDLE;
    --        else
    --            s_state <= next_state;
    --        end if;
    --    end if;
    -- end process;

    ----------------------------------------------------------------------------
    -- Testbenches
    ----------------------------------------------------------------------------
    -- 1. Alle Testbenches sollen folgende Abschnitte enthalten:
    --    - Initialisierung
    --    - Stimuluserzeugung
    --    - Ergebnisse auswerten (z. B. mit "assert")
    --
    -- 2. Beispiel für eine Testbench-Assertion:
    --    assert po_result = expected_value
    --    report "Fehler: Ergebnis entspricht nicht dem Erwartungswert."
    --    severity error;

end package CodingConventions;