LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY sisa IS
    PORT (CLOCK_50  : IN    STD_LOGIC;
          SRAM_ADDR : out   std_logic_vector(17 downto 0);
          SRAM_DQ   : inout std_logic_vector(15 downto 0);
          SRAM_UB_N : out   std_logic;
          SRAM_LB_N : out   std_logic;
          SRAM_CE_N : out   std_logic := '1';
          SRAM_OE_N : out   std_logic := '1';
          SRAM_WE_N : out   std_logic := '1';
          LEDR      : out   std_logic_vector(7 downto 0);
          LEDG      : out   std_logic_vector(7 downto 0);
          SW        : in    std_logic_vector(9 downto 0);
          KEY       : in    std_logic_vector(3 downto 0);
          HEX0      : out   std_logic_vector(6 downto 0);
          HEX1      : out   std_logic_vector(6 downto 0);
          HEX2      : out   std_logic_vector(6 downto 0);
          HEX3      : out   std_logic_vector(6 downto 0);
			 PS2_CLK	  : inout std_LOGIC;
			 PS2_DAT  : inout std_LOGIC
      );
    
END sisa;

ARCHITECTURE Structure OF sisa IS
    component MemoryController is
        port (CLOCK_50  : in  std_logic;
              addr      : in  std_logic_vector(15 downto 0);
              wr_data   : in  std_logic_vector(15 downto 0);
              rd_data   : out std_logic_vector(15 downto 0);
              we        : in  std_logic;
              byte_m    : in  std_logic;
              -- señales para la placa de desarrollo
              SRAM_ADDR : out   std_logic_vector(17 downto 0);
              SRAM_DQ   : inout std_logic_vector(15 downto 0);
              SRAM_UB_N : out   std_logic;
              SRAM_LB_N : out   std_logic;
              SRAM_CE_N : out   std_logic := '1';
              SRAM_OE_N : out   std_logic := '1';
              SRAM_WE_N : out   std_logic := '1');
    end  component;

    component proc IS
        PORT (clk       : IN  STD_LOGIC;
              boot      : IN  STD_LOGIC;
              datard_m  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
              addr_m    : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
              data_wr   : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
              wr_m      : OUT STD_LOGIC;
              word_byte : OUT STD_LOGIC;   
              wr_io     : OUT std_logic_vector(15 downto 0);
              rd_io     : IN std_logic_vector(15 downto 0);
              addr_io   : OUT std_logic_vector(15 downto 0);
              rd_in     : out std_logic;
              wr_out    : out std_logic);
    END component;

    component controladores_IO is
        PORT (
          boot : IN STD_LOGIC;
          CLOCK_50 : in std_logic;
          addr_io : in std_logic_vector(15 downto 0);
          wr_io : in std_logic_vector(15 downto 0);
          rd_io : out std_logic_vector(15 downto 0);
          wr_out : in std_logic; 
          rd_in : in std_logic;
          led_verdes : out std_logic_vector(7 downto 0);
          led_rojos : out std_logic_vector(7 downto 0);
          key: in std_logic_vector(3 downto 0);
          switch: in std_logic_vector(7 downto 0);
          HEX0      : out   std_logic_vector(6 downto 0);
          HEX1      : out   std_logic_vector(6 downto 0);
          HEX2      : out   std_logic_vector(6 downto 0);
          HEX3      : out   std_logic_vector(6 downto 0);
			 ps2_clk    : inout STD_LOGIC;
			 ps2_data   : inout STD_LOGIC
        );
    end component;
	 
    signal clk_divider : std_logic_vector(2 downto 0):=(others=>'0');
    
    signal datard_m : std_logic_vector(15 downto 0);
    signal addr_m : std_logic_vector(15 downto 0);
    signal data_wr : std_logic_vector(15 downto 0);
    signal wr : std_logic;
    signal word_byte : std_logic;

    signal addr_io : std_logic_vector(15 downto 0);
    signal wr_io : std_logic_vector (15 downto 0);
    signal rd_io : std_logic_vector (15 downto 0);
    signal wr_out : std_logic;
    signal rd_in : std_logic;
BEGIN

    clk_divider <= 
        clk_divider+1 when rising_edge(CLOCK_50)
        else clk_divider;

mem : MemoryController
    port map(
        CLOCK_50  => CLOCK_50,
        addr      => addr_m,
        wr_data   => data_wr,
        rd_data   => datard_m,
        we        => wr,
        byte_m    => word_byte,
        SRAM_ADDR => SRAM_ADDR,
        SRAM_DQ   => SRAM_DQ,
        SRAM_UB_N => SRAM_UB_N,
        SRAM_LB_N => SRAM_LB_N,
        SRAM_CE_N => SRAM_CE_N,
        SRAM_OE_N => SRAM_OE_N,
        SRAM_WE_N => SRAM_WE_N);

processor : proc
    PORT map(
        clk       => clk_divider(2),
        boot      => SW(9),
        datard_m  => datard_m,
        addr_m    => addr_m,
        data_wr   => data_wr,
        wr_m      => wr,
        word_byte => word_byte,
        addr_io => addr_io,
        wr_io => wr_io,
        rd_io => rd_io,
        wr_out => wr_out,
        rd_in => rd_in);
		  
		  
IOcontroller: controladores_IO
    port map(
        boot => SW(9),
        CLOCK_50 => CLOCK_50,
        addr_io => addr_io,
        wr_io => wr_io,
        rd_io => rd_io,
        wr_out => wr_out,
        rd_in => rd_in,
        led_verdes => LEDG,
        led_rojos => LEDR,
        key => KEY,
        switch => SW(7 downto 0),
        HEX0 => HEX0,
        HEX1 => HEX1,
        HEX2 => HEX2,
        HEX3 => HEX3,
		  ps2_clk => PS2_CLK,
		  ps2_data => PS2_DAT
    );
END Structure;
