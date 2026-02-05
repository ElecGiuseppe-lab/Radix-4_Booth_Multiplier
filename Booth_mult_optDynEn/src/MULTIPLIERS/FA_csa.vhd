library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity FA_CSA is
	port(
			A, B, Cin : in std_logic;
			Sum, Cout: out std_logic
		);
end FA_CSA;

architecture Behavioral of FA_CSA is

	begin

        Sum <= A xor B xor Cin;
        Cout <= (A and B) or (A and Cin) or (B and Cin);
	
end Behavioral;