LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY control_l IS
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
END control_l;


ARCHITECTURE Structure OF control_l IS
BEGIN

    ldpc <= 
           '0' when ir="1111111111111111"
            else '1';
    
    -- Select op for alu 
    with ir(15 downto 12) select
    op <= 
        '0' & ir(8) when "0101",
        "10" when others;

    -- Set up write permissions

    with ir(15 downto 12) select
    wrd <=
        '1' when "0101",
        '1' when "0011",
        '1' when "1101",
        '0' when others;

    -- Setup addr_a
    with ir(15 downto 12) select
    addr_a <=
        ir(11 downto 9)     when "0101",
        ir(8 downto 6)      when others;
    

    --Setup addr_b
    with ir(15 downto 12) select
    addr_b <=
       ir(11 downto 9)      when "0100",
       ir(11 downto 9)      when "1110",
       (others=>'0')        when others;


    --Setup addr_d
    with ir(15 downto 12) select
    addr_d <=
        ir(11 downto 9)     when "0011",
        ir(11 downto 9)     when "1101",
        ir(11 downto 9)     when "0101",
        (others=>'0')       when others;

    -- Setup immed
    with ir(15 downto 12) select
    immed <=
       std_logic_vector(resize(signed(ir(7 downto 0)), immed'length)) when "0101",
       std_logic_vector(resize(signed(ir(5 downto 0)), immed'length)) when "0011",
       std_logic_vector(resize(signed(ir(5 downto 0)), immed'length)) when "0100",
       std_logic_vector(resize(signed(ir(5 downto 0)), immed'length)) when "1101",
       std_logic_vector(resize(signed(ir(5 downto 0)), immed'length)) when "1110",
       (others=>'0') when others;
    
    -- Setup Write memory permissions
    with ir(15 downto 12) select
    wr_m <=
        '1' when "0100",
        '1' when "1110",
        '0' when others;

    -- Setup regiser's D origin
    with ir(15 downto 12) select
    in_d <=
        '1' when "0011",
        '1' when "1101",
        '0' when others;
    
    -- Setup immediate format
    with ir(15 downto 12) select
    immed_x2 <=
        '1' when "0011",
        '1' when "0100",
        '0' when others;
   
    -- Setup access size
    with ir(15 downto 12) select
    word_byte <=
        '1' when "1101",
        '1' when "1110",
        '0' when others;

    -- Aqui iria la generacion de las senales de control del datapath

END Structure;
