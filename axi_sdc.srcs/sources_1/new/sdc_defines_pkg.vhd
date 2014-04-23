----------------------------------------------------------------------------------
-- Company: Oppfinneriet
-- Engineer: Kjell H Andersen
-- 
-- Create Date: 04/23/2014 06:10:58 AM
-- Design Name: axi_Sdc
-- Module Name: sdc_defines_pkg - Behavioral
-- Project Name: axi_sdc
-- Target Devices: Artix7
-- Tool Versions: 
-- Description: 
--  Global definitions
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



package sdc_defines_pkg is

    constant CMD0 : std_logic_vector (5 downto 0) := "000000";
    constant CMD2 : std_logic_vector (5 downto 0) := "000010";
    constant CMD3 : std_logic_vector (5 downto 0) := "000011";
    constant CMD4 : std_logic_vector (5 downto 0) := "000100";
    constant CMD7 : std_logic_vector (5 downto 0) := "000111";
    constant CMD8 : std_logic_vector (5 downto 0) := "001000";
    constant CMD9 : std_logic_vector (5 downto 0) := "001001";
    constant CMD10 : std_logic_vector (5 downto 0) := "001010";
    constant CMD12 : std_logic_vector (5 downto 0) := "001100";
    constant CMD13 : std_logic_vector (5 downto 0) := "001101";
    constant CMD15 : std_logic_vector (5 downto 0) := "001111";

    constant SHORT_RESP : integer := 48;
    constant LONG_RESP : integer := 136;

    constant F400K_DIV : integer := 125;
    constant F25M_DIV : integer := 2;
    constant F50M_DIV : integer := 1;
    constant F400K : std_logic_vector(1 downto 0) := "00";
    constant F25M : std_logic_vector(1 downto 0) := "01";
    constant F50M : std_logic_vector(1 downto 0) := "10";

end sdc_defines_pkg;
