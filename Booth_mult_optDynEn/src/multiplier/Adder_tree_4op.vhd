library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.constants.all;


entity Adder_tree_4op is
	generic (N: integer := 8);
	
	port(
			PP1, PP2, PP3, PP4 : in std_logic_vector(N-1 downto 0);
			Cum_sum : out std_logic_vector(N+2 downto 0) 
		);
end Adder_tree_4op;


architecture Behavioral of Adder_tree_4op is
	
	signal VR_1, VSP_1, PP4_ext: std_logic_vector(N downto 0);
	signal VR_2, VSP_2: std_logic_vector(N+1 downto 0);

	begin
	
		mapFA_1: entity work.Compressor_3_2 
					generic map(N => N)
					port map(
								A => PP1,
								B => PP2,
								C => PP3,
								VSP => VSP_1,
								VR => VR_1
							);	
		
		PP4_ext <= std_logic_vector(resize(signed(PP4),PP4_ext'length));
		
		mapFA_2: entity work.Compressor_3_2 
					generic map(N => N+1)
					port map(
								A => VSP_1,
								B => VR_1,
								C => PP4_ext,
								VSP => VSP_2,
								VR => VR_2
							);		

 		-- RCA: entity work.RCA_signed
				-- generic map(WidthRCA => N+2)
				-- port map(
							-- A => VSP_2,
							-- B => VR_2,
							-- Cin => '0',
							-- S => Cum_sum
						-- );										

		CLA: entity work.CLA_adder
				generic map(WidthCLA => N+2)
				port map(
							A => VSP_2,
							B => VR_2,
							S => Cum_sum
						);	

end Behavioral;
