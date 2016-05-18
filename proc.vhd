LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY proc IS
    PORT (clk       : IN  STD_LOGIC;
          boot      : IN  STD_LOGIC;
          datard_m  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          addr_m    : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          data_wr   : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          wr_m      : OUT STD_LOGIC;
          word_byte : OUT STD_LOGIC);
END proc;

ARCHITECTURE Structure OF proc IS

    component datapath IS
        PORT (clk      : IN  STD_LOGIC;
              op       : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
              f        : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
              wrd      : IN  STD_LOGIC;
              addr_a   : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
              addr_b   : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
              addr_d   : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
              immed    : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
              immed_x2 : IN  STD_LOGIC;
              datard_m : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
              ins_dad  : IN  STD_LOGIC;
              pc       : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
              in_d     : IN  STD_LOGIC;
              rb_n     : IN  STD_LOGIC;
              addr_m   : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
              data_wr  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
    END component;

    component unidad_control IS
        PORT (boot      : IN  STD_LOGIC;
              clk       : IN  STD_LOGIC;
              datard_m  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
              op        : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
              f         : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
              wrd       : OUT STD_LOGIC;
              addr_a    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
              addr_b    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
              addr_d    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
              immed     : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
              pc        : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
              ins_dad   : OUT STD_LOGIC;
              in_d      : OUT STD_LOGIC;
              immed_x2  : OUT STD_LOGIC;
              rb_n      : OUT STD_LOGIC;
              wr_m      : OUT STD_LOGIC;
              word_byte : OUT STD_LOGIC);
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
    signal in_d : std_logic;

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
        word_byte => word_byte
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
        data_wr => data_wr
    );

-- Aqui iria la declaracion del "mapeo" (PORT MAP) de los nombres de las entradas/salidas de los componentes
    -- En los esquemas de la documentacion a la instancia del DATAPATH le hemos llamado e0 y a la de la unidad de control le hemos llamado c0

END Structure;
