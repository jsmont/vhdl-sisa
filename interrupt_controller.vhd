library ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;

entity interrupt_controller is
    port(
		boot: in std_logic;
		clk : in std_logic;
		inta: in std_logic;
		key_intr: in std_logic;
		ps2_intr: in std_logic;
		switch_intr: in std_logic;
		timer_intr: in std_logic;
		intr: out std_logic;
		key_inta: out std_logic;
		ps2_inta: out std_logic;
		switch_inta: out std_logic;
		timer_inta: out std_logic;
		iid: out std_logic_vector(7 downto 0)
	 );
end entity;

architecture Structure of interrupt_controller is

	signal timer_iid:integer:=0;
	signal key_iid:integer:=1;
	signal switch_iid:integer:=2;
	signal ps2_iid:integer:=3;

begin

process(clk, inta)
begin
	if(rising_edge(clk))then
		if(inta='1') then
			if(timer_intr='1') then
				timer_inta <= '1';
				iid <= std_logic_vector(to_signed(timer_iid,8));
			elsif(key_intr='1') then
				key_inta <= '1';
				iid <= std_logic_vector(to_signed(key_iid,8));
			elsif(switch_intr='1') then
				switch_inta <= '1';
				iid <= std_logic_vector(to_signed(switch_iid,8));
			elsif(ps2_intr='1') then
				ps2_inta <= '1';
				iid <= std_logic_vector(to_signed(ps2_iid,8));
			end if;
		else
			timer_inta <= '0';
			key_inta <= '0';
			switch_inta <= '0';
			ps2_inta <= '0';
		end if;
	END IF;
end process;


intr <= key_intr or switch_intr or timer_intr or ps2_intr;
	
end Structure;
