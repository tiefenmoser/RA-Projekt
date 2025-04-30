-- Testbench for OR gate
library IEEE;
use IEEE.std_logic_1164.all;

entity testbench is
-- empty
end testbench; 

architecture tb of testbench is

-- DUT component
component or_function is
port(
a: in std_logic;
b: in std_logic;
q: out std_logic);
end component;
FOR DUT1: or_function USE ENTITY WORK.or_function(behavior);
FOR DUT2: or_function USE ENTITY WORK.or_function(structure);
FOR DUT3: or_function USE ENTITY WORK.or_function(datatransmission);
signal a_in, b_in, q_out1,q_out2,q_out3: std_logic;

begin

-- Connect DUT
DUT1: or_function port map(a_in, b_in, q_out1);
DUT2: or_function port map(a_in, b_in, q_out2);
DUT3: or_function port map(a_in, b_in, q_out3);
process
begin
a_in <= '0';
b_in <= '0';
wait for 1 ns;
assert(q_out1='0') report "Error behavior 0/0" severity error;
assert(q_out2='0') report "Error structure 0/0" severity error;
assert(q_out3='0') report "Error data transmission 0/0" severity error;

a_in <= '0';
b_in <= '1';
wait for 1 ns;
assert(q_out1='1') report "Error behavior 0/1" severity error;
assert(q_out2='1') report "Error structure 0/1" severity error;
assert(q_out3='1') report "Error data transmission 0/1" severity error;

a_in <= '1';
b_in <= 'X';
wait for 1 ns;
assert(q_out1='1') report "Error behavior 1/X" severity error;
assert(q_out2='1') report "Error structure 1/X" severity error;
assert(q_out3='1') report "Error data transmission 1/X" severity error;

a_in <= 'X';
b_in <= '1';
wait for 1 ns;
assert(q_out1='1') report "Error behavior X/1" severity error;
assert(q_out2='1') report "Error structure X/1" severity error;
assert(q_out3='1') report "Error data transmission X/1" severity error;

a_in <= '1';
b_in <= '1';
wait for 1 ns;
assert(q_out1='1') report "Error behavior 1/1" severity error;
assert(q_out2='1') report "Error structure 1/1" severity error;
assert(q_out3='1') report "Error data transmission 1/1" severity error;

-- Clear inputs
a_in <= '0';
b_in <= '0';

assert false report "Test done." severity note;
wait;
end process;
end tb;
