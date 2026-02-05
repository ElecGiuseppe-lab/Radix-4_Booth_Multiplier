library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity CarryGen is
	generic (N: integer:= 8);	-- default value = 8
	port(
			p, g: in std_logic_vector(N-1 downto 0);
			Cin: in std_logic;
			C: out std_logic_vector(N downto 0)
		);
end CarryGen;

architecture Behavioral of CarryGen is

	signal carry: std_logic_vector(N downto 0);
    signal GG, PP: std_logic_vector(N-1 downto 0);

	begin

        carry(0) <= Cin;
		
		-- level 1
		PP(0) <= p(0);
		GG(0) <= g(0);		
    
        forGen_1:	for i in 1 to N-1 generate
						GG(i) <= g(i) or (p(i) and GG(i-1));
						PP(i) <= p(i) and PP(i-1);					
					end generate;
		
		-- final carry dependent only on Cin=C0
		forGen_2:	for i in 0 to N-1 generate
						carry(i+1) <= GG(i) or (PP(i) and carry(0));
					end generate;
					
		C <= carry;					
				
end Behavioral;