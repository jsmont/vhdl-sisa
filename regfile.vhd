LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all; --Esta libreria sera necesaria si usais conversiones CONV_INTEGER
USE ieee.numeric_std.all;        --Esta libreria sera necesaria si usais conversiones TO_INTEGER

ENTITY regfile IS
    PORT (clk    : IN  STD_LOGIC;
          wrd    : IN  STD_LOGIC;
          d      : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          addr_a : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_b : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_d : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
          a      : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          b      : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
END regfile;

ARCHITECTURE Structure OF regfile IS
	type register_array is array (0 to 7) of std_logic_vector(15 downto 0);
	signal mem : register_array := ((others=>'0'),(others=>'0'),(others=>'0'),
		(others=>'0'),(others=>'0'),(others=>'0'),(others=>'0'),(others=>'0'));
BEGIN
	
	a <= mem( conv_integer(addr_a) );
	b <= mem( conv_integer(addr_b) );

   process(clk, wrd) is
	begin
		if(rising_edge(clk) and wrd='1') then
				mem(conv_integer(addr_d))<= d;
		end if;
	end process;
    -- Aqui iria la definicion del comportamiento del banco de registros
    -- Os puede ser util usar la funcion "conv_integer" o "to_integer"
    -- Una buena (y limpia) implementacion no deberia ocupar m�s de 7 o 8 lineas

END Structure;
