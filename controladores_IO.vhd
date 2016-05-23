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
      vga_cursor_enable : out std_logic;
		intr : out std_logic
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
		
		component timer_controller is
			 port(
				boot: in std_logic;
				clk : in std_logic;
				inta: in std_logic;
				intr: out std_logic
			 );
		end component;
		
		component key_controller is
		 port(
			boot: in std_logic;
			clk : in std_logic;
			inta: in std_logic;
			keys: in std_logic_vector(3 downto 0);
			intr: out std_logic;
			read_key: out std_logic_vector(3 downto 0)
		 );
		 end component;
		 
		 component switch_controller is
		 port(
			boot: in std_logic;
			clk : in std_logic;
			inta: in std_logic;
			switches: in std_logic_vector(7 downto 0);
			intr: out std_logic;
			rd_switch: out std_logic_vector(7 downto 0)
		 );
		 end component;
		 
		 component interrupt_controller is
		 port(
			boot: in std_logic;
			clk : in std_logic;
			inta: in std_logic;
			key_intr: in std_logic;
			ps2_intr: in std_logic;
			switch_intr: in std_logic;
			timer_intr: in std_logic;
			intr: out std_logic;
			key_inta: out std_logic;
			ps2_inta: out std_logic;
			switch_inta: out std_logic;
			timer_inta: out std_logic;
			iid: out std_logic_vector(7 downto 0)
		 );
		 end component;
		
    type MemoryStructure is Array (0 to 256) of std_logic_vector(15 downto 0);

    signal portRegisters : MemoryStructure := (others=>(others=>'0'));
    signal addres : integer := 0;
	 
	 signal read_char : std_logic_vector(7 downto 0):= (others=>'0');
    signal inta: std_logic;
	 signal key_intr: std_logic;
	 signal ps2_intr: std_logic;
	 signal switch_intr: std_logic;
	 signal timer_intr: std_logic;
	 signal key_inta:  std_logic;
	 signal ps2_inta:  std_logic;
	 signal switch_inta:  std_logic;
	 signal timer_inta:  std_logic;
	 signal iid: std_logic_vector(7 downto 0);
	 signal read_key : std_LOGIC_VECTOR(3 downto 0);
	 signal read_switch : std_LOGIC_VECTOR(7 downto 0);
BEGIN

Interrupt_driver : Interrupt_controller
	port map(
		boot=> boot,
		clk => CLOCK_50,
		intr => intr,
		inta => inta,
		iid => iid,
		timer_intr => timer_intr,
		timer_inta => timer_inta,
		key_intr => key_intr,
		key_inta => key_inta,
		switch_intr => switch_intr,
		switch_inta => switch_inta,
		ps2_intr => ps2_intr,
		ps2_inta => ps2_inta
	);

keyboardDriver: keyboard_controller
	port map(
		clk => CLOCK_50,
		reset => boot,
		ps2_clk => ps2_clk,
		ps2_data => ps2_data,
		read_char => read_char,
		clear_char => ps2_inta,
		data_ready => ps2_intr
	);

timer_driver: timer_controller
	port map(
		boot => boot,
		clk => CLOCK_50,
		intr => timer_intr,
		inta => timer_inta
	);

key_driver: key_controller
	port map(
		boot => boot,
		clk => CLOCK_50,
		intr => key_intr,
		inta => key_inta,
		keys => key,
		read_key => read_key
	);

switch_driver : switch_controller
	port map(
		boot => boot,
		clk => CLOCK_50,
		intr => switch_intr,
		inta => switch_inta,
		switches => switch,
		rd_switch => read_switch
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
		  
				portRegisters(7)(3 downto 0) <= read_key;
				portRegisters(8)(7 downto 0) <= read_switch;
				portRegisters(15)(7 downto 0) <= read_char;
				portRegisters(0)(7 downto 0) <= iid;
				
				if(wr_out='1' and addres/=0 and addres /= 7 and addres /= 8 and addres /= 16) then
					portRegisters(addres) <= wr_io;
				elsif(wr_out='1' and addres = 16) then
					portRegisters(16) <= (others=>'0');
				end if;
				
				if(addres=0 and rd_in='1') then
					inta <= '1';
				else 
					inta <= '0';
				end if;
        end if;
    end process;

    rd_io <= portRegisters(addres);

    led_rojos <= portRegisters(5)(7 downto 0);
    led_verdes <= portRegisters(6)(7 downto 0);

	 vga_cursor <= portRegisters(11);
	 vga_cursor_enable <= portRegisters(12)(0);


END Structure;
