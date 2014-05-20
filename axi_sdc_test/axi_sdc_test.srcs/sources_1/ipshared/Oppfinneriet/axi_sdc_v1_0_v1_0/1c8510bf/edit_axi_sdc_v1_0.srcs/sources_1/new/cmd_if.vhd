----------------------------------------------------------------------------------
-- Company: Oppfinneriet
-- Engineer: Kjell H Andersen
-- 
-- Create Date: 05/20/2014 03:53:47 AM
-- Design Name: AXI_SDC
-- Module Name: cmd_if - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity cmd_if is
    Port ( 
        clk : in STD_LOGIC;
        resetn : in std_logic;
        cmd_in_en : in std_logic;
        cmd_out_en : in std_logic;
        sdc_cmd : inout STD_LOGIC;
        
        sdc_dir_out : in std_logic;
        long_resp : in std_logic;
        start : in std_logic;
        busy : out std_logic;
        
        cmd_in : in STD_LOGIC_VECTOR (39 downto 0);
        resp0_out : out STD_LOGIC_VECTOR (31 downto 0);
        resp1_out : out STD_LOGIC_VECTOR (31 downto 0);
        resp2_out : out STD_LOGIC_VECTOR (31 downto 0);
        resp3_out : out STD_LOGIC_VECTOR (31 downto 0);
        resp_wr_en : out std_logic;
        crc_error : out STD_LOGIC     
        
        );
end cmd_if;

architecture rtl of cmd_if is
    component cmd_if_in is
    Port ( clk : in STD_LOGIC;
           resetn : in std_logic;
           enable : in STD_LOGIC;
           sdc_cmd_in : in STD_LOGIC;
           long_resp : in STD_LOGIC;
           start : in STD_LOGIC;
           busy : out STD_LOGIC;
           resp0_out : out STD_LOGIC_VECTOR (31 downto 0);
           resp1_out : out STD_LOGIC_VECTOR (31 downto 0);
           resp2_out : out STD_LOGIC_VECTOR (31 downto 0);
           resp3_out : out STD_LOGIC_VECTOR (31 downto 0);
           resp_wr_en : out std_logic;
           crc_error : out STD_LOGIC);
    end component;
    
    component cmd_if_out is
    Port ( clk : in STD_LOGIC;
           resetn : in std_logic;
           enable : in STD_LOGIC;
           sdc_cmd_out : out STD_LOGIC;
           cmd_in : in STD_LOGIC_VECTOR (39 downto 0);
           start : in STD_LOGIC;
           busy : out STD_LOGIC
           );
    end component;
    
    signal sdc_cmd_out : std_logic;
    signal cmd_in_start : std_logic;
    signal cmd_in_busy : std_logic;
    signal cmd_out_start : std_logic;
    signal cmd_out_busy : std_logic;
        
begin

    sdc_cmd <= sdc_cmd_out when sdc_dir_out = '1' else 'H';
    
    cmd_in_start <= start when sdc_dir_out = '0' else '0';
    cmd_out_start <= start when sdc_dir_out = '1' else '0';
    
    busy <= cmd_in_busy or cmd_out_busy;
    
    u_cmd_if_in : cmd_if_in
    Port map ( 
        clk => clk,
        resetn => resetn,
        enable => cmd_in_en,
        sdc_cmd_in => sdc_cmd,
        long_resp => long_resp,
        start => cmd_in_start,
        busy => cmd_in_busy,
        resp0_out => resp0_out,
        resp1_out => resp1_out,
        resp2_out => resp2_out,
        resp3_out => resp3_out,
        resp_wr_en => resp_wr_en,
        crc_error => crc_error);
    
    u_cmd_if_out : cmd_if_out
    Port map ( 
        clk => clk,
        resetn => resetn,
        enable => cmd_out_en,
        sdc_cmd_out => sdc_cmd_out,
        cmd_in => cmd_in,
        start => cmd_out_start,
        busy => cmd_out_busy);

end rtl;
