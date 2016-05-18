LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;

ENTITY alu IS
    PORT (x  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          y  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          op : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
          f  : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
          z  : OUT STD_LOGIC;
          w  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
END alu;


ARCHITECTURE Structure OF alu IS
    signal selector: std_logic_vector(5 downto 0);
    signal extra_op: std_logic_vector(31 downto 0);

    signal div_y: std_logic_vector(15 downto 0);

    function to_stdlogic( V: Boolean ) return std_logic is 
    begin 
        return std_logic'Val(Boolean'Pos(V)+2); 
    end to_stdlogic; 
BEGIN

    selector <= op&f;

    with selector select
	w <= 
		y                               when "011000", -- Movi
		y(7 downto 0) & x(7 downto 0)   when "011001", -- Movhi
        x and y                         when "000000", -- And
        x or y                          when "000001", -- Or
        x xor y                         when "000010", -- Xor
        not x                           when "000011", -- Not
        std_logic_vector(to_signed(to_integer(signed(x))+to_integer(signed(y)),16))     when "000100", -- Add
        std_logic_vector(to_signed(to_integer(signed(x))-to_integer(signed(y)),16))     when "000101", -- Sub
        to_stdlogicvector(to_bitvector(x) sla to_integer(signed(y)))                    when "000110", -- SHA
        std_logic_vector(unsigned(x) sll to_integer(signed(y)))                         when "000111", -- SHL
        "000000000000000"&to_stdlogic(signed(x) < signed(y))        when "001000", -- Cmplt         
        "000000000000000"&to_stdlogic(signed(x) <= signed(y))       when "001001", -- Cmple
        "000000000000000"&to_stdlogic(signed(x)=signed(y))          when "001011", -- Cmpeq
        "000000000000000"&to_stdlogic(unsigned(x)<unsigned(y))      when "001100", -- Cmpltu
        "000000000000000"&to_stdlogic(unsigned(x) <= unsigned(y))   when "001101", -- Cmpleu
        extra_op(15 downto 0)           when "010000", -- Mul
        extra_op(31 downto 16)          when "010001", -- Mulh
        extra_op(31 downto 16)          when "010010", -- Mulhu
        extra_op(15 downto 0)           when "010100", -- Div
        extra_op(15 downto 0)           when "010101", -- Divu
		x when others;

    -- Z signal

    z <= to_stdlogic(unsigned(y)=0);

    -- Remove divisions by 0 on transition states so simulation doesn't crash

    with y select
    div_y <=
        "0000000000000001" when "0000000000000000",
        y when others; 


    -- We operate in 32 bytes
    with selector select
    extra_op <=
        std_logic_vector(signed(x)*signed(y)) when "010000", -- Mul
        std_logic_vector(signed(x)*signed(y))  when "010001", -- Mulh
        std_logic_vector(unsigned(x)*unsigned(y))  when "010010", -- Mulhu
        std_logic_vector(to_signed(to_integer(signed(x))/to_integer(signed(div_y)),32)) when "010100", -- Div
        std_logic_vector(to_unsigned(to_integer(unsigned(x))/to_integer(unsigned(div_y)),32)) when "010101", -- Divu
        (others=>'0') when others;
    
--    process(x,y)
--    begin
--        report "OP command:"&integer'image(to_integer(unsigned(selector)));
--        report "OP x:"&integer'image(to_integer(signed(x)));
--        report "OP y:"&integer'image(to_integer(signed(y)));
--        report "OP div_y:"&integer'image(to_integer(signed(div_y)));
--    end process;


END Structure;
