library ieee;
USE ieee.std_logic_1164.all;

entity switch_controller is
    port(
		boot: in std_logic;
		clk : in std_logic;
		inta: in std_logic;
		switches: in std_logic_vector(7 downto 0);
		intr: out std_logic;
		rd_switch: out std_logic_vector(7 downto 0)
	 );
end entity;

architecture Structure of switch_controller is

	type controller_status is (PASS, ACT);
	signal current_switches: std_logic_vector(7 downto 0);
	signal status : controller_status := PASS;
begin

process(clk,switches, inta)
begin
	if(rising_edge(clk))then
		if(inta='1') then	
			status <= PASS;
		elsif(not(switches=current_switches)) then
			status <= ACT;
			current_switches <= switches;
		end if;
	end if;
end process;

with status select
intr <=
	'1' when ACT,
	'0' when others;

rd_switch<=current_switches;
	
end Structure;
