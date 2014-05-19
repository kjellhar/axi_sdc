--    /*  -------------------------------------------------------------------------

--    This program is free software: you can redistribute it and/or modify
--    it under the terms of the GNU General Public License as published by
--    the Free Software Foundation, either version 3 of the License, or
--    any later version.
--
--    This program is distributed in the hope that it will be useful,
--    but WITHOUT ANY WARRANTY; without even the implied warranty of
--    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--    GNU General Public License for more details.
--    
--    You should have received a copy of the GNU General Public License
--    along with this program.  If not, see <http://www.gnu.org/licenses/>.
--    
--    Copyright: Levent Ozturk crc@leventozturk.com
--    https://leventozturk.com/engineering/crc/
--    Polynomial: x7+x3+1
--    d7 is the first data processed

--    c is internal LFSR state and the CRC output. Not needed for other modules than CRC.
--    c width is always same as polynomial width.
-------------------------------------------------------------------------*/

-- The generated module has been modified - Kjell H A

library ieee;
use ieee.std_logic_1164.all;

entity crc_8_10001001 is 
    generic (
        SEED : in std_logic_vector(  6 downto 0) := b"0000000"); 
    port (
        clk : in std_logic;
        clear : in std_logic;
        enable : in std_logic;
        d : in std_logic_vector(  7 downto 0);
        c : out std_logic_vector(  6 downto 0)); 
end crc_8_10001001;

architecture a1 of crc_8_10001001 is
	signal                       ca : std_logic_vector(  6 downto 0) := (others => '0');
	signal                       oa : std_logic_vector(  7 downto 0) := (others => '0');
begin

	process (clk, clear)
	begin
	   if (rising_edge(clk)) then
            if (clear= '1') then
                ca <= SEED;
            else
                if enable='1' then
                    ca(  0) <= ca(  3) xor ca(  6) xor d(  7) xor d(  4) xor d(  0);
                    ca(  1) <= ca(  0) xor ca(  4) xor d(  5) xor d(  1);
                    ca(  2) <= ca(  1) xor ca(  5) xor d(  6) xor d(  2);
                    ca(  3) <= ca(  2) xor ca(  3) xor d(  4) xor d(  3) xor d(  0);
                    ca(  4) <= ca(  0) xor ca(  3) xor ca(  4) xor d(  5) xor d(  4) xor d(  1);
                    ca(  5) <= ca(  1) xor ca(  4) xor ca(  5) xor d(  6) xor d(  5) xor d(  2);
                    ca(  6) <= ca(  2) xor ca(  5) xor ca(  6) xor d(  7) xor d(  6) xor d(  3);
                    
                    oa(  7) <= ca(  6);
                    oa(  6) <= ca(  5);
                    oa(  5) <= ca(  4);
                    oa(  4) <= ca(  3);
                    oa(  3) <= ca(  2) xor ca(  6);
                    oa(  2) <= ca(  1) xor ca(  5);
                    oa(  1) <= ca(  0) xor ca(  4);
                    oa(  0) <= ca(  3) xor ca(  6);
                end if;
            end if;
        end if;
    end process;
	c <= ca;
end a1;