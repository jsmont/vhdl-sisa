library ieee;
USE ieee.std_logic_1164.all;

entity multi is
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
         word_byte : OUT STD_LOGIC;
			int_cycle: out std_LOGIC;
			intr : in std_logic;
			enable_int: in std_LOGIC);
end entity;

architecture Structure of multi is

    -- Aqui iria la declaracion de las los estados de la maquina de estados

    type cycle_status is (FETCH, DEMW, SYS);

    signal state : cycle_status;
    signal next_state : cycle_status;

begin

    -- Gesti�n de estados

	 with state select
	 int_cycle <=
		'1' when SYS,
		'0' when others;
	 
    state <=
        next_state when rising_edge(clk)
        else state;
    

    next_state <=
        FETCH when boot='1'
		  else SYS when state=DEMW and intr='1' and enable_int='1'
        else DEMW when state=FETCH
        else FETCH;

    -- Gesti�n de salidas

    with state select
    ldpc <=
        ldpc_1 when DEMW,
		  ldpc_1 when SYS,
        '0' when others;
    
    with state select
    wrd <=
        wrd_1 when DEMW,
        '0' when others;

    with state select
    wr_m <=
        wr_m_1 when DEMW,
        '0' when others;

    with state select
    word_byte <=
       w_b when DEMW,
       '0' when others;

    with state select
    ins_dad <=
        '1' when DEMW,
        '0' when others;

    ldir <=
        '1' when state=FETCH
        else '0';



end Structure;
