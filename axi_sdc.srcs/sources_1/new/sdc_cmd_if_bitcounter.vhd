----------------------------------------------------------------------------------
-- Company: Oppfinneriet
-- Engineer: Kjell H Andersen
-- 
-- Create Date: 04/23/2014 11:04:05 PM
-- Design Name: axi_sdc
-- Module Name: sdc_cmd_if_bitcounter - rtl
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

entity sdc_cmd_if_bitcounter is
    Port ( Clk : in std_logic;
           bitc_en : in std_logic;
           bitc_clr : in std_logic;
           cmd_pre_finish : out std_logic;
           cmd_short_finish : out std_logic;
           cmd_arg0_finish : out std_logic;
           cmd_arg1_finish : out std_logic;
           cmd_arg2_finish : out std_logic;
           cmd_arg3_finish : out std_logic);
end sdc_cmd_if_bitcounter;

architecture rtl of sdc_cmd_if_bitcounter is
    signal bit_count : integer range 0 to 136 := 0;

begin

    process_bit_counter : process (clk)
    begin
        if rising_edge (clk) then
            if bitc_clr = '1' then
                bit_count <= 0;
            elsif bitc_en = '1' then
                if bit_count = 136 then
                    bit_count <= 0;
                else
                    bit_count <= bit_count + 1;
                end if;
            end if;
        end if;
    end process;

    bit_counter_outp : process (bit_count)
        constant PRE_C : integer := 8;
        constant ARG0_C : integer := 40;
        constant SHORT_R_FINISH_C : integer := 48;
        constant ARG1_C : integer := 72;
        constant ARG2_C : integer := 104;
        constant ARG3_C : integer := 136;
 
    begin
        case bit_count is    
            when PRE_C =>
                cmd_pre_finish <= '1';
                cmd_short_finish <= '0';
                cmd_arg0_finish <= '0';
                cmd_arg1_finish <= '0';
                cmd_arg2_finish <= '0';
                cmd_arg3_finish <= '0';
        
            when SHORT_R_FINISH_C =>
                cmd_pre_finish <= '0';
                cmd_short_finish <= '1';
                cmd_arg0_finish <= '0';
                cmd_arg1_finish <= '0';
                cmd_arg2_finish <= '0';
                cmd_arg3_finish <= '0';
                                
            when ARG0_C =>
                cmd_pre_finish <= '0';
                cmd_short_finish <= '0';
                cmd_arg0_finish <= '1';
                cmd_arg1_finish <= '0';
                cmd_arg2_finish <= '0';
                cmd_arg3_finish <= '0';
                
            when ARG1_C =>
                cmd_pre_finish <= '0';
                cmd_short_finish <= '0';
                cmd_arg0_finish <= '0';
                cmd_arg1_finish <= '1';
                cmd_arg2_finish <= '0';
                cmd_arg3_finish <= '0';
                                
            when ARG2_C =>
                cmd_pre_finish <= '0';
                cmd_short_finish <= '0';
                cmd_arg0_finish <= '0';
                cmd_arg1_finish <= '0';
                cmd_arg2_finish <= '1';
                cmd_arg3_finish <= '0';
                                
            when ARG3_C =>
                cmd_pre_finish <= '0';
                cmd_short_finish <= '0';
                cmd_arg0_finish <= '0';
                cmd_arg1_finish <= '0';
                cmd_arg2_finish <= '0';
                cmd_arg3_finish <= '1';
                                
            when others =>
                cmd_pre_finish <= '0';
                cmd_short_finish <= '0';
                cmd_arg0_finish <= '0';
                cmd_arg1_finish <= '0';
                cmd_arg2_finish <= '0';
                cmd_arg3_finish <= '0';
                        
        end case;
    end process;
end rtl;
