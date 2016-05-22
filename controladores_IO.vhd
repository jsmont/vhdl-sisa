LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all; --Esta libreria sera necesaria si usais conversiones CONV_INTEGER

ENTITY controladores_IO IS
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
      vga_cursor_enable : out std_logic
    );
END controladores_IO;


ARCHITECTURE Structure OF controladores_IO IS

    component driver7display is 
        Port(	CodiCaracter	: in STD_LOGIC_VECTOR(3 DownTo 0);
			    bitsCaracter	: out STD_LOGIC_VECTOR(6 DownTo 0));
    End component;

	 component keyboard_controller is
		Port (clk        : in    STD_LOGIC;
				 reset      : in    STD_LOGIC;
				 ps2_clk    : inout STD_LOGIC;
				 ps2_data   : inout STD_LOGIC;
				 read_char  : out   STD_LOGIC_VECTOR (7 downto 0);
				 clear_char : in    STD_LOGIC;
				 data_ready : out   STD_LOGIC);
		end component;
		
		
    type MemoryStructure is Array (0 to 256) of std_logic_vector(15 downto 0);

    signal portRegisters : MemoryStructure := (others=>(others=>'0'));
    signal addres : integer := 0;
	 
	 signal clear_char : std_LOGIC := '0';
	 signal data_ready : std_LOGIC := '0';
	 signal read_char : std_logic_vector(7 downto 0):= (others=>'0');

BEGIN

keyboardDriver: keyboard_controller
	port map(
		clk => CLOCK_50,
		reset => boot,
		ps2_clk => ps2_clk,
		ps2_data => ps2_data,
		read_char => read_char,
		clear_char => clear_char,
		data_ready => data_ready
	);

driverHex0: driver7display
    port map(
        CodiCaracter => portRegisters(10)(3 downto 0),
        bitsCaracter => HEX0
    );

driverHex1: driver7display
    port map(
        CodiCaracter => portRegisters(10)(7 downto 4),
        bitsCaracter => HEX1
    );

driverHex2: driver7display
    port map(
        CodiCaracter => portRegisters(10)(11 downto 8),
        bitsCaracter => HEX2
    );

driverHex3: driver7display
    port map(
        CodiCaracter => portRegisters(10)(15 downto 12),
        bitsCaracter => HEX3
    );




    addres <= conv_integer(addr_io);    

    process(CLOCK_50, wr_out,addres) is
    begin
        if(rising_edge(CLOCK_50)) then
		  
				portRegisters(7)(3 downto 0) <= key;
				portRegisters(8)(7 downto 0) <= switch;
				
				clear_char <= '0';
				portRegisters(15)(7 downto 0) <= read_char;
				portRegisters(16)(0) <= data_ready;
				
				if(wr_out='1' and addres /= 7 and addres /= 8 and addres /= 16) then
					portRegisters(addres) <= wr_io;
				elsif(wr_out='1' and addres = 16) then
					portRegisters(16) <= (others=>'0');
					clear_char <= '1';
				end if;
        end if;
    end process;

    rd_io <= portRegisters(addres);

    led_rojos <= portRegisters(5)(7 downto 0);
    led_verdes <= portRegisters(6)(7 downto 0);

	 vga_cursor <= portRegisters(11);
	 vga_cursor_enable <= portRegisters(12)(0);


END Structure;
