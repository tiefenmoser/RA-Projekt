-- Liebevolle Spende von Leonard Habrom

-- lass das mal der Vollständigkeitshalber drin:
-- Laboratory GdTi solutions/versuch8
-- Winter Semester 23/24
-- Group Details
-- Lab Date: 01.22.2024
-- 1. Participant First and Last Name: Leonard Habrom
-- 2. Participant First and Last Name: Konrad Fuchs
 

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;
use work.CONSTANT_Package.ALL;

entity shifter is
    generic(
        G_DATA_WIDTH : integer := DATA_WIDTH_GEN
    );
    port(
        -- begin solution:
        P_OP1, P_OP2 : in STD_LOGIC_VECTOR(G_DATA_WIDTH-1 downto 0) := (others => '0');
        P_SHIFT_TYPE, P_SHIFT_DIR : in std_logic := '0';
        P_RES : out STD_LOGIC_VECTOR(G_DATA_WIDTH-1 downto 0) := (others => '0')
        -- end solution!!
    );
end entity;

architecture behavior of shifter is
    signal s_shamtInt : integer range 0 to (2**(integer(log2(real(G_DATA_WIDTH)))));
    signal s_fill : std_logic_vector(G_DATA_WIDTH -1 downto 0) := (others => '0');
    signal s_sign_bit : std_logic := '0';
   begin
       s_shamtInt <= to_integer( unsigned(P_OP2(integer(log2(real(G_DATA_WIDTH))) - 1 downto 0)));
       -- begin solution:
       process (P_OP1, P_OP2, P_SHIFT_TYPE, P_SHIFT_DIR, s_fill, s_sign_bit, s_shamtInt)
       begin
           case P_SHIFT_TYPE is
               when '0' => 
                s_fill <= (others => '0');
                case P_SHIFT_DIR is
                    when '0' => 
                    if (s_shamtInt <= 0) then
                        P_RES <= P_OP1;
                    elsif (s_shamtInt < G_DATA_WIDTH) then
                        P_RES <= P_OP1((G_DATA_WIDTH - 1) - s_shamtInt downto 0) & s_fill(s_shamtInt -1 downto 0);
                    end if;
                        when '1' => 
                    if (s_shamtInt <= 0) then
                        P_RES <= P_OP1;
                    elsif (s_shamtInt < G_DATA_WIDTH) then
                        P_RES <= s_fill(s_shamtInt -1 downto 0) & P_OP1((G_DATA_WIDTH - 1) downto s_shamtInt);
                    end if;
                        when others => P_RES <= (others => '0');
               end case;
               when '1' => 
                s_sign_bit <= P_OP1(G_DATA_WIDTH - 1);
                s_fill <= (others => s_sign_bit);
                if (s_shamtInt <= 0) then
                    P_RES <= P_OP1;
                elsif (s_shamtInt < G_DATA_WIDTH) then
                    P_RES <= s_fill(s_shamtInt -1 downto 0) & P_OP1((G_DATA_WIDTH -1) downto s_shamtInt);
                end if;
               when others => P_RES <= (others => '0');
            end case;
        end process;
       -- end solution!!
end architecture behavior;
