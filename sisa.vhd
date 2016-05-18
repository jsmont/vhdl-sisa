LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY sisa IS
    PORT (CLOCK_50  : IN    STD_LOGIC;
          SRAM_ADDR : out   std_logic_vector(17 downto 0);
          SRAM_DQ   : inout std_logic_vector(15 downto 0);
          SRAM_UB_N : out   std_logic;
          SRAM_LB_N : out   std_logic;
          SRAM_CE_N : out   std_logic := '1';
          SRAM_OE_N : out   std_logic := '1';
          SRAM_WE_N : out   std_logic := '1';
          SW        : in std_logic_vector(9 downto 9));
END sisa;

ARCHITECTURE Structure OF sisa IS
    component MemoryController is
        port (CLOCK_50  : in  std_logic;
              addr      : in  std_logic_vector(15 downto 0);
              wr_data   : in  std_logic_vector(15 downto 0);
              rd_data   : out std_logic_vector(15 downto 0);
              we        : in  std_logic;
              byte_m    : in  std_logic;
              -- señales para la placa de desarrollo
              SRAM_ADDR : out   std_logic_vector(17 downto 0);
              SRAM_DQ   : inout std_logic_vector(15 downto 0);
              SRAM_UB_N : out   std_logic;
              SRAM_LB_N : out   std_logic;
              SRAM_CE_N : out   std_logic := '1';
              SRAM_OE_N : out   std_logic := '1';
              SRAM_WE_N : out   std_logic := '1');
    end  component;

    component proc IS
        PORT (clk       : IN  STD_LOGIC;
              boot      : IN  STD_LOGIC;
              datard_m  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
              addr_m    : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
              data_wr   : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
              wr_m      : OUT STD_LOGIC;
              word_byte : OUT STD_LOGIC);
    END component;

    signal clk_divider : std_logic_vector(2 downto 0):=(others=>'0');
    
    signal datard_m : std_logic_vector(15 downto 0);
    signal addr_m : std_logic_vector(15 downto 0);
    signal data_wr : std_logic_vector(15 downto 0);
    signal wr : std_logic;
    signal word_byte : std_logic;

BEGIN

    clk_divider <= 
        clk_divider+1 when rising_edge(CLOCK_50)
        else clk_divider;

mem : MemoryController
    port map(
        CLOCK_50  => CLOCK_50,
        addr      => addr_m,
        wr_data   => data_wr,
        rd_data   => datard_m,
        we        => wr,
        byte_m    => word_byte,
        SRAM_ADDR => SRAM_ADDR,
        SRAM_DQ   => SRAM_DQ,
        SRAM_UB_N => SRAM_UB_N,
        SRAM_LB_N => SRAM_LB_N,
        SRAM_CE_N => SRAM_CE_N,
        SRAM_OE_N => SRAM_OE_N,
        SRAM_WE_N => SRAM_WE_N);

processor : proc
    PORT map(
        clk       => clk_divider(2),
        boot      => SW(9),
        datard_m  => datard_m,
        addr_m    => addr_m,
        data_wr   => data_wr,
        wr_m      => wr,
        word_byte => word_byte);
   
END Structure;
