LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_unsigned.all;

ENTITY unidad_control IS
    PORT (boot   : IN  STD_LOGIC;
          clk    : IN  STD_LOGIC;
          ir     : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          op     : OUT STD_LOGIC;
          wrd    : OUT STD_LOGIC;
          addr_a : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_d : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
          immed  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          pc     : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
END unidad_control;

ARCHITECTURE Structure OF unidad_control IS


	component control_l IS
		PORT (ir     : IN  STD_LOGIC_VECTOR(15 DOWNTO 0); -- Instruccion
          op     : OUT STD_LOGIC; -- Op que usará la Alu
          ldpc   : OUT STD_LOGIC; -- if(ldpc==1) ++pc; only 0 when halt
          wrd    : OUT STD_LOGIC; -- Permiso de escritura
          addr_a : OUT STD_LOGIC_VECTOR(2 DOWNTO 0); -- Dir registro fuente
          addr_d : OUT STD_LOGIC_VECTOR(2 DOWNTO 0); -- Dir registro destino
          immed  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)); -- Immediato
	END component;
    -- Aqui iria la declaracion de las entidades que vamos a usar
    -- Usaremos la palabra reservada COMPONENT ...
    -- Tambien crearemos los cables/buses (signals) necesarios para unir las entidades
    -- Aqui iria la definicion del program counter

	signal ldpc : std_LOGIC := '1';
	signal n_pc : std_LOGIC_VECTOR(15 downto 0);
	signal new_pc : std_LOGIC_VECTOR(15 downto 0);
BEGIN

control_logic :  control_l
	port map(
		ir => ir,
		op => op,
		ldpc => ldpc,
		wrd => wrd,
		addr_a => addr_a,
		addr_d => addr_d,
		immed => immed
	);
	
	n_pc <=
		"1100000000000000" when boot='1'
		else new_pc when ldpc='0'
		else std_logic_vector(to_unsigned(to_integer(unsigned( new_pc )) + 2, 16));
		
	new_pc <=
		n_pc when rising_edge(clk)
		else new_pc;
		
	pc <= new_pc;

    -- Aqui iria la declaracion del "mapeo" (PORT MAP) de los nombres de las entradas/salidas de los componentes
    -- En los esquemas de la documentacion a la instancia de la logica de control le hemos llamado c0
    -- Aqui iria la definicion del comportamiento de la unidad de control y la gestion del PC

END Structure;
