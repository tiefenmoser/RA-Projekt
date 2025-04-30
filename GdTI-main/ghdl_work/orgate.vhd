
-- Simple OR gate design
library IEEE;
use IEEE.std_logic_1164.all;

entity orgate is
port(
a: in std_logic;
b: in std_logic;
q: out std_logic);
end orgate;

architecture behavior_or of orgate is
begin
process(a, b) is
begin
q <= a or b;
end process;
end behavior_or;
