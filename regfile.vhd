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
          b      : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			 a_sys  : IN std_LOGIC_vector(2 downto 0);
			 int_cycle: in std_LOGIC;
			 pcup   : in std_LOGIC_VECTOR(15 downto 0));
END regfile;

ARCHITECTURE Structure OF regfile IS
			
   type MemoryStructure is Array (0 to 7) of std_logic_vector(15 downto 0);

   signal mem : MemoryStructure := (others=>(others=>'0'));
   signal system_mem : MemoryStructure := (others=>(others=>'0'));
	signal int_pc : std_LOGIC_VECTOR(15 downto 0);
	
BEGIN
	
	with int_cycle select
	int_pc <= 
		system_mem(1) when '0',
		system_mem(5) when others;
	
	with a_sys select
	a <= 
		mem( conv_integer(addr_a) ) when "000",
		mem( conv_integer(addr_a)) when "010",
		int_pc when "011",
		system_mem(conv_integer(addr_a)) when others;
		
	b <= mem( conv_integer(addr_b) );

   process(clk, wrd) is
	begin
		if(rising_edge(clk) and wrd='1' and a_sys(1)='0') then
				mem(conv_integer(addr_d))<= d;
		elsif (rising_edge(clk) and wrd='1' and a_sys(1)='1') then
				if(a_sys = "011") then
					system_mem(7) <= system_mem(0);
				else 
					system_mem(conv_integer(addr_d)) <= d;
				end if;
		end if;
	end process;
    -- Aqui iria la definicion del comportamiento del banco de registros
    -- Os puede ser util usar la funcion "conv_integer" o "to_integer"
    -- Una buena (y limpia) implementacion no deberia ocupar m�s de 7 o 8 lineas

END Structure;
