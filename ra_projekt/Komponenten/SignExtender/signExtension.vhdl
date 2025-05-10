library ieee;
use ieee.std_logic_1164.all;
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
        po_unsingedImm : out std_logic_vector(G_word_width-1 downto 0);
        po_branchImm : out std_logic_vector(G_word_width-1 downto 0);
        po_jumpImm : out std_logic_vector(G_word_width-1 downto 0)
    );
end entity;

architecture behavior of signExtension is
    begin
        
end architecture;