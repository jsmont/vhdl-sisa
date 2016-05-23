LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY proc IS
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
          wr_out    : out std_logic
    );
END proc;

ARCHITECTURE Structure OF proc IS

    component datapath IS
        PORT (clk      : IN  STD_LOGIC;
              op       : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
              f        : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
              br_cd    : IN STD_LOGIC_VECTOR(2 downto 0);
              wrd      : IN  STD_LOGIC;
              addr_a   : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
              addr_b   : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
              addr_d   : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
              immed    : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
              immed_x2 : IN  STD_LOGIC;
              datard_m : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
              ins_dad  : IN  STD_LOGIC;
              pc       : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
              in_d     : IN  STD_LOGIC_VECTOR(1 downto 0);
              rb_n     : IN  STD_LOGIC;
              aluout   : OUT  STD_LOGIC_VECTOR(15 downto 0);
              addr_m   : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
              tk_br    : OUT  STD_LOGIC_VECTOR(1 downto 0);
              data_wr  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
              wr_io    : OUT std_logic_vector(15 downto 0);
              rd_io    : IN std_logic_vector(15 downto 0);
              addr_io  : OUT std_logic_vector(15 downto 0);
			 a_sys  : IN std_LOGIC_vector(2 downto 0);
			 int_cycle: in std_LOGIC;
			 pcup   : in std_LOGIC_VECTOR(15 downto 0));
    END component;

    component unidad_control IS
        PORT (boot      : IN  STD_LOGIC;
              clk       : IN  STD_LOGIC;
              datard_m  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
              tk_br     : IN  STD_LOGIC_VECTOR(1 downto 0);
              aluout    : IN  STD_LOGIC_VECTOR(15 downto 0);
              op        : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
              f         : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
              wrd       : OUT STD_LOGIC;
              addr_a    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
              addr_b    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
              addr_d    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
              immed     : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
              pc        : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
              ins_dad   : OUT STD_LOGIC;
              in_d      : OUT STD_LOGIC_VECTOR(1 downto 0);
              immed_x2  : OUT STD_LOGIC;
              rb_n      : OUT STD_LOGIC;
              wr_m      : OUT STD_LOGIC;
              br_cd     : OUT STD_LOGIC_VECTOR(2 downto 0);
              word_byte : OUT STD_LOGIC;
              rd_in     : out std_logic;
              wr_out    : out std_logic;
				  a_sys  : out std_LOGIC_vector(2 downto 0);
				  int_cycle: out std_LOGIC;
				  pcup   : out std_LOGIC_VECTOR(15 downto 0));
    END component;

    signal op : STD_LOGIC_VECTOR(2 downto 0);
    signal f : STD_LOGIC_VECTOR(2 downto 0);
    signal wrd : std_logic;
    signal addr_a : std_logic_vector(2 downto 0);
    signal addr_b : std_logic_vector(2 downto 0);
    signal addr_d : std_logic_vector(2 downto 0);
    signal immed : std_logic_vector(15 downto 0);
    signal immed_x2 : std_logic;
    signal ins_dad : std_logic;
    signal rb_n : std_logic;
    signal pc : std_logic_vector(15 downto 0);
    signal in_d : std_logic_vector(1 downto 0);
    signal aluout : STD_LOGIC_VECTOR(15 downto 0);
    signal tk_br : STD_LOGIC_VECTOR(1 downto 0);
    signal br_cd : STD_LOGIC_VECTOR(2 downto 0); 
	 signal a_sys  : std_LOGIC_vector(2 downto 0);
	 signal int_cycle: std_LOGIC;
	 signal pcup   : std_LOGIC_VECTOR(15 downto 0);
BEGIN

control: unidad_control
    port map(
        boot => boot,
        clk => clk,
        datard_m => datard_m,
        op => op,
        f => f,
        wrd => wrd,
        addr_a => addr_a,
        addr_b => addr_b,
        addr_d => addr_d,
        immed => immed,
        pc => pc,
        ins_dad => ins_dad,
        in_d => in_d,
        immed_x2 => immed_x2,
        wr_m => wr_m,
        rb_n => rb_n,
        word_byte => word_byte,
        aluout => aluout,
        tk_br => tk_br,
        br_cd => br_cd,
        rd_in => rd_in,
        wr_out => wr_out,
		  a_sys => a_sys,
		  int_cycle => int_cycle,
		  pcup => pcup
    );


datap: datapath
    port map(
        clk => clk,
        op => op,
        f => f,
        wrd => wrd,
        addr_a => addr_a,
        addr_b => addr_b,
        addr_d => addr_d,
        immed => immed,
        immed_x2 => immed_x2,
        datard_m => datard_m,
        ins_dad => ins_dad,
        pc => pc,
        rb_n => rb_n,
        in_d => in_d,
        addr_m => addr_m,
        data_wr => data_wr,
        aluout => aluout,
        tk_br => tk_br,
        br_cd => br_cd,
        addr_io => addr_io,
        wr_io => wr_io,
        rd_io => rd_io,
		  a_sys => a_sys,
		  int_cycle => int_cycle,
		  pcup => pcup
    );

-- Aqui iria la declaracion del "mapeo" (PORT MAP) de los nombres de las entradas/salidas de los componentes
    -- En los esquemas de la documentacion a la instancia del DATAPATH le hemos llamado e0 y a la de la unidad de control le hemos llamado c0

END Structure;
