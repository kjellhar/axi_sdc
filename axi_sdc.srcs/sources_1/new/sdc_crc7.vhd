----------------------------------------------------------------------------------
-- Company: Oppfinneriet
-- Engineer: Kjell H Andersen
-- 
-- Create Date: 04/23/2014 04:11:50 AM
-- Design Name: axi_sdc
-- Module Name: sdc_crc7 - rtl
-- Project Name: axi_sdc
-- Target Devices: Artix7
-- Tool Versions: 
-- Description: 
--
--  CRC7 for SD Controller  Command interface.
--    Polynomial :  1+x^3+x^7
--  The module accepts serial data in,and calculates a 7 bit CRC
--  The initial value is 0
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--  
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sdc_crc7 is
    Port ( Clk : in std_logic;
           Enable : in std_logic;
           Clr : in std_logic;
           SData_in : in std_logic;
           Crc7_out : out std_logic_vector (6 downto 0));
end sdc_crc7;

architecture rtl of sdc_crc7 is

  signal lfsr: std_logic_vector (6 downto 0) := (others => '0');	
begin	
    Crc7_out <= lfsr;


    process (Clk) 
    begin 
        if rising_edge(Clk) then
            if Clr = '1' then
                lfsr <= (others => '0');
            else
                if Enable = '1' then
                    lfsr(0) <= lfsr(6) xor SData_in;
                    lfsr(1) <= lfsr(0);
                    lfsr(2) <= lfsr(1);
                    lfsr(3) <= lfsr(2) xor lfsr(6) xor SData_in;
                    lfsr(4) <= lfsr(3);
                    lfsr(5) <= lfsr(4);
                    lfsr(6) <= lfsr(5);                
       	        end if; 
            end if;
        end if; 
    end process; 
end rtl;
