library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity FA_CLA is
	port(
			A, B, Cin:in std_logic;
			S, p, g:out std_logic
		);
end FA_CLA;

architecture Behavioral of FA_CLA is
    
    begin
    
        p <= A xor B;
        g <= A and B;
		S <= A xor B xor Cin;		
              
end Behavioral;