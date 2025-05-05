-- Laboratory RA solutions/versuch2
-- Sommersemester 25
-- Group Details
-- Lab Date:
-- 1. Participant First and Last Name: Cornelius Tiefenmoser 
-- 2. Participant First and Last Name: Maxi Gromut

-- ========================================================================
-- Author:       Marcel Rieß
-- Last updated: 11.04.2025
-- Description:  Holds various custom types related to the implementation
--               that are used throughout the implementation
-- ========================================================================

library IEEE;
  use ieee.std_logic_1164.all;
  use work.constant_package.all;

package types_package is

  -- enum containig all instruction formats, used in decoder
  
  type memory is array (0 to 2 ** 10 - 1) of std_logic_vector(WORD_WIDTH - 1 downto 0); -- Used for instruction cache

  type registermemory is array (0 to 2 ** REG_ADR_WIDTH - 1) of std_logic_vector(WORD_WIDTH - 1 downto 0); -- used in register file

end package types_package;
