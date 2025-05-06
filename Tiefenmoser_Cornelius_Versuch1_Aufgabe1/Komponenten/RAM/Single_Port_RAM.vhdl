library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constant_package.all;
use work.types_package.all;

entity single_port_ram is
    generic(
        G_word_width : integer := WORD_WIDTH;
        G_addr_width : integer := 16 -- ADR_WIDTH
    );
    port(
        pi_data : in std_logic_vector (G_word_width-1 downto 0) := (others => '0');
        pi_addr : in std_logic_vector (15 downto 0) := (others => '0');
        pi_we,pi_rst : in std_logic := '0';
        pi_clk : in std_logic;
        po_data : out std_logic_vector(G_word_width-1 downto 0) := (others => '0')
    );
end entity;


architecture behavior of single_port_ram is
    -- should we use our own or the one in type_packages????
    type memory_array is array (0 to (2 ** G_addr_width) - 1 ) of std_logic_vector(G_word_width-1 downto 0);
    signal RAM : memory_array := (others => (others => '0'));

begin
    ram_process: process (pi_rst,pi_clk)
        begin
            if pi_rst = '1' then 
                RAM <= (others => (others => '0')); 
                po_data <= RAM(to_integer(unsigned(pi_addr))); -- TODO: this might have the update problem too might need the fix to but idk removes the ability to test ngl
            elsif rising_edge(pi_clk) then 
                po_data <= RAM(to_integer(unsigned(pi_addr)));
                if pi_we = '1' then   --for some reason this doesnt work after like adress 32
                    RAM(to_integer(unsigned(pi_addr))) <= pi_data;
                    po_data <= pi_data; 
                    -- if we set the po_data to the ram of pi_addr on a write enable case we get old data since it cant update faste enough
                    -- idk how to fix this better than this
                end if;
            end if;
        end process;
end architecture;