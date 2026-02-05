library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity FA_rca is
port(A,B,Cin:in std_logic;
     S,Cout:out std_logic);
end FA_rca;

architecture Behavioral of FA_rca is

    signal p,g:std_logic;
    
    begin
    
        p<=A xor B;
        g<=A and B;
        
        S<=p xor Cin;
        
        Cout<=Cin when p='1' else
              A when p='0' else 
              'X';
              
end Behavioral;