----------------------------------------------------------------------------------
-- Company: Oppfinneriet
-- Engineer: Kjell H Andersen
-- 
-- Create Date: 05/20/2014 03:18:30 AM
-- Design Name: AXI_SDC
-- Module Name: sdc_defines_pkg - Behavioral
-- Project Name: AXI SDC
-- Target Devices: Artix7
-- Tool Versions: 
-- Description: 
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

    
    -- Register addresses
    constant AXI_ADR_WIDTH : integer := 4;
    
    constant REG_CTRL1_A : std_logic_vector(AXI_ADR_WIDTH-1 downto 0) := "0000";
    constant REG_CTRL2_A : std_logic_vector(AXI_ADR_WIDTH-1 downto 0) := "0001";
    constant REG_CARG_A  : std_logic_vector(AXI_ADR_WIDTH-1 downto 0) := "0010";
    constant REG_CMD_A   : std_logic_vector(AXI_ADR_WIDTH-1 downto 0) := "0011";
    constant REG_RESP0_A : std_logic_vector(AXI_ADR_WIDTH-1 downto 0) := "0100";
    constant REG_RESP1_A : std_logic_vector(AXI_ADR_WIDTH-1 downto 0) := "0101";
    constant REG_RESP2_A : std_logic_vector(AXI_ADR_WIDTH-1 downto 0) := "0110";
    constant REG_RESP3_A : std_logic_vector(AXI_ADR_WIDTH-1 downto 0) := "0111";
    constant REG_EVMASK_A : std_logic_vector(AXI_ADR_WIDTH-1 downto 0) := "1000";
    constant REG_EVENT_A : std_logic_vector(AXI_ADR_WIDTH-1 downto 0) := "1001";
    

end sdc_defines_pkg;