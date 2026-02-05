library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity CLA_adder is
	generic (WidthCLA: integer:= 8);	-- default value = 8
	port(
			A,B:in std_logic_vector(WidthCLA-1 downto 0);
			S: out std_logic_vector(WidthCLA downto 0)
		);
end CLA_adder;

architecture Behavioral of CLA_adder is

	signal p_int, g_int: std_logic_vector(WidthCLA-1 downto 0);
	signal C: std_logic_vector(WidthCLA downto 0);

	begin

		forGen: for i in 0 to WidthCLA generate
					ifGen_1:	if (i < WidthCLA) generate
									FA_CLA:	entity work.FA_cla
											port map (
														A => A(i),
														B => B(i),
														Cin => C(i),
														p => p_int(i),
														g => g_int(i),
														S => S(i)
													);													
								end generate;														
								
					ifGen_2:	if (i = WidthCLA) generate
									MSBfa: entity work.FA_cla
											port map (
														A => A(i-1),
														B => B(i-1),
														Cin => C(WidthCLA),	-- Cout
														p => open,
														g => open,
														S => S(i)
													);
								end generate;																
				end generate;	
				
        CLA: entity work.CarryGen
        generic map (N=>WidthCLA)
        port map(
                    p => p_int,
                    g => g_int,
                    Cin => '0',
                    C => C
                );	
                		
end Behavioral;