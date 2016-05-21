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
      HEX3      : out   std_logic_vector(6 downto 0)
    );
END controladores_IO;


ARCHITECTURE Structure OF controladores_IO IS

    component driver7display is 
        Port(	CodiCaracter	: in STD_LOGIC_VECTOR(3 DownTo 0);
			    bitsCaracter	: out STD_LOGIC_VECTOR(6 DownTo 0));
    End component;


    type MemoryStructure is Array (0 to 256) of std_logic_vector(15 downto 0);

    signal portRegisters : MemoryStructure := (others=>(others=>'0'));
    signal addres : integer := 0;
BEGIN

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
				if(wr_out='1' and addres /= 7 and addres /= 8) then
					portRegisters(addres) <= wr_io;
				else
					portRegisters(7)(3 downto 0) <= key;
					portRegisters(8)(7 downto 0) <= switch;
				end if;
        end if;
    end process;

    rd_io <= portRegisters(addres);

    led_rojos <= portRegisters(5)(7 downto 0);
    led_verdes <= portRegisters(6)(7 downto 0);



END Structure;
