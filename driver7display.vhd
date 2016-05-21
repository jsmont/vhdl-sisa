LIBRARY ieee;
USE ieee.std_logic_1164.all;

Entity driver7display is
	Port(	CodiCaracter	: in STD_LOGIC_VECTOR(3 DownTo 0);
			bitsCaracter	: out STD_LOGIC_VECTOR(6 DownTo 0));
End driver7display;

Architecture Structure of driver7display is
begin
	with CodiCaracter select
		bitsCaracter <= "1000000" when "0000",
					"1111001" when "0001",
					"0100100" when "0010",
					"0110000" when "0011",
					"0011001" when "0100",
					"0010010" when "0101",
					"0000010" when "0110",
					"1111000" when "0111",
					"0000000" when "1000",
					"0011000" when "1001",
					"0001000" when "1010",
					"0000011" when "1011",
					"1000110" when "1100",
					"0100001" when "1101",
					"0000110" when "1110",
					"0001110" when others;
end Structure;
