-- Laboratory RA solutions/versuch3
-- Sommersemester 25
-- Group Details
-- Lab Date:
-- 1. Participant First and Last Name: Cornelius Tiefenmoser
-- 2. Participant First and Last Name: Maxi Gromut
-- 3. Participant First and Last Name: Rupert Honold

-- ========================================================================
-- Description:  Sign extender for a RV32I processor. Takes the entire instruction
--               and produces a 32-Bit value by sign-extending, shifting and piecing
--               together the immedate value in the instruction.
-- ========================================================================


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.constant_package.all;

entity signExtension is
    generic(
        G_word_width : integer := WORD_WIDTH
    );
    port(
        pi_instr : in std_logic_vector(G_word_width-1 downto 0);

        -- i hate it here
        po_storeImm : out std_logic_vector(G_word_width-1 downto 0);
        po_immediateImm : out std_logic_vector(G_word_width-1 downto 0);
        po_unsignedImm  : out std_logic_vector(G_word_width-1 downto 0);
        po_branchImm : out std_logic_vector(G_word_width-1 downto 0);
        po_jumpImm : out std_logic_vector(G_word_width-1 downto 0)
    );
end entity;

architecture behavior of signExtension is
    begin
        
        -- no idea if the order of the bits is gonna be right
        po_storeImm <= std_logic_vector(resize(signed(pi_instr(31 downto 25) & pi_instr(11 downto 7)),32));      
        
        po_immediateImm <= std_logic_vector(resize(signed(pi_instr(31 downto 20)),32));
        -- x"000" is 12 zeros in hex
        po_unsignedImm <= std_logic_vector(resize(signed(pi_instr(31 downto 12) & x"000"),32));

        po_branchImm <= std_logic_vector(resize(signed(pi_instr(31) & pi_instr(7) & pi_instr(30 downto 25) & pi_instr(11 downto 8) & '0'),32));
        -- why is this encoded like this???
        po_jumpImm <= std_logic_vector(resize(signed(pi_instr(31) & pi_instr(19 downto 12) & pi_instr(20) & pi_instr(30 downto 21) & '0'),32)); 
end architecture;