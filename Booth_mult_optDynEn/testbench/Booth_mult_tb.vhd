library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.constants.all;

entity Booth_mult_TB is
end Booth_mult_TB;

architecture Behavioral of Booth_mult_TB is

    -- Signals for testbench
    signal clk, rst, read_en: std_logic := '0';
    signal A_tb : std_logic_vector(MULTIPLICAND_WIDTH-1 downto 0) := (others => '0');
	signal B_tb : std_logic_vector(MULTIPLIER_WIDTH-1 downto 0) := (others => '0');
    signal Ris_mult_tb : std_logic_vector(MULTIPLICAND_WIDTH+MULTIPLIER_WIDTH-1 downto 0);
    
    constant clk_period : time := 10 ns;    

begin

    -- Instantiate the DUT
    DUT: entity work.Booth_mult port map(
        clk => clk,
        rst => rst,
        read_en => read_en,
        A => A_tb,
        B => B_tb,
        Ris_mult => Ris_mult_tb
    );
    
    -- Clock generation process
    clock:	process
                begin
                    clk <= '1';
                    wait for clk_period/2;
                    clk <= '0';
                    wait for clk_period/2;
            end process;

    -- Stimulus process
    reset:	process
                begin
                    wait for 6.5*clk_period;
                    wait for 1 ns;
                    rst <= '1';
                    wait for clk_period;
                    rst <= '0';
                    wait;
            end process;            
            
    -- Stimulus process
    read_enable:	process
                        begin
                            wait for 10*clk_period;
                            wait for clk_period/2;
                            read_en <= '1';
                            wait;
                    end process;              			
				
    -- Stimulus process: apply inputs
    stimulus:	process
                
                variable expected: signed(MULTIPLICAND_WIDTH+MULTIPLIER_WIDTH-1 downto 0);    -- expected result
                variable error_found  : boolean := false;
            
					begin
						-- Test with various input values
						wait until read_en='1';
						
						report 
						      "-----------------------------------------------------------------" & character'val(10) &
                              "      TEST RUN..." & character'val(10) &
						      "      -----------------------------------------------------------------" 
						severity note;
						
						for i in -5 to 5 loop
							for j in -4 to 10 loop
								A_tb <= std_logic_vector(to_signed(i, A_tb'length));
								B_tb <= std_logic_vector(to_signed(j*2, B_tb'length));	
												
								expected := to_signed(i, Ris_mult_tb'length) + to_signed(j*2, Ris_mult_tb'length);												
														
							    wait for clk_period;  -- Wait for some time for the output to settle																														
								
                                if signed(Ris_mult_tb) /= expected then
                                    error_found := true;
                                else
                                    error_found := error_found;
                                    report "*** Output OK! Expected value: " & integer'image(to_integer(expected)) &
                                            " Obtained value: " & integer'image(to_integer(signed(Ris_mult_tb))) & " ***"
                                    severity note;                                    
                                end if;								
								
								-- automatic report errors
								assert (to_integer(signed(Ris_mult_tb)) = expected)
                                    report "*** Output mismatch! Expected value: " & integer'image(to_integer(expected)) &
                                            " Obtained value: " & integer'image(to_integer(signed(Ris_mult_tb))) & " ***"
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