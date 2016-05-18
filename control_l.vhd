LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY control_l IS
    PORT (ir        : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          op        : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
          f         : OUT STD_LOGIC_VECTOR(2 downto 0);
          ldpc      : OUT STD_LOGIC;
          wrd       : OUT STD_LOGIC;
          addr_a    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_b    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_d    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
          immed     : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          wr_m      : OUT STD_LOGIC;
          in_d      : OUT STD_LOGIC_VECTOR(1 downto 0);
          immed_x2  : OUT STD_LOGIC;
          word_byte : OUT STD_LOGIC;
          rb_n      : OUT STD_LOGIC;
          br_cd     : OUT STD_LOGIC_VECTOR(2 downto 0));
END control_l;


ARCHITECTURE Structure OF control_l IS
    function to_stdlogic( V: Boolean ) return std_logic is 
    begin 
        return std_logic'Val(Boolean'Pos(V)+2);
    end to_stdlogic;
BEGIN

    ldpc <= 
           '0' when ir="1111111111111111"
            else '1';
    
    -- Select op for alu 
    with ir(15 downto 12) select
    op <= 
        "000"   when "0000", -- Arithmetic
        "001"   when "0001", -- Comparations
        "000"   when "0010", -- Addi
        "010"   when "1000", -- Extra
        "011"   when "0101", -- Movi Movhi
        "000"   when "0011", -- Load
        "000"   when "0100", -- Store
        "000"   when "1101", -- Load byte
        "000"   when "1110", -- Store byte
        "000"   when "0110", -- Bz Bnz
        "000"   when "1010", -- Other jumps
        "111"   when others;

    -- Setup function
    with ir(15 downto 12) select
    f <=
        "00"&ir(8)  when "0101", -- Movi movhi
        "100"       when "0010", -- Addi
        "100"       when "0011", -- Load
        "100"       when "0100", -- Store
        "100"       when "1101", -- Load byte
        "100"       when "1110", -- Store byte
        "000"       when "0110", -- Bz Bnz
        "000"       when "1010", -- Other jumps
        ir(5 downto 3) when others; -- Others

    -- Setup y input source

    with ir(15 downto 12) select
    rb_n <=
        '1'     when "0010", -- Addi
        '1'     when "0101", -- Movi Movhi
        '1'     when "0011", -- Load
        '1'     when "0100", -- Store
        '1'     when "1101", -- Load byte
        '1'     when "1110", -- Store byte
        '0'     when others; -- Others.

    -- Set up write permissions

    with ir(15 downto 12) select
    wrd <=
        '0'     when "0100", -- Store
        '0'     when "1110", -- Store byte
        '0'     when "0110", -- Bz Bnz
        to_stdlogic(ir(2 downto 0)="100") when "1010", -- Other jumps, all '0' but JAL
        '1'     when others; -- Else

    -- Setup addr_a
    with ir(15 downto 12) select
    addr_a <=
        ir(11 downto 9)     when "0101", -- Movi Movhi
        ir(8 downto 6)      when others; -- Non special ones
    

    --Setup addr_b
    with ir(15 downto 12) select
    addr_b <=
       ir(11 downto 9)      when "0100", -- Store
       ir(11 downto 9)      when "1110", -- Store byte
       ir(11 downto 9)      when "0110", -- Bz Bnz
       ir(11 downto 9)      when "1010", -- Other jumps
       ir(2 downto 0)       when "0000", -- Arithmetic
       ir(2 downto 0)       when "0001", -- Comparation
       ir(2 downto 0)       when "1000", -- Mul and Div
       (others=>'0')        when others;


    --Setup addr_d
    addr_d <= ir(11 downto 9); -- No one uses a different one

    -- Setup immed
    with ir(15 downto 12) select
    immed <=
       std_logic_vector(resize(signed(ir(7 downto 0)), immed'length)) when "0101", -- Movi Movhi
       std_logic_vector(resize(signed(ir(7 downto 0)), immed'length)) when "0110", -- Bz Bnz
       std_logic_vector(resize(signed(ir(5 downto 0)), immed'length)) when "0011", -- Load
       std_logic_vector(resize(signed(ir(5 downto 0)), immed'length)) when "0100", -- Store
       std_logic_vector(resize(signed(ir(5 downto 0)), immed'length)) when "1101", -- Load byte
       std_logic_vector(resize(signed(ir(5 downto 0)), immed'length)) when "1110", -- Store byte
       std_logic_vector(resize(signed(ir(5 downto 0)), immed'length)) when "0010", -- Addi
       (others=>'1') when others; -- Don't need immediate
    
    -- Setup Write memory permissions
    with ir(15 downto 12) select
    wr_m <=
        '1' when "0100", -- Store
        '1' when "1110", -- Store byte
        '0' when others; -- Others

    -- Setup regiser's D origin
    with ir(15 downto 12) select
    in_d <=
        "01" when "0011", -- Load
        "01" when "1101", -- Load byte
        "10" when "1010", -- Jal
        "00" when others; -- Others
    
    -- Setup immediate format
    with ir(15 downto 12) select
    immed_x2 <=
        '1' when "0011", -- Load
        '1' when "0100", -- Store
        '0' when others;
   
    -- Setup access size
    with ir(15 downto 12) select
    word_byte <=
        '1' when "1101", -- Load byte
        '1' when "1110", -- Store byte
        '0' when others;


    -- Setup branch code
    with ir(15 downto 12) select
    br_cd <=
        ir(2 downto 0) when "1010", -- Other jumps
        ir(8)&not(ir(8))&ir(8) when "0110", -- Bz (010) Bnz (101)
        "110" when others; -- No jump

    -- Aqui iria la generacion de las senales de control del datapath



END Structure;
