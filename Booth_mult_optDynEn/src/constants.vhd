library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.math_real.all;
use IEEE.NUMERIC_STD.ALL;


-- Package Declaration
package constants is

    function maxMultiplierWidth(value: integer) return integer;
    function numEncDec(value: integer) return integer;

	constant MULTIPLICAND_WIDTH: integer := 9;
	constant SET_MULTIPLIER_WIDTH: integer := 8;	-- Booth multiplier designed for fixed 8-bit or 16-bit signed multiplier (integer values ​​in the range -128 to 127 for 8-bit and -32.768 to 32.767 for 16-bit).	
	constant MULTIPLIER_WIDTH: integer := maxMultiplierWidth(SET_MULTIPLIER_WIDTH);
    constant NUM_ENCandDEC: integer := numEncDec(MULTIPLIER_WIDTH);			
	
end package constants;






package body constants is

    function numEncDec(value: integer) return integer is
    begin
        if value = 8 then
            return 4;
        elsif value = 16 then
            return 8;
        else
            return 8;
        end if;
    end function;
    
    function maxMultiplierWidth(value: integer) return integer is
    begin
        if value = 8 then
            return 8;
        elsif value = 16 then
            return 16;
        else
            return 16;
        end if;
    end function;    
    
end package body constants;