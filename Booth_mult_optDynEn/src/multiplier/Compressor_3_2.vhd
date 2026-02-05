-- Carry Save Adder Module

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.constants.all;


entity Compressor_3_2 is
	generic(N: integer:= 8);									-- default value = 8
	
	port(
			A, B, C : in std_logic_vector(N-1 downto 0);
			VSP, VR : out std_logic_vector (N downto 0) 	    -- partial sum vector and carry vector
		);
end Compressor_3_2;

architecture Behavioral of Compressor_3_2 is

	signal VSP_int, VR_int: std_logic_vector(N-1 downto 0);
	 
	begin

		forGen:	for i in 0 to (N-1) generate
						FA_CSA: entity work.FA_csa
									port map(
												A => A(i),
												B => B(i),
												Cin => C(i),
												Sum => VSP_int(i),
												Cout => VR_int(i)
											);
				end generate;

	VSP <= std_logic_vector(resize(signed(VSP_int), VSP'length));					-- signed extension of the partial sum		
	--VSP <= (VSP_int(N-1) & VSP_int);
	VR <= (VR_int & '0');															-- left shift of the carry vector
	--VR <= std_logic_vector(shift_left(resize(signed(VR_int),VR'length),1));
	
end Behavioral;