-- MUX which has at its inputs all the possible values â€‹â€‹(already represented on (n+2)-bits) that the generic partial product can assume

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.constants.all;


entity Booth_decoder is
	generic (N: integer := MULTIPLICAND_WIDTH+2);

	port(
			sel_pp: in std_logic_vector(2 downto 0);				-- selettore mux rappresentato dal codice ottenuto dall'encoder (digit codificato)
			ExA, DA, MA, MDA: in std_logic_vector(N-1 downto 0);		-- prodotti parziali -> 1A (ExA), 2A (DA), -1A (MA), -2A (MDA)
			PP: out std_logic_vector(N-1 downto 0)			            --prodotto parziale in uscita
		);
end Booth_decoder;

architecture behavioural of Booth_decoder is

	begin
	
		process(sel_pp, ExA, DA, MA, MDA)
			begin
				case sel_pp is
					when "000" =>
						PP <= (others =>'0');	-- 0 (digit codificato pari a 0)
					when "001" =>
						PP <= ExA;				-- 1A (digit codificato pari a 1)
					when "010" 	=>
						PP <= DA;				-- 2A (digit codificato pari a 2)
					when "101" 	=>
						PP <= MA;				-- -1A (digit codificato pari a -1)
					when "110" 	=>
						PP <= MDA;				-- -2A (digit codificato pari a -2)												
					when others =>
						PP <= (others => 'X');		
				end case;
		end process;					
						
end behavioural;