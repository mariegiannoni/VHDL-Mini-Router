library IEEE;
use IEEE.std_logic_1164.all;

-------------
-- DECODER --
-------------

entity Decoder is
	Port(
		   --- INPUT ---
		data_10_bits: in std_logic_vector(9 downto 0);

		   --- OUTPUT ---
		data_8_bits: out std_logic_vector(7 downto 0);
		data0: out std_logic;
		data3: out std_logic
	    );
end Decoder;

architecture rtl of Decoder is
begin
	-- We retrieve the low-priority bit
	data0 <= data_10_bits(0); 
	-- We retrieve the high-priority bit
	data3 <= data_10_bits(3); 
	-- The priority bits (0 and 3) are removed from the data bus.
	data_8_bits <= data_10_bits(9 downto 4) & data_10_bits(2 downto 1); 
end rtl;