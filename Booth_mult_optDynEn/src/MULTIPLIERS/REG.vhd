library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity REG is
	generic (N: integer := 8);
    port(
			Clk, Rst, En: in std_logic;
			D : in std_logic_vector(N-1 downto 0);
			Q : out std_logic_vector(N-1 downto 0)
    );
end REG;


architecture Behavioral of REG is

	begin
		
		process(Clk)
			begin		
				if(rising_edge(Clk)) then
					if(Rst = '1') then
						Q <= (others=>'0');
					elsif( En = '1' ) then
						Q <= D;
					end if;
				end if;
		end process;

end Behavioral;