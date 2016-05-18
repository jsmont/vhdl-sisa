library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use ieee.std_logic_arith.all;
--use ieee.std_logic_unsigned.all;

entity SRAMController is
    port (clk         : in    std_logic;
          -- señales para la placa de desarrollo
          SRAM_ADDR   : out   std_logic_vector(17 downto 0);
          SRAM_DQ     : inout std_logic_vector(15 downto 0);
          SRAM_UB_N   : out   std_logic;
          SRAM_LB_N   : out   std_logic;
          SRAM_CE_N   : out   std_logic := '1';
          SRAM_OE_N   : out   std_logic := '1';
          SRAM_WE_N   : out   std_logic := '1';
          -- señales internas del procesador
          address     : in    std_logic_vector(15 downto 0) := "0000000000000000";
          dataReaded  : out   std_logic_vector(15 downto 0);
          dataToWrite : in    std_logic_vector(15 downto 0);
          WR          : in    std_logic;
          byte_m      : in    std_logic := '0');
end SRAMController;

architecture comportament of SRAMController is
    type write_state is (IDLE, SETUP, WRITE);

    signal state : write_state := IDLE;
    signal n_state : write_state := IDLE;
    signal cycle: std_logic := '0';
begin

    --Manage State

    state <=
        n_state when rising_edge(clk)
        else state;

    n_state <= 
        SETUP when state=IDLE and cycle='0' and WR='1'
        else WRITE when state=SETUP
        else IDLE;

    cycle <= 
        '1' when state=SETUP
        else '0' when WR='0'
        else cycle;
--    count <=
--        6 when state=WRITE and rising_edge(clk)
--        else 8 when state=IDLE and count=0 and rising_edge(clk)
--        else count-1 when state=IDLE and rising_edge(clk)
--        else count;

    --Manage data flows


    -- Address is obvious
    SRAM_ADDR <= "000"&address(15 downto 1);
        

    -- SRAM_DQ is the data to write on writing and a high impedance on other
    SRAM_DQ <= 
        dataToWrite when (state=SETUP or state=WRITE) and (byte_m='0' or address(0)='0')
        else dataToWrite(7 downto 0) & "00000000" when (state=SETUP or state=WRITE) and byte_m='1'
        else "ZZZZZZZZZZZZZZZZ";
    
    SRAM_UB_N <=
        (not address(0)) when WR='1' and byte_m='1'
        else '0';

    SRAM_LB_N <=
        address(0) when WR='1' and byte_m='1'
        else '0';

    SRAM_CE_N <=
        '0' when state=SETUP or state=IDLE 
        else '1';

    -- Has to be 0 on read and is irellevant for write
    SRAM_OE_N <= '0';


    SRAM_WE_N <=
        '0' when state=SETUP
        else '1';


    dataReaded <=
       std_logic_vector(resize(signed(SRAM_DQ(7 downto 0)), dataReaded'length)) when byte_m='1' and address(0)='0' and state=IDLE
       else std_logic_vector(resize(signed(SRAM_DQ(15 downto 8)), dataReaded'length)) when byte_m='1' 
and state=IDLE      else SRAM_DQ;
        


end comportament;
