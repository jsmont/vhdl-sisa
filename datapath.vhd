LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY datapath IS
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
END datapath;


ARCHITECTURE Structure OF datapath IS

component alu IS
    PORT (x  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          y  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          op : IN  STD_LOGIC_VECTOR(2 downto 0);
          f  : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
          w  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
END component;

component regfile IS
    PORT (clk    : IN  STD_LOGIC;
          wrd    : IN  STD_LOGIC;
          d      : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          addr_a : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_b : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_d : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
          a      : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          b      : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
END component;
    -- Aqui iria la declaracion de las entidades que vamos a usar
    -- Usaremos la palabra reservada COMPONENT ...
    -- Tambien crearemos los cables/buses (signals) necesarios para unir las entidades

signal d : STD_LOGIC_VECTOR(15 downto 0);
signal b : STD_LOGIC_VECTOR(15 downto 0);
signal x : STD_LOGIC_VECTOR(15 downto 0);
signal w : STD_LOGIC_VECTOR(15 downto 0);
signal y : std_logic_vector(15 downto 0);
signal f_immed: std_logic_vector(15 downto 0);

BEGIN

registers: regfile
	port map(
		clk		=>	clk,
        wrd		=>	wrd,
        d		=>  d,
		addr_a	=>  addr_a,
        addr_b  =>  addr_b,
		addr_d	=>  addr_d,
		a		=>	x,
        b       =>  b
	);

Alu1 :	alu
	port map(
		x			=>	x,
		y			=> y,
		op			=>	op,
        f           => f,
		w			=> w
	);

    -- Select immediate
    with immed_x2 select
    f_immed <= 
        immed(14 downto 0) & '0'    when '1',
        immed                       when others;

    -- Manage y source

    with rb_n select
    y <=
        b when '0',
        f_immed when others;

    -- Manage mem_addr
    with ins_dad select
    addr_m <=
        w   when '1',
        pc  when others;


    -- Manage store data
    data_wr <= b;

    -- Manage d write
    with in_d select
    d <=
        datard_m    when '1',
        w           when others;


    -- Aqui iria la declaracion del "mapeo" (PORT MAP) de los nombres de las entradas/salidas de los componentes
    -- En los esquemas de la documentacion a la instancia del banco de registros le hemos llamado reg0 y a la de la alu le hemos llamado alu0

--    process(addr_a,addr_b,immed,b,y)
--    begin
--        report "Control addr_a:"&integer'image(to_integer(unsigned(addr_a)));
--        report "Control addr_b:"&integer'image(to_integer(unsigned(addr_b)));
--        report "Control immed:"&integer'image(to_integer(unsigned(immed)));
--        report "Control b:"&integer'image(to_integer(unsigned(b)));
--        report "Control y:"&integer'image(to_integer(unsigned(y)));
--        report "Control rb_n:"&std_logic'image(rb_n);
--    end process;


END Structure;
