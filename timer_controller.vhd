library ieee;
USE ieee.std_logic_1164.all;

entity timer_controller is
    port(
		boot: in std_logic;
		clk : in std_logic;
		inta: in std_logic;
		intr: out std_logic
	 );
end entity;

architecture Structure of timer_controller is

	type controller_status is (PASS, ACT);
	signal timer: integer := 0;
	signal status : controller_status := PASS;
	signal timer_limit : integer := 2500000;
begin

process(clk, inta)
begin
	if(rising_edge(clk) and boot='0')then
		timer <= timer+1;
		if(inta='1') then	
			status <= PASS;
		elsif(timer=timer_limit) then
			status <= ACT;
			timer <= 0;
		end if;
	end if;
end process;

with status select
intr <=
	'1' when ACT,
	'0' when others;

	
end Structure;
