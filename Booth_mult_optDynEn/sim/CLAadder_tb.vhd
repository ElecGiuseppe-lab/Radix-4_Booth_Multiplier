library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity CLAadder_tb is
end CLAadder_tb;

architecture Behavioral of CLAadder_tb is

    -- Signals for testbench
    signal A_tb : std_logic_vector(7 downto 0) := (others => '0');
	signal B_tb : std_logic_vector(7 downto 0) := (others => '0');
    signal Sum_tb : std_logic_vector(8 downto 0);
    

begin

    -- Instantiate the DUT
    DUT: entity work.CLA_adder port map(
        A => A_tb,
        B => B_tb,
        S => Sum_tb
    );
               

    -- Stimulus process: apply inputs
    stimulus:	process
                
                variable expected: signed(8 downto 0);    -- expected result
                variable error_found  : boolean := false;
            
					begin
						-- Test with various input values
						wait for 100 ns;
						
						report 
						      "-----------------------------------------------------------------" & character'val(10) &
                              "      TEST RUN..." & character'val(10) &
						      "      -----------------------------------------------------------------" 
						severity note;
						
						for i in -25 to 5 loop
							for j in -4 to 10 loop
								A_tb <= std_logic_vector(to_signed(i, A_tb'length));
								B_tb <= std_logic_vector(to_signed(j*2, B_tb'length));	
												
								expected := to_signed(i, Sum_tb'length) + to_signed(j*2, Sum_tb'length);												
														
							    wait for 10 ns;  -- Wait for some time for the output to settle																															
								
                                if signed(Sum_tb) /= expected then
                                    error_found := true;
                                else
                                    error_found := error_found;
                                    report "*** Output OK! Expected value: " & integer'image(to_integer(expected)) &
                                            " Obtained value: " & integer'image(to_integer(signed(Sum_tb))) & " ***"
                                    severity note;                                    
                                end if;								
								
								-- automatic report errors
								assert (to_integer(signed(Sum_tb)) = expected)
                                    report "*** Output mismatch! Expected value: " & integer'image(to_integer(expected)) &
                                            " Obtained value: " & integer'image(to_integer(signed(Sum_tb))) & " ***"
                                    severity error;  																																																
							end loop;
						end loop;
						
						if (error_found) then
                            report 
                                  "-----------------------------------------------------------------" & character'val(10) &
                                  "      TEST COMPLETED! ERROR/S IDENTIFIED...CHECK THE SOURCE CODE" & character'val(10) &
                                  "      -----------------------------------------------------------------" 
                            severity note;
                        else
                            report 
                                  "-----------------------------------------------------------------" & character'val(10) &
                                  "      TEST COMPLETED! NO ERROR/S IDENTIFIED." & character'val(10) &
                                  "      -----------------------------------------------------------------" 
                            severity note;                        
                        end if;
						
						wait;
						
				end process stimulus;

end Behavioral;