library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity Decoder_tb is 
end Decoder_tb;

architecture test of Decoder_tb is

-------------
-- DECODER --
-------------

component Decoder is
	Port(
		   --- INPUT ---
		data_10_bits: in std_logic_vector(9 downto 0);

		   --- OUTPUT ---
		data_8_bits: out std_logic_vector(7 downto 0);
		data0: out std_logic;
		data3: out std_logic
	    );
end component;

--------------
-- CONSTANT --
--------------
constant T_CLK: time := 100 ns;

------------
-- SIGNAL --
------------
-- SIMULATION MANAGEMENT --
signal end_sim : std_logic := '0';
-- CLK MANAGEMENT --
signal clk_tb : std_logic := '0';
signal rst_tb : std_logic := '0';
-- LINK 1 --
signal data1_10_bits_tb: std_logic_vector(9 downto 0) := "0000000000";
signal data1_8_bits_tb: std_logic_vector(7 downto 0);
signal data01_tb: std_logic;
signal data31_tb: std_logic;
-- LINK 2 --
signal data2_10_bits_tb: std_logic_vector(9 downto 0) := "0000000000";
signal data2_8_bits_tb: std_logic_vector(7 downto 0);
signal data02_tb: std_logic;
signal data32_tb: std_logic;

begin
d1: Decoder
     port map ( 
		data_10_bits => data1_10_bits_tb,
		data_8_bits => data1_8_bits_tb,
		data0 => data01_tb,
		data3 => data31_tb
	);

d2: Decoder
     port map ( 
		data_10_bits => data2_10_bits_tb,
		data_8_bits => data2_8_bits_tb,
		data0 => data02_tb,
		data3 => data32_tb
	);

clk_tb <= not(clk_tb) or end_sim after T_CLK / 2;
rst_tb <= '1' after 3*T_CLK;
end_sim <= '1' after 20*T_CLK;

test_process : process(rst_tb, clk_tb)
	variable t: integer := 0;
	begin
	if (rst_tb = '0') then
		data1_10_bits_tb <= "0000000000";
		data2_10_bits_tb <= "0000000000";
	elsif (rising_edge(clk_tb)) then
		case(t) is
			when 0 => 
				data1_10_bits_tb <= "0000000001"; 
				data2_10_bits_tb <= "1000000000";
				-- RESULT EXEPECTED : data1_8_bits_tb <= "00000000" ; 
				--		      data2_8_bits_tb <= "10000000"
			when 1 => 
				data1_10_bits_tb <= "0000000010"; 
				data2_10_bits_tb <= "0100000000";
				-- RESULT EXEPECTED : data1_8_bits_tb <= "00000001" ; 
				-- 		      data2_8_bits_tb <= "01000000"
			when 2 => 
				data1_10_bits_tb <= "0000000100"; 
				data2_10_bits_tb <= "0010000000";
				-- RESULT EXEPECTED : data1_8_bits_tb <= "00000010" ; 
				--                    data2_8_bits_tb <= "00100000"
			when 3 => 
				data1_10_bits_tb <= "0000001000"; 
				data2_10_bits_tb <= "0001000000";
				-- RESULT EXEPECTED : data1_8_bits_tb <= "00000000" ; 
				--                    data2_8_bits_tb <= "00010000"
			when 4 => 
				data1_10_bits_tb <= "0000010000"; 
				data2_10_bits_tb <= "0000100000";
				-- RESULT EXEPECTED : data1_8_bits_tb <= "00000100" ; 
				--                    data2_8_bits_tb <= "00001000"
			when 5 => 
				data1_10_bits_tb <= "0101010101"; 
				data2_10_bits_tb <= "1010101010";
				-- RESULT EXEPECTED : data1_8_bits_tb <= "01010110" ;  
				--                    data2_8_bits_tb <= "10101001"
			when 6 => 
				data1_10_bits_tb <= "0111010111"; 
				data2_10_bits_tb <= "1110101011";
				-- RESULT EXEPECTED : data1_8_bits_tb <= "01110111" ;  
				--                    data2_8_bits_tb <= "11101001"
			when 7 => 
				data1_10_bits_tb <= "0111001110"; 
				data2_10_bits_tb <= "1101101101";
				-- RESULT EXEPECTED : data1_8_bits_tb <= "01110011" ;  
				--                    data2_8_bits_tb <= "11011010"
			when 8 => 
				data1_10_bits_tb <= "0000011111"; 
				data2_10_bits_tb <= "1111100000";
				-- RESULT EXEPECTED : data1_8_bits_tb <= "00000111" ;  
				--                    data2_8_bits_tb <= "11111000"
			when 9 => 
				data1_10_bits_tb <= "0000000000"; 
				data2_10_bits_tb <= "1111111111";
				-- RESULT EXEPECTED : data1_8_bits_tb <= "00000000" ;  
				--                    data2_8_bits_tb <= "11111111"
			when others => null;
		end case;
		t := t+1;
	end if;
	end process;
end test;
