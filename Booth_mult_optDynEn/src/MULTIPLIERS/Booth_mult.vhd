library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.constants.all;


entity Booth_mult is
	generic (
				N: integer := MULTIPLICAND_WIDTH;
				M: integer := MULTIPLIER_WIDTH
			);

	port(
	       clk, rst, read_en: in std_logic;
			A : in std_logic_vector(N-1 downto 0);					-- multiplicand
			B : in std_logic_vector (M-1 downto 0);				    -- multiplier
			Ris_mult : out std_logic_vector (N+M-1 downto 0)
		); 
end Booth_mult;

architecture Behavioral of Booth_mult is

	type cod_array is array (0 to NUM_ENCandDEC-1) of std_logic_vector(2 downto 0);			
	type PP_array is array (0 to NUM_ENCandDEC-1) of std_logic_vector(N+1 downto 0);
	type PP_int_array is array (0 to NUM_ENCandDEC-1) of std_logic_vector(N+M-1 downto 0);	

	signal ExA, DA, MA, MDA: std_logic_vector(N+1 downto 0);
	signal A_int, A_int_reg2, not_A: std_logic_vector(N-1 downto 0);
	signal B_int: std_logic_vector (M-1 downto 0);
	constant one: std_logic_vector := std_logic_vector(to_signed(1,not_A'length));	
    signal RCA_MA, RCA_MA_reg4: std_logic_vector(N downto 0);
	signal cod_terna, cod_terna_reg5: cod_array; 		--array contenente le terne codificate
	signal partial_prod: PP_array;						--array contenente i prodotti parziali in uscita dai decoder
	signal PP_int: PP_int_array; 						--array contenente i prodotti parziali in uscita dal decoder estesi e shiftati
	signal CumSum_int, CumSum_int_reg6: std_logic_vector(N+M+2 downto 0);	-- for multiplier 8-bit
	signal CumSum_int16bit, CumSum_int16bit_reg6: std_logic_vector(N+M+4 downto 0);	-- for multiplier 16-bit

	
	begin
	
        reg_1:  entity work.REG
                    generic map(N => N)
                    port map(
                                Clk => clk,
                                Rst => rst,
                                En => read_en,
                                D => A,       	
                                Q => A_int
                            );
                            
        reg_2:  entity work.REG
                    generic map(N => N)
                    port map(
                                Clk => clk,
                                Rst => rst,
                                En => read_en,
                                D => A_int,       	
                                Q => A_int_reg2
                            );                    
                            
        reg_3:  entity work.REG
                    generic map(N => M)
                    port map(
                                Clk => clk,
                                Rst => rst,
                                En => read_en,
                                D => B,       	
                                Q => B_int
                            );                            
                               
        not_A <= not(A_int);
        ExA <= (A_int_reg2(N-1)&A_int_reg2(N-1)&A_int_reg2); 
        DA <= (ExA(N downto 0)&'0');
        
        RCA: entity work.RCA_signed
            generic map(WidthRCA=>N)
            
            port map(
                        A => not_A,
                        B => one,
                        Cin=>'0',
                        S => RCA_MA
                    );
                    
        reg_4:  entity work.REG
                    generic map(N => N+1)
                    port map(
                                Clk => clk,
                                Rst => rst,
                                En => read_en,
                                D => RCA_MA,       	
                                Q => RCA_MA_reg4
                            );                    
                    
        MA <= RCA_MA_reg4(N) & RCA_MA_reg4;
        MDA <= MA(N downto 0) & '0';          		   
    
        Booth_encoder:	for i in 0 to NUM_ENCandDEC-1 generate						
                            ifGen_1:	if (i = 0) generate
                                            enc_1st:	entity work.Booth_encoder 
                                                            port map(																														
                                                                        B0 => '0',
                                                                        B1 => B_int(i),
                                                                        B2 => B_int(i+1),
                                                                        ctrl_bits => cod_terna(i)
                                                                    );
                                                                    
                                            reg_5_1st:  entity work.REG
                                                            generic map(N => 3)
                                                            port map(
                                                                        Clk => clk,
                                                                        Rst => rst,
                                                                        En => read_en,
                                                                        D => cod_terna(i),       	
                                                                        Q => cod_terna_reg5(i)
                                                                    );                                                                    
                                        end generate;
                    
                            ifGen_2:	if (i > 0) generate
                                            enc_other:	entity work.Booth_encoder 
                                                            port map(																																
                                                                        B0 => B_int(i*2-1),
                                                                        B1 => B_int(i*2),
                                                                        B2 => B_int(i*2+1),
                                                                        ctrl_bits => cod_terna(i)
                                                                    );
                                                                    
                                            reg_5_other:  entity work.REG
                                                            generic map(N => 3)
                                                            port map(
                                                                        Clk => clk,
                                                                        Rst => rst,
                                                                        En => read_en,
                                                                        D => cod_terna(i),       	
                                                                        Q => cod_terna_reg5(i)
                                                                    );                                                                      
                                        end generate;													                              
                        end generate;                                                 
                                                
        Booth_decoder:	for i in 0 to NUM_ENCandDEC-1 generate                        
                            decoder:	entity work.Booth_decoder
                                            port map (
                                                        sel_pp => cod_terna_reg5(i),
                                                        ExA => ExA,
                                                        DA => DA,
                                                        MA => MA,
                                                        MDA => MDA,
                                                        PP => partial_prod(i)
                                                    );  
                         end generate;                                     
		
		
		ifGen_3:	if (M = 8) generate
						-- alignment of partial products output from MUX/decoders (left shift and signed extension)
--						 PP_int(0) <= (N+M-1 downto 11 => partial_prod(0)(N+1)) & partial_prod(0);
--						 PP_int(1) <= (N+M-1 downto 13 => partial_prod(1)(N+1)) & partial_prod(1) & "00";
--						 PP_int(2) <= (N+M-1 downto 15 => partial_prod(2)(N+1)) & partial_prod(2)&"0000";							
--						 PP_int(3) <= partial_prod(3)&"000000";
						
						forGen_extANDshift:	for i in 1 to NUM_ENCandDEC generate
						                      ifGen_4:    if (i = 1) generate
						                                        -- no left-shift, only extension
												                PP_int(i-1) <= std_logic_vector(resize(signed(partial_prod(i-1)),PP_int(i-1)'length));
											              end generate;
											              
						                      ifGen_5:    if (i > 1) generate
						                                        -- extension and left-shift
												                PP_int(i-1) <= std_logic_vector(resize(signed(partial_prod(i-1)),PP_int(i-1)'length-2*(i-1))) & (2*(i-1)-1 downto 0 => '0');
											              end generate;
											end generate;											              
						
						Adder_tree_4op: entity work.Adder_tree_4op
											generic map(N=>N+M)
											port map(
														PP1 => PP_int(0), 
														PP2 => PP_int(1),
														PP3 => PP_int(2),
														PP4 => PP_int(3),
														Cum_sum => CumSum_int
													);
													
                        reg_6:  entity work.REG
                                    generic map(N => N+M+3)
                                    port map(
                                                Clk => clk,
                                                Rst => rst,
                                                En => read_en,
                                                D => CumSum_int,       	
                                                Q => CumSum_int_reg6
                                            ); 
                                            
                        Ris_mult <= CumSum_int_reg6(N+M-1 downto 0);                                             																										
					end generate;
					
		 ifGen_4:	if (M = 16) generate	 
						forGen_extANDshift:	for i in 1 to NUM_ENCandDEC generate
						                      ifGen_4:    if (i = 1) generate
						                                        -- no left-shift, only extension
												                PP_int(i-1) <= std_logic_vector(resize(signed(partial_prod(i-1)),PP_int(i-1)'length));
											              end generate;
											              
						                      ifGen_5:    if (i > 1) generate
						                                        -- extension and left-shift
												                PP_int(i-1) <= std_logic_vector(resize(signed(partial_prod(i-1)),PP_int(i-1)'length-2*(i-1))) & (2*(i-1)-1 downto 0 => '0');
											              end generate;
											end generate;			 
		 
						 Adder_tree_8op: entity work.Adder_tree_8op
											 generic map(N=>N+M)
											 port map(
														 PP1 => PP_int(0), 
														 PP2 => PP_int(1),
														 PP3 => PP_int(2),
														 PP4 => PP_int(3),
														 PP5 => PP_int(4),
														 PP6 => PP_int(5),
														 PP7 => PP_int(6),
														 PP8 => PP_int(7),
														 Cum_sum => CumSum_int16bit
													 );
													 
                        reg_6:  entity work.REG
                                    generic map(N => N+M+5)
                                    port map(
                                                Clk => clk,
                                                Rst => rst,
                                                En => read_en,
                                                D => CumSum_int16bit,       	
                                                Q => CumSum_int16bit_reg6
                                            ); 	
                                            
		                Ris_mult <= CumSum_int16bit_reg6(N+M-1 downto 0);                                                                                      												 												 
					 end generate;												                                        
		
end Behavioral;