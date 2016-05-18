LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_unsigned.all;

ENTITY unidad_control IS
    PORT (boot      : IN  STD_LOGIC;
          clk       : IN  STD_LOGIC;
          datard_m  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          op        : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
          wrd       : OUT STD_LOGIC;
          addr_a    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_b    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_d    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
          immed     : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          pc        : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          ins_dad   : OUT STD_LOGIC;
          in_d      : OUT STD_LOGIC;
          immed_x2  : OUT STD_LOGIC;
          wr_m      : OUT STD_LOGIC;
          word_byte : OUT STD_LOGIC);
END unidad_control;


ARCHITECTURE Structure OF unidad_control IS

    component control_l IS
        PORT (ir        : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
              op        : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
              ldpc      : OUT STD_LOGIC;
              wrd       : OUT STD_LOGIC;
              addr_a    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
              addr_b    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
              addr_d    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
              immed     : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
              wr_m      : OUT STD_LOGIC;
              in_d      : OUT STD_LOGIC;
              immed_x2  : OUT STD_LOGIC;
              word_byte : OUT STD_LOGIC);
    END component;

    component multi is
        port(clk       : IN  STD_LOGIC;
             boot      : IN  STD_LOGIC;
             ldpc_1    : IN  STD_LOGIC;
             wrd_1     : IN  STD_LOGIC;
             wr_m_1    : IN  STD_LOGIC;
             w_b       : IN  STD_LOGIC;
             ldpc      : OUT STD_LOGIC;
             wrd       : OUT STD_LOGIC;
             wr_m      : OUT STD_LOGIC;
             ldir      : OUT STD_LOGIC;
             ins_dad   : OUT STD_LOGIC;
             word_byte : OUT STD_LOGIC);
    end component;
    -- Aqui iria la declaracion de las entidades que vamos a usar
    -- Tambien crearemos los cables/buses (signals) necesarios para unir las entidades
    -- Aqui iria la definicion del program counter y del registro IR

    signal ldpc : std_LOGIC := '1';
    signal ldpc_1 : std_LOGIC := '1';
    signal wrd_1 : std_Logic;
    signal wr_m_1: std_Logic;
    signal w_b: std_Logic;
	signal n_pc : std_LOGIC_VECTOR(15 downto 0);
	signal new_pc : std_LOGIC_VECTOR(15 downto 0);
    signal ldir : std_Logic;

    signal ir : std_logic_vector(15 downto 0):=(others=>'0');
    signal n_ir : std_logic_vector(15 downto 0):=(others=>'0');
BEGIN

control_logic :  control_l
	port map(
		ir => ir,
		op => op,
		ldpc => ldpc_1,
		wrd => wrd_1,
		addr_a => addr_a,
        addr_b => addr_b,
		addr_d => addr_d,
		immed => immed,
        wr_m => wr_m_1,
        in_d => in_d,
        immed_x2 => immed_x2,
        word_byte => w_b
	);

multi_cycle: multi
    port map(
        clk => clk,
        boot => boot,
        ldpc_1 => ldpc_1,
        wrd_1 => wrd_1,
        wr_m_1 => wr_m_1,
        w_b => w_b,
        ldpc => ldpc,
        wrd => wrd,
        wr_m => wr_m,
        ldir => ldir,
        ins_dad => ins_dad,
        word_byte => word_byte
    );
	
	n_pc <=
		"1100000000000000" when boot='1'
		else new_pc when ldpc='0'
		else std_logic_vector(to_unsigned(to_integer(unsigned( new_pc )) + 2, 16));
		
	new_pc <=
		n_pc when rising_edge(clk)
		else new_pc;
		
	pc <= new_pc;

    ir <=
        n_ir when ldir='1'
        else ir;
    
    n_ir <=
        (others=>'0') when boot='1'
        else datard_m;

    -- Aqui iria la declaracion del "mapeo" (PORT MAP) de los nombres de las entradas/salidas de los componentes
    -- En los esquemas de la documentacion a la instancia de la logica de control le hemos llamado c0
    -- Aqui iria la definicion del comportamiento de la unidad de control y la gestion del PC

END Structure;
