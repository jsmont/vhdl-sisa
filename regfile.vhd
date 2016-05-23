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
			 pcup   : in std_LOGIC_VECTOR(15 downto 0);
			 enable_int: out std_LOGIC);
END regfile;

ARCHITECTURE Structure OF regfile IS
			
   type MemoryStructure is Array (0 to 7) of std_logic_vector(15 downto 0);

   signal mem : MemoryStructure := (others=>(others=>'0'));
   signal system_mem : MemoryStructure := (others=>(others=>'0'));
	signal int_a : std_LOGIC_VECTOR(15 downto 0);
BEGIN
	
	with int_cycle select
	a <= 
		system_mem(5) when '1',
		int_a when others;
	
	with a_sys select
	int_a <= 
		mem( conv_integer(addr_a) ) when "000",
		mem( conv_integer(addr_a)) when "010",
		system_mem(1) when "011",
		system_mem(conv_integer(addr_a)) when others;
		
	b <= mem( conv_integer(addr_b) );
	
	enable_int <= system_mem(7)(1);

   process(clk, wrd) is
	begin
		if (rising_edge(clk) and int_cycle='1') then
			system_mem(0) <= system_mem(7);
			system_mem(1) <= pcup;
			system_mem(2) <= "0000000000001111";
			system_mem(7)(1) <= '0';
		elsif(rising_edge(clk) and wrd='1' and a_sys(1)='0' and int_cycle='0') then
				mem(conv_integer(addr_d))<= d;
		elsif (rising_edge(clk) and wrd='1' and a_sys(1)='1' and int_cycle='0') then
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
