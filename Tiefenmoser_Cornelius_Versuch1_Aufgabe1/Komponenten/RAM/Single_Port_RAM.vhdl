library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constant_package.all;

entity single_port_ram is
    generic(
        G_word_width : integer := WORD_WIDTH;
        G_addr_width : integer := ADR_WIDTH
    );
    port(
        pi_data : in std_logic_vector (G_word_width-1 downto 0) := (others => '0');
        pi_addr : in std_logic_vector (G_addr_width-1 downto 0) := (others => '0');
        pi_we,pi_clk,pi_rst : in std_logic := '0';
        
        po_data : out std_logic_vector(G_word_width-1 downto 0) := (others => '0')
    );
end entity;


architecture behavior of single_port_ram is
    type memory_array is array (0 to G_addr_width-1) of std_logic_vector(G_word_width-1 downto 0);
    signal RAM : memory_array := (others => (others => '0'));

begin
    ram_process: process (pi_clk,pi_rst,pi_we)
        begin
            if(pi_rst = '1') then 
                RAM <= (others => (others => '0')); -- set all bits of the memory array to 0
                po_data <= RAM(to_integer(unsigned(pi_addr)));
            elsif rising_edge(pi_clk) then
                if(pi_we = '1') then --why is this delayed by an entire cycle
                    RAM(to_integer(unsigned(pi_addr))) <= pi_data;
                end if;
                po_data <= RAM(to_integer(unsigned(pi_addr)));
            end if;
        end process;
end architecture;