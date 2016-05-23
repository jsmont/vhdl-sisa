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
			 PS2_DAT  : inout std_LOGIC;
          VGA_R : out std_logic_vector(7 downto 0); -- vga red pixel value
			 VGA_G : out std_logic_vector(7 downto 0); -- vga green pixel value
          VGA_B : out std_logic_vector(7 downto 0); -- vga blue pixel value
          VGA_HS : out std_logic; -- vga control signal
          VGA_VS : out std_logic -- vga control signal
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
              -- seÃ±ales para la placa de desarrollo
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
			     vga_byte_m : out std_logic);
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
              wr_out    : out std_logic;
				  intr : in std_logic);
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
			 ps2_data   : inout STD_LOGIC;
         vga_cursor        : out std_logic_vector(15 downto 0);
         vga_cursor_enable : out std_logic;
			intr : out std_logic
        );
    end component;
	 
	 
	component vga_controller is
    port(clk_50mhz      : in  std_logic; -- system clock signal
         reset          : in  std_logic; -- system reset
         blank_out      : out std_logic; -- vga control signal
         csync_out      : out std_logic; -- vga control signal
         red_out        : out std_logic_vector(7 downto 0); -- vga red pixel value
			green_out		: out std_logic_vector(7 downto 0); -- vga green pixel value
         blue_out       : out std_logic_vector(7 downto 0); -- vga blue pixel value
         horiz_sync_out : out std_logic; -- vga control signal
         vert_sync_out  : out std_logic; -- vga control signal
         --
         addr_vga          : in std_logic_vector(12 downto 0);
         we                : in std_logic;
         wr_data           : in std_logic_vector(15 downto 0);
         rd_data           : out std_logic_vector(15 downto 0);
         byte_m            : in std_logic;
         vga_cursor        : in std_logic_vector(15 downto 0);  -- simplemente lo ignoramos, este controlador no lo tiene implementado
         vga_cursor_enable : in std_logic);                     -- simplemente lo ignoramos, este controlador no lo tiene implementado
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
	 
	signal vga_addr : std_logic_vector(12 downto 0);
	signal vga_we : std_logic;
	signal vga_wr_data : std_logic_vector(15 downto 0);
	signal vga_rd_data: std_logic_vector(15 downto 0);
	signal vga_byte_m : std_logic;
	signal vga_cursor : std_logic_vector(15 downto 0);
   signal vga_cursor_enable : std_logic;
	signal intr : std_LOGIC;
	
BEGIN

    clk_divider <= 
        clk_divider+1 when rising_edge(CLOCK_50)
        else clk_divider;

vga: vga_controller
	port map(
			clk_50mhz => CLOCK_50,
         reset => SW(9),
         red_out => VGA_R,
			green_out => VGA_G,
         blue_out => VGA_B,
         horiz_sync_out => VGA_HS,
         vert_sync_out => VGA_VS,
         --
         addr_vga => vga_addr,
         we => vga_we,
         wr_data => vga_wr_data,
         rd_data => vga_rd_data,
         byte_m => vga_byte_m,
			vga_cursor => vga_cursor,
			vga_cursor_enable => vga_cursor_enable);
		  
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
        SRAM_WE_N => SRAM_WE_N,
		  vga_addr => vga_addr,
		  vga_we => vga_we,
		  vga_wr_data => vga_wr_data,
		  vga_rd_data => vga_rd_data,
		  vga_byte_m => vga_byte_m);

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
        rd_in => rd_in,
		  intr => intr);
		  
		  
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
		  ps2_data => PS2_DAT,
		  vga_cursor => vga_cursor,
		  vga_cursor_enable => vga_cursor_enable,
		  intr => intr
    );
END Structure;
