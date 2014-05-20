----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/20/2014 10:41:39 AM
-- Design Name: 
-- Module Name: tb_sdc_ctrl - Behavioral
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

entity tb_sdc_ctrl is
end tb_sdc_ctrl;

architecture tb of tb_sdc_ctrl is

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
               cmd_written : in std_logic;
               cmd_busy : in std_logic;
               cmd_start : out std_logic;
               sdc_dir_out : out std_logic;
               long_resp : out std_logic;
               command : in std_logic_vector (5 downto 0);
               crc_error : in std_logic;
               intr : out std_logic;
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
    end component;	
    
    constant PERIOD : time := 10 ns;
    
    signal cmd_received : std_logic := '0';
    signal cmd_busy : std_logic;
    signal ctrl1_r : std_logic_vector (31 downto 0) := (others => '0');
    signal ctrl2_r : std_logic_vector (31 downto 0) := (others => '0');
    signal carg_r : std_logic_vector (31 downto 0) := (others => '0');
    signal cmd_r : std_logic_vector (31 downto 0) := (others => '0');
    signal resp0_r : std_logic_vector (31 downto 0) := (others => '0');
    signal resp1_r : std_logic_vector (31 downto 0) := (others => '0');
    signal resp2_r : std_logic_vector (31 downto 0) := (others => '0');
    signal resp3_r : std_logic_vector (31 downto 0) := (others => '0');
    signal evmask_r : std_logic_vector (31 downto 0) := (others => '0');
    signal event_r : std_logic_vector (31 downto 0) := (others => '0');
    signal resp_wr_en : std_logic;
    signal event_wr_en : std_logic;
    
    signal sdc_dir_out : std_logic;
    signal long_resp : std_logic;
    signal cmd_start : std_logic;
    signal cmd_done : std_logic;
    signal cmd_parallell_in : std_logic_vector (39 downto 0);
    signal response : std_logic_vector (135 downto 0);
    signal crc_error : std_logic;
    
    signal sdc_clk_en : std_logic;
    signal sdc_clk_redge : std_logic;
    signal sdc_clk_fedge : std_logic;
    
    signal clk : std_logic := '0';
    signal sim_en : std_logic := '1';
    signal resetn : std_logic := '0';
    
    signal command : std_logic_vector (5 downto 0) := "000100";
    signal sdc_clk : std_logic;
    signal sdc_cmd : std_logic;
    signal intr : std_logic;
    
    signal resp_short_crcok : std_logic_vector (47 downto 0) := x"123456789a95";
    

begin

    clockgen : process (Clk, sim_en)
    begin
        if sim_en = '1' then
            Clk <= not Clk after PERIOD/2;
        end if;
     end process;

    u_clkgen : sdc_clk_gen
    Port map ( 
        clk => clk,
        resetn => resetn,
        sdc_clk => sdc_clk,
        sdc_clockgen_en => sdc_clk_en,
        fdiv => ctrl2_r(15 downto 0),
        sdc_clk_redge => sdc_clk_redge,
        sdc_clk_fedge => sdc_clk_fedge);

    u_sdc_ctrl : sdc_ctrl
    Port map ( 
        clk => clk,
        resetn => resetn,
        sdc_clk_en => sdc_clk_en,
        cmd_written => cmd_received,
        cmd_busy => cmd_busy,
        cmd_start => cmd_start,
        sdc_dir_out => sdc_dir_out,
        long_resp => long_resp,
        command => command,
        crc_error => crc_error,
        intr => intr,
        event_reg => event_r,
        event_wr_en => event_wr_en,
        evmask => evmask_r);
  


    u_cmd_if : cmd_if 
    Port map ( 
        clk => clk,
        resetn => resetn,
        cmd_in_en => sdc_clk_redge,
        cmd_out_en => sdc_clk_fedge,
        sdc_cmd => sdc_cmd,
        
        sdc_dir_out => sdc_dir_out,
        long_resp => long_resp,
        start => cmd_start,
        busy => cmd_busy,
        
        cmd_in => cmd_parallell_in,
        resp0_out => resp0_r,
        resp1_out => resp1_r,
        resp2_out => resp2_r,
        resp3_out => resp3_r,
        resp_wr_en => resp_wr_en,
        crc_error => crc_error);

        
    cmd_parallell_in <= "01" & command & carg_r;

    stim : process
    begin
        sim_en <= '1';
        resetn <= '0';
        cmd_received <= '0';

        wait for 10*PERIOD;
        resetn <= '1';
        wait for 3*PERIOD;
        
        carg_r <= X"12345678";
        command <= "000011";

        wait until rising_edge(Clk);
        cmd_received <= '1';
        wait until cmd_busy='1';
        cmd_received <= '0';
        
        wait until cmd_busy='0';
        
        wait until rising_edge(Clk);
        
        wait for 3*PERIOD;
        
        for i in resp_short_crcok'left downto 0 loop
            wait until rising_edge(clk) and sdc_clk_fedge='1';
            sdc_cmd <= resp_short_crcok(i);
        end loop;  
        
        wait until rising_edge(clk);
        sdc_cmd <= 'H';

        wait for 10*PERIOD;
        sim_en <= '0';
    
        wait;
    
    end process;

end tb;
