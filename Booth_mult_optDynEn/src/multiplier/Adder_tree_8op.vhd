library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.constants.all;


entity Adder_tree_8op is
	generic (N: integer := 8);
	
	port(
			PP1, PP2, PP3, PP4, PP5, PP6, PP7, PP8: in std_logic_vector(N-1 downto 0);
			Cum_sum : out std_logic_vector(N+4 downto 0) 
		);
end Adder_tree_8op;


architecture Behavioral of Adder_tree_8op is
	
	signal VR1_1st, VSP1_1st, VR2_1st, VSP2_1st, PP7_ext, PP8_ext: std_logic_vector(N downto 0);
	signal VR1_2nd, VSP1_2nd, VR2_2nd, VSP2_2nd: std_logic_vector(N+1 downto 0);
	signal VSP1_3rd, VR1_3rd, VR2_2nd_ext: std_logic_vector(N+2 downto 0);
	signal VSP1_4th, VR1_4th: std_logic_vector(N+3 downto 0);	

	begin
	
		mapFA1_1st: entity work.Compressor_3_2 
						generic map(N => N)
						port map(
									A => PP1,
									B => PP2,
									C => PP3,
									VSP => VSP1_1st,
									VR => VR1_1st
								);

		mapFA2_1st: entity work.Compressor_3_2 
						generic map(N => N)
						port map(
									A => PP4,
									B => PP5,
									C => PP6,
									VSP => VSP2_1st,
									VR => VR2_1st
								);								
		
		PP7_ext <= std_logic_vector(resize(signed(PP7),PP7_ext'length));
		PP8_ext <= std_logic_vector(resize(signed(PP8),PP8_ext'length));
		
		mapFA1_2nd: entity work.Compressor_3_2 
					generic map(N => N+1)
					port map(
								A => VSP1_1st,
								B => VR1_1st,
								C => VSP2_1st,
								VSP => VSP1_2nd,
								VR => VR1_2nd
							);	

		mapFA2_2nd: entity work.Compressor_3_2 
					generic map(N => N+1)
					port map(
								A => VR2_1st,
								B => PP7_ext,
								C => PP8_ext,
								VSP => VSP2_2nd,
								VR => VR2_2nd
							);	

		mapFA1_3rd: entity work.Compressor_3_2 
					generic map(N => N+2)
					port map(
								A => VSP1_2nd,
								B => VR1_2nd,
								C => VSP2_2nd,
								VSP => VSP1_3rd,
								VR => VR1_3rd
							);

		VR2_2nd_ext <= std_logic_vector(resize(signed(VR2_2nd),VR2_2nd_ext'length));	

		mapFA1_4th: entity work.Compressor_3_2 
					generic map(N => N+3)
					port map(
								A => VSP1_3rd,
								B => VR1_3rd,
								C => VR2_2nd_ext,
								VSP => VSP1_4th,
								VR => VR1_4th
							);		
							

 		-- RCA: entity work.RCA_signed
				-- generic map(WidthRCA => N+4)
				-- port map(
							-- A => VSP1_4th,
							-- B => VR1_4th,
							-- Cin => '0',
							-- S => Cum_sum
						-- );										

		CLA: entity work.CLA_adder
				generic map(WidthCLA => N+4)
				port map(
							A => VSP1_4th,
							B => VR1_4th,
							S => Cum_sum
						);	

end Behavioral;
