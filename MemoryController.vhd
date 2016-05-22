library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity MemoryController is
    port (CLOCK_50  : in  std_logic;
	      addr      : in  std_logic_vector(15 downto 0);
          wr_data   : in  std_logic_vector(15 downto 0);
          rd_data   : out std_logic_vector(15 downto 0);
          we        : in  std_logic;
          byte_m    : in  std_logic;
          -- se�ales para la placa de desarrollo
          SRAM_ADDR : out   std_logic_vector(17 downto 0);
          SRAM_DQ   : inout std_logic_vector(15 downto 0);
          SRAM_UB_N : out   std_logic;
          SRAM_LB_N : out   std_logic;
          SRAM_CE_N : out   std_logic := '1';
          SRAM_OE_N : out   std_logic := '1';
          SRAM_WE_N : out   std_logic := '1';
			 vga_addr : out std_logic_vector(12 downto 0);
			 vga_we : out std_logic;
			 vga_wr_data : out std_logic_vector(15 downto 0);
			 vga_rd_data: in std_logic_vector(15 downto 0);
			 vga_byte_m : out std_logic
		);
end MemoryController;

architecture comportament of MemoryController is
    component SRAMController is
        port (clk         : in    std_logic;
              -- se�ales para la placa de desarrollo
              SRAM_ADDR   : out   std_logic_vector(17 downto 0);
              SRAM_DQ     : inout std_logic_vector(15 downto 0);
              SRAM_UB_N   : out   std_logic;
              SRAM_LB_N   : out   std_logic;
              SRAM_CE_N   : out   std_logic := '1';
              SRAM_OE_N   : out   std_logic := '1';
              SRAM_WE_N   : out   std_logic := '1';
              -- se�ales internas del procesador
              address     : in    std_logic_vector(15 downto 0) := "0000000000000000";
              dataReaded  : out   std_logic_vector(15 downto 0);
              dataToWrite : in    std_logic_vector(15 downto 0);
              WR          : in    std_logic;
              byte_m      : in    std_logic := '0');
    end  component;

    signal wr : std_logic := '0';
	 signal mem_data_out : std_logic_vector(15 downto 0);
begin

sram: SRAMController
    port map(
        clk => CLOCK_50,
        SRAM_ADDR => SRAM_ADDR,
        SRAM_DQ     => SRAM_DQ,
        SRAM_UB_N   => SRAM_UB_N,
        SRAM_LB_N   => SRAM_LB_N,
        SRAM_CE_N   => SRAM_CE_N,
        SRAM_OE_N   => SRAM_OE_N,
        SRAM_WE_N   => SRAM_WE_N,
        address     => addr,
        dataReaded  => mem_data_out,
        dataToWrite => wr_data,
        WR          => wr,
        byte_m      => byte_m);

    -- Write protection on system addresses
    with addr(15 downto 13) select
    wr <=
        '0' when "110",
        '0' when "111",
        '0' when "101",
        we when others;
		  
	 with addr(15 downto 13) select
    vga_we <=
        we when "101",
        '0' when others;
	
	 with addr(15 downto 13) select
	 rd_data <=
		vga_rd_data when "101",
		mem_data_out when others;
		
	vga_wr_data <= wr_data;
	
	vga_addr <= addr(12 downto 0);
	 
	 vga_byte_m <= byte_m;

end comportament;
