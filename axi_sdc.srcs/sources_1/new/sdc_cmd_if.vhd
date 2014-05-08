----------------------------------------------------------------------------------
-- Company: Oppfinneriet
-- Engineer: Kjell H Andersen
-- 
-- Create Date: 05/06/2014 12:28:59 AM
-- Design Name: axi_sdc
-- Module Name: sdc_cmd_if - rtl
-- Project Name: axi_sdc
-- Target Devices: Artix7
-- Tool Versions: 
-- Description: 
--  Implements the physical interface to the CMD line. The internal interface is 
--  byte oriented, and both read and write data is buffered in FIFOs.
--  
--
--  Write transactions are always 48 bits long (6 bytes) including CRC7 at the end.
--   5 bytes must be loaded into the TX_FIFO on 6 consecutive clock cycles.
--   The CRC byte is generated internally
--   When at least one byte is loaded. the transaction may be started.
--   pull transmit <= '1'
--   pull start <= '1'
--   The SDC clock must be running. The data is shifted out on the falling edge.
--   The busy line will og high when the transaction starts.
--   The clock must toggle, and transmit must be held during the entire transaction.
--   When the busy line goes low, the transaction is ended and start must immediately
--   be pulled low.
--
--  Read transactions can be 48 bits or 136 bits long. This is selected with the
--   length signal.
--      length = 0 :  48 bits
--      length = 1 :  136 bits
--   To start a read transaction
--   pull transmit <= '0'
--   pull length to desired length
--   pull start <= '1'
--   The SDC clock must be running. The data is sampled on the rising edge.
--   The busy line will go high when the transaction starts.
--   The transmit and length signals must be held during the entire transaction.
--   When the busy line goes low, the transaction has ended and start must immediately
--   be pulled low.
--   The data can then be fetched from the RX_FIFO. This may also be done during the
--   transaction by monitoring the rx_emtpy signal.
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sdc_cmd_if is
    Port ( clk100 : in STD_LOGIC;
           enable : in STD_LOGIC;
           sdc_cmd_io : inout std_logic;
           sdc_clk_redge : in std_logic;
           sdc_clk_fedge : in std_logic;
           tx_din : in STD_LOGIC_VECTOR (7 downto 0);
           tx_wr_en : in STD_LOGIC;
           tx_full : out STD_LOGIC;
           tx_empty : out STD_LOGIC;
           rx_dout : out STD_LOGIC_VECTOR (7 downto 0);
           rx_rd_en : in STD_LOGIC;
           rx_full : out STD_LOGIC;
           rx_empty : out STD_LOGIC;
           transmit : in STD_LOGIC;
           length : in std_logic;
           start : in STD_LOGIC;
           busy : out STD_LOGIC);
end sdc_cmd_if;

architecture rtl of sdc_cmd_if is
    COMPONENT cmd_fifo
      PORT (
        clk : IN STD_LOGIC;
        din : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        wr_en : IN STD_LOGIC;
        rd_en : IN STD_LOGIC;
        dout : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        full : OUT STD_LOGIC;
        empty : OUT STD_LOGIC
      );
    END COMPONENT;
    ATTRIBUTE SYN_BLACK_BOX : BOOLEAN;
    ATTRIBUTE SYN_BLACK_BOX OF cmd_fifo : COMPONENT IS TRUE;
    ATTRIBUTE BLACK_BOX_PAD_PIN : STRING;
    ATTRIBUTE BLACK_BOX_PAD_PIN OF cmd_fifo : COMPONENT IS "clk,srst,din[7:0],wr_en,rd_en,dout[7:0],full,empty";
    
    component crc_8_10001001 is 
        port (
            clk : in std_logic;
            clear : in std_logic;
            enable : in std_logic;
            d : in std_logic_vector(  7 downto 0);
            c : out std_logic_vector(  6 downto 0)); 
    end component;    
    
    
    signal rx_din : std_logic_vector(7 downto 0);
    signal tx_dout : std_logic_vector(7 downto 0);
    signal rx_wr_en : std_logic;
    signal tx_rd_en : std_logic;
    
    signal tx_full_i : std_logic;
    signal tx_empty_i : std_logic;
    signal rx_full_i : std_logic;
    signal rx_empty_i : std_logic;
        
    signal shift_data : std_logic_vector(7 downto 0) := (others => '1');
    signal load_shift_data : std_logic_vector(7 downto 0) := (others => '1');
    signal load_tx_data : std_logic;
    signal shift_serdata : std_logic;
    signal rx_data_rdy : std_logic;
    
    signal bit_count : unsigned(7 downto 0) := (others => '0');
    signal count_clr : std_logic;
    
    signal clk_enable : std_logic;
    signal count_enable : std_logic;
    signal shift_enable : std_logic;
    
    signal crc_data : std_logic_vector (7 downto 0);
    signal crc7 : std_logic_vector (6 downto 0);
    signal crc_clear : std_logic;
    signal crc_enable : std_logic;
    signal load_crc : std_logic;
    
    
    type cmdif_state_t is (
        IDLE,
        WR_START,
        WR_LOAD_DATA,
        WR_LOAD_CRC,
        WR_SHIFT_DATA,
        WR_END,
        RD_START,
        RD_SHIFT_DATA,
        RD_DATA_RDY,
        RD_END
    );
    
    signal cmdif_state : cmdif_state_t := IDLE;
    signal cmdif_state_next : cmdif_state_t;
    
    
begin

    clk_enable <= sdc_clk_fedge when transmit='1' else sdc_clk_redge;

    u_rx_fifo : cmd_fifo
        PORT MAP (
            clk => clk100,
            din => rx_din,
            wr_en => rx_wr_en,
            rd_en => rx_rd_en,
            dout => rx_dout,
            full => rx_full_i,
            empty => rx_empty_i
        );
      
    u_tx_fifo : cmd_fifo
        PORT MAP (
            clk => clk100,
            din => tx_din,
            wr_en => tx_wr_en,
            rd_en => tx_rd_en,
            dout => tx_dout,
            full => tx_full_i,
            empty => tx_empty_i
        );
        
    u_crc7 : crc_8_10001001 
        port map (
            clk => clk100,
            clear => crc_clear,
            enable => crc_enable,
            d => crc_data,
            c => crc7
        ); 
                    
        
    tx_full <= tx_full_i;
    tx_empty <= tx_empty_i;    
    rx_full <= rx_full_i;
    rx_empty <= rx_empty_i;    
    
    rx_din <= shift_data;
    tx_rd_en <= load_tx_data and clk_enable;
    rx_wr_en <= rx_data_rdy and clk_enable;

    shift_8 : process (clk100)
    begin
        if rising_edge(clk100) then
            if shift_enable='1' and clk_enable='1' then
                if load_tx_data='1' or load_crc='1' then
                    shift_data <= load_shift_data;
                else
                    shift_data(7 downto 0) <= shift_data(6 downto 0) & shift_serdata;
                end if;
            end if;
        end if;
    end process;


    bit_counter : process (clk100)
    begin
        if rising_edge(clk100) then
            if count_clr='1' then
                bit_count <= (others => '0');
            elsif count_enable='1' and clk_enable='1' then
                bit_count <= bit_count + 1;
            end if;
        end if;
    end process;


    shift_state : process (clk100)
    begin
        if rising_edge(clk100) then
            if enable='1' and enable='1' then
                cmdif_state <= cmdif_state_next;
            end if;
        end if;
    end process;
    
    
    shift_nextstate_logic : process (
                            cmdif_state, transmit, start, tx_empty_i, 
                            bit_count, clk_enable, sdc_cmd_io, length)
    begin
        case cmdif_state is
            when IDLE =>
                if transmit='1' and start='1' and tx_empty_i='0' then
                    cmdif_state_next <= WR_START;
                elsif transmit='0' and start='1' then
                    cmdif_state_next <= RD_START;
                else
                    cmdif_state_next <= IDLE;
                end if;

            when WR_START =>
                if clk_enable='1' then
                    cmdif_state_next <= WR_SHIFT_DATA;
                else
                    cmdif_state_next <= WR_START;
                end if;
                            
            when WR_LOAD_DATA =>
                if clk_enable='1' then
                    cmdif_state_next <= WR_SHIFT_DATA;
                else
                    cmdif_state_next <= WR_LOAD_DATA;                    
                end if;
                
            when WR_LOAD_CRC =>
                    if clk_enable='1' then
                        cmdif_state_next <= WR_SHIFT_DATA;
                    else
                        cmdif_state_next <= WR_LOAD_CRC;                 
                    end if;
                
                
            when WR_SHIFT_DATA =>
                if clk_enable='1' then
                    if bit_count(2 downto 0)="110" then
                        if bit_count(5 downto 3)="101" then
                            cmdif_state_next <= WR_END;
                            
                        elsif bit_count(5 downto 3)="100" then
                            cmdif_state_next <= WR_LOAD_CRC;
                                                        
                        else
                            cmdif_state_next <= WR_LOAD_DATA;
                            
                        end if;
                    else
                        cmdif_state_next <= WR_SHIFT_DATA;
                        
                    end if;
                else
                    cmdif_state_next <= WR_SHIFT_DATA;
                                         
                end if;     
            
            when WR_END =>
                if clk_enable='1' then
                    cmdif_state_next <= IDLE;
                else
                    cmdif_state_next <= WR_END;                    
                end if;                

            when RD_START =>
                if sdc_cmd_io='0' and clk_enable='1' then
                    cmdif_state_next <= RD_SHIFT_DATA;
                else
                    cmdif_state_next <= RD_START;
                end if;

            when RD_SHIFT_DATA =>
                if clk_enable='1' then
                    if bit_count(2 downto 0)="110" then
                        cmdif_state_next <= RD_DATA_RDY;
                    else
                        cmdif_state_next <= RD_SHIFT_DATA;
                    end if;
                else
                    cmdif_state_next <= RD_SHIFT_DATA;                       
                end if;                     

            when RD_DATA_RDY =>
                if clk_enable='1' then                
                    if (length='0' and bit_count(5 downto 3)="101") or (length='1' and bit_count(7 downto 3)="10000") then
                        cmdif_state_next <= RD_END;
                    else
                        cmdif_state_next <= RD_SHIFT_DATA;
                    end if;
                else
                    cmdif_state_next <= RD_DATA_RDY;                     
                end if;

            when RD_END =>
                if clk_enable='1' then
                    cmdif_state_next <= IDLE;
                else
                    cmdif_state_next <= RD_END;                      
                end if;                                                                                               
        end case;
    end process;

    -- Shift state machine output logic
    load_tx_data <=     '1' when cmdif_state = WR_START else
                        '1' when cmdif_state = WR_LOAD_DATA else
                        '0';
                    
    count_enable <=     '0' when cmdif_state = RD_START else
                        '0' when cmdif_state = WR_START else
                        '0' when cmdif_state = IDLE else
                        '1';
                        
    count_clr <=        '1' when cmdif_state = RD_END else
                        '1' when cmdif_state = WR_END else
                        '1' when cmdif_state = IDLE else
                        '0';
                 
    shift_enable <=     '0' when cmdif_state = RD_END else
                        '0' when cmdif_state = IDLE else 
                        '1';
                        
    busy <=             '0' when cmdif_state = IDLE else
                        '1';     
                        
    shift_serdata <=    sdc_cmd_io when cmdif_state = RD_DATA_RDY else 
                        sdc_cmd_io when cmdif_state = RD_SHIFT_DATA else 
                        sdc_cmd_io when cmdif_state = RD_START else 
                        '1';
                        
    load_shift_data <=  crc7 & '0' when cmdif_state = WR_LOAD_CRC else
                        tx_dout;
                        
    sdc_cmd_io <=       shift_data(7) when cmdif_state = WR_START else
                        shift_data(7) when cmdif_state = WR_LOAD_DATA else
                        shift_data(7) when cmdif_state = WR_LOAD_CRC else
                        shift_data(7) when cmdif_state = WR_SHIFT_DATA else
                        shift_data(7) when cmdif_state = WR_END else
                        'Z';
                        
    rx_data_rdy <=      '1' when cmdif_state = RD_DATA_RDY else
                        '0';
                        
    crc_data <=         shift_data when cmdif_state = RD_END else
                        shift_data when cmdif_state = RD_DATA_RDY else
                        shift_data when cmdif_state = RD_SHIFT_DATA else
                        shift_data when cmdif_state = RD_START else
                        tx_dout;
                        
    crc_clear <=        '1' when cmdif_state = IDLE else
                        '1' when cmdif_state = WR_END else
                        '1' when cmdif_state = RD_END else
                        '0';
                        
    crc_enable <=       clk_enable when cmdif_state = RD_DATA_RDY else
                        clk_enable when cmdif_state = RD_SHIFT_DATA else
                        clk_enable when cmdif_state = RD_START else
                        clk_enable when cmdif_state = WR_LOAD_DATA else
                        clk_enable when cmdif_state = WR_START else
                        '0';
                        
    load_crc <=         '1' when cmdif_state = WR_LOAD_CRC else
                        '0';
                                                
end rtl;
