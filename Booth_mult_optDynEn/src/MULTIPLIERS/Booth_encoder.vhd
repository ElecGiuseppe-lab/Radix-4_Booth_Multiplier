-- Module used to encode the multiplier's triplets of bits in order to optimize the MUX used for selecting the respective partial product
-- (reducing fan-in, i.e., a 5:1 MUX is required instead of an 8:1 MUX)

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity Booth_encoder is
    port(
			B2, B1, B0: in std_logic;							-- triplets of bits
			ctrl_bits : out std_logic_vector(2 downto 0)		-- encoding attributed to the triplet of bits
		);
end Booth_encoder;

architecture Behavioral of Booth_encoder is

    begin

        -- Encoding of the triplet of bits using the modulus and sign representation
		ctrl_bits(0)<= (B1 xor B0);
		ctrl_bits(1)<= (B2 xor B1) and (not(B1 xor B0));
        ctrl_bits(2)<= (B1 nand B0) and B2;
	
end Behavioral;