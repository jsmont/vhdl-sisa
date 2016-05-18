LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY control_l IS
    PORT (ir     : IN  STD_LOGIC_VECTOR(15 DOWNTO 0); -- Instruccion
          op     : OUT STD_LOGIC; -- Op que usará la Alu
          ldpc   : OUT STD_LOGIC; -- if(ldpc==1) ++pc; only 0 when halt
          wrd    : OUT STD_LOGIC; -- Permiso de escritura
          addr_a : OUT STD_LOGIC_VECTOR(2 DOWNTO 0); -- Dir registro fuente
          addr_d : OUT STD_LOGIC_VECTOR(2 DOWNTO 0); -- Dir registro destino
          immed  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)); -- Immediato
END control_l;


ARCHITECTURE Structure OF control_l IS
BEGIN

	
    -- Aqui iria la generacion de las senales de control del datapath
	
	op <= ir(8);
	 
	ldpc <= 
		'0' when ir="1111111111111111"
		else '1';
	
	with ir(15 downto 12) select
	wrd <= 
		'1' when "0101",
		'0' when others;
	
	addr_a <= ir(11 downto 9);
	addr_d <= ir(11 downto 9);
		
	immed <= std_logic_vector(resize(signed(ir(7 downto 0)), immed'length));

END Structure;