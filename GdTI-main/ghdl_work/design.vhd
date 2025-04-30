-- Simple OR gate design
library IEEE;
use IEEE.std_logic_1164.all;

entity or_function is
	port(
	a: in std_logic;
	b: in std_logic;
	q: out std_logic);
end or_function;

architecture behavior of or_function is
begin
	P1: process (a, b) is
		begin
			if (a = '1') then
				q <= '1';
			elsif(b = '1') then
				q <= '1';
			else
				q <= '0';
		end if;
	end process P1;
end behavior;

architecture structure of or_function is
	component orgate is
		port(a, b: in std_logic; q: out std_logic);
	end component orgate;
begin
	OR1: orgate port map(a, b, q);
end structure;

architecture datatransmission of or_function is
begin
	q <= a or b;
end datatransmission;	
