library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.constants.all;


entity RCA_signed is
	generic (WidthRCA: integer:= 8);	-- default value = 8
	port(
			A,B:in std_logic_vector(WidthRCA-1 downto 0);
			Cin:in std_logic;
			S: out std_logic_vector(WidthRCA downto 0)
		);
end RCA_signed;

architecture Behavioral of RCA_signed is

	signal carry_int: std_logic_vector(WidthRCA downto 0);

	begin

        carry_int(0)<=Cin;
    
        forGen:	for i in 0 to WidthRCA generate
                        ifGen_1:    if (i < WidthRCA) generate
                                        FA_RCA: entity work.FA_rca 
                                                    port map(
                                                                A => A(i),
                                                                B => B(i),
                                                                Cin => carry_int(i),
                                                                S => S(i),
                                                                Cout => carry_int(i+1)
                                                            );
                                    end generate;
                                    
                        --Full adder aggiuntivo per eseguire estensione con segno
                        ifGen_2:    if (i = WidthRCA) generate
                                        FA_RCA_ext: entity work.FA_rca
                                                        port map(
                                                                    A => A(i-1),
                                                                    B => B(i-1),
                                                                    Cin => carry_int(i),
                                                                    S => S(i),
                                                                    Cout => open
                                                                );
                                    end generate;
                end generate;
				
end Behavioral;

