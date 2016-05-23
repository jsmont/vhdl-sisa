library ieee;
USE ieee.std_logic_1164.all;

entity key_controller is
    port(
		boot: in std_logic;
		clk : in std_logic;
		inta: in std_logic;
		keys: in std_logic_vector(3 downto 0);
		intr: out std_logic;
		read_key: out std_logic_vector(3 downto 0)
	 );
end entity;

architecture Structure of key_controller is

	type controller_status is (PASS, ACT);
	signal current_keys: std_logic_vector(3 DOWNTO 0):="0000";
	signal status : controller_status := PASS;
begin

process(clk,keys, inta)
begin
	if(rising_edge(clk))then
		if(inta='1') then	
			status <= PASS;
		elsif(keys/=current_keys) then
			status <= ACT;
			current_keys <= keys;
		end if;
	end if;
end process;

with status select
intr <=
	'1' when ACT,
	'0' when others;

read_key<=current_keys;

end Structure;
