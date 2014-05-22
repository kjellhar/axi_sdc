----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/22/2014 11:30:54 AM
-- Design Name: 
-- Module Name: sdc_core - Behavioral
-- Project Name: 
-- Target Devices: 
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

entity sdc_core is
    Port ( clk : in STD_LOGIC;
           resetn : in STD_LOGIC;
		   sdc_clk : out std_logic;
           sdc_cmd_in : in std_logic;
           sdc_cmd_out : out std_logic;
           sdc_cmd_dir : out std_logic;
           sdc_dat_in : in std_logic_vector (3 downto 0);
           sdc_dat_out : out std_logic_vector (3 downto 0);
           sdc_dat_dir : out std_logic;
           
           sdc_card_detect : in std_logic;
           sdc_card_en : out std_logic;
           
           intr : out std_logic;   
           busy : out std_logic;
           cmd_received : in std_logic;     
           
           ctrl1_reg : in std_logic_vector (31 downto 0);
           ctrl2_reg : in std_logic_vector (31 downto 0);
           cmd_reg : in std_logic_vector (31 downto 0);
           carg_reg : in std_logic_vector (31 downto 0);
           evmask_reg : in std_logic_vector (31 downto 0);
          
           resp0_out : out STD_LOGIC_VECTOR (31 downto 0);
           resp1_out : out STD_LOGIC_VECTOR (31 downto 0);
           resp2_out : out STD_LOGIC_VECTOR (31 downto 0);
           resp3_out : out STD_LOGIC_VECTOR (31 downto 0);
           resp_wr_en : out std_logic;              
           event_out : out STD_LOGIC_VECTOR (31 downto 0);
           event_wr_en : out std_logic);
end sdc_core;

architecture Behavioral of sdc_core is
    component sdc_clk_gen is
    Port ( clk : in std_logic;
           resetn : in std_logic;
           sdc_clk : out std_logic;
           sdc_clockgen_en : in std_logic;
           fdiv : in std_logic_vector (15 downto 0);
           sdc_clk_redge : out std_logic;
           sdc_clk_fedge : out std_logic);
    end component;

    component sdc_ctrl is
    Port ( clk : in STD_LOGIC;
           resetn : in std_logic;
           sdc_clk_en : out std_logic;
           sdc_card_en : out std_logic;
           cmd_written : in std_logic;
           cmd_busy : in std_logic;
           cmd_start : out std_logic;
           sdc_cmd_dir : out std_logic;
           long_resp : out std_logic;
           command : in std_logic_vector (5 downto 0);
           crc_error : in std_logic;
           intr : out std_logic;
           ctrl1_reg : in std_logic_vector (31 downto 0);
           ctrl2_reg : in std_logic_vector (31 downto 0);           
           event_reg : out std_logic_vector (31 downto 0);
           event_wr_en : out std_logic;
           evmask : in std_logic_vector (31 downto 0)
           );
    end component;    


    component cmd_if is
    Port ( 
        clk : in STD_LOGIC;
        resetn : in std_logic;
        cmd_in_en : in std_logic;
        cmd_out_en : in std_logic;
        
        sdc_cmd_in : in std_logic;
        sdc_cmd_out : out std_logic;

        sdc_cmd_dir : in std_logic;
        long_resp : in std_logic;
        start : in std_logic;
        busy : out std_logic;
        
        cmd_in : in STD_LOGIC_VECTOR (39 downto 0);
        resp0_out : out STD_LOGIC_VECTOR (31 downto 0);
        resp1_out : out STD_LOGIC_VECTOR (31 downto 0);
        resp2_out : out STD_LOGIC_VECTOR (31 downto 0);
        resp3_out : out STD_LOGIC_VECTOR (31 downto 0);
        resp_wr_en : out std_logic;
        crc_error : out STD_LOGIC);
    end component;    



	signal cmd_busy : std_logic;

	
	signal sdc_cmd_dir_i : std_logic;
	signal long_resp : std_logic;
	signal cmd_start : std_logic;
	signal cmd_parallell_in : std_logic_vector (39 downto 0);
	signal crc_error : std_logic;
	
	signal sdc_clk_en : std_logic;
	signal sdc_clk_redge : std_logic;
	signal sdc_clk_fedge : std_logic;


begin
    u_clkgen : sdc_clk_gen
    Port map ( 
        clk => clk,
        resetn => resetn,
        sdc_clk => sdc_clk,
        sdc_clockgen_en => sdc_clk_en,
        fdiv => ctrl1_reg(31 downto 16),
        sdc_clk_redge => sdc_clk_redge,
        sdc_clk_fedge => sdc_clk_fedge);
    
    u_sdc_ctrl : sdc_ctrl
    Port map ( 
        clk => clk,
        resetn => resetn,
        sdc_clk_en => sdc_clk_en,
        sdc_card_en => sdc_card_en,
        cmd_written => cmd_received,
        cmd_busy => cmd_busy,
        cmd_start => cmd_start,
        sdc_cmd_dir => sdc_cmd_dir_i,
        long_resp => long_resp,
        command => cmd_reg(5 downto 0),
        crc_error => crc_error,
        intr => intr,
        ctrl1_reg => ctrl1_reg,
        ctrl2_reg => ctrl2_reg,        
        event_reg => event_out,
        event_wr_en => event_wr_en,
        evmask => evmask_reg);
    
    
    
    u_cmd_if : cmd_if 
    Port map ( 
        clk => clk,
        resetn => resetn,
        cmd_in_en => sdc_clk_redge,
        cmd_out_en => sdc_clk_fedge,
        sdc_cmd_in => sdc_cmd_in,
        sdc_cmd_out => sdc_cmd_out,
        
        sdc_cmd_dir => sdc_cmd_dir_i,
        long_resp => long_resp,
        start => cmd_start,
        busy => cmd_busy,
        
        cmd_in => cmd_parallell_in,
        resp0_out => resp0_out,
        resp1_out => resp1_out,
        resp2_out => resp2_out,
        resp3_out => resp3_out,
        resp_wr_en => resp_wr_en,
        crc_error => crc_error);
        
    cmd_parallell_in <= "01" & cmd_reg(5 downto 0) & carg_reg;
    
    sdc_cmd_dir <= sdc_cmd_dir_i;
    busy <= cmd_busy;
    
    sdc_dat_out <= "0000";

end Behavioral;
