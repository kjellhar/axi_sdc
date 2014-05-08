----------------------------------------------------------------------------------
-- Company: Oppfinneriet
-- Engineer: Kjell H Andersen
-- 
-- Create Date: 05/08/2014 06:07:26 AM
-- Design Name: axi_sdc
-- Module Name: sdc_sys_ctrl - rtl
-- Project Name: axi_sdc
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

entity sdc_sys_ctrl is
    Port ( clk100 : in STD_LOGIC;
           enable : in STD_LOGIC);
end sdc_sys_ctrl;

architecture rtl of sdc_sys_ctrl is

    type sysctrl_state_t is (
        IDLE,
        GET_CMD,
        CMD_NO_R,
        CMD_R1,
        CMD_R1B,
        CMD_R2,
        CMD_R3);

begin


end rtl;
