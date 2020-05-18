library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity Multiplexer_tb is 
end Multiplexer_tb;

architecture test of Multiplexer_tb is

-------------
-- DECODER --
-------------

component Multiplexer is
	Port(
		   --- INPUT ---
		-- LINK 1 --
		data1: in std_logic_vector(7 downto 0);
		
		-- LINK 2 --
		data2: in std_logic_vector(7 downto 0);
		
		-- RR ARBITER --
		valid: in std_logic;
		link: in std_logic;

		   --- OUTPUT ---
		-- LINK 1 --
		grant1: out std_logic;
		
		-- LINK 2 --
		grant2: out std_logic;

		-- OUTLINK --
		data_out: out std_logic_vector(7 downto 0)
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
signal data1_tb : std_logic_vector(7 downto 0) := "00000000";
signal grant1_tb : std_logic;
-- LINK 2 --
signal data2_tb : std_logic_vector(7 downto 0) := "00000000";
signal grant2_tb : std_logic;
-- FROM ARBITER --
signal valid_tb : std_logic := '0';
signal link_tb : std_logic := '0';
-- OUTPUT --
signal data_out_tb : std_logic_vector(7 downto 0);

begin
mux: Multiplexer
     port map ( 
		data1 => data1_tb,
		data2 => data2_tb,
		valid => valid_tb,
		link => link_tb,
		grant1 => grant1_tb,
		grant2 => grant2_tb,
		data_out => data_out_tb
	);

clk_tb <= not(clk_tb) or end_sim after T_CLK / 2;
rst_tb <= '1' after 2*T_CLK;
end_sim <= '1' after 6*T_CLK;

test_process : process(rst_tb, clk_tb)
	variable t: integer := 0;
	begin
	if (rst_tb = '0') then
		valid_tb <= '0';
	elsif (rising_edge(clk_tb)) then
		case(t) is
			when 0 => 
				data1_tb <= "10101010"; 
				data2_tb <= "01010101";
				valid_tb <= '1';
				link_tb <= '0';
				-- RESULT EXEPECTED : data_out_tb <= "10101010" ; grant1_tb <= '1' ; grant2_tb <= '0'
			when 1 => 
				data1_tb <= "10101010"; 
				data2_tb <= "01010101";
				valid_tb <= '1';
				link_tb <= '1';
				-- RESULT EXEPECTED : data_out_tb <= "01010101" ; grant1_tb <= '0' ; grant2_tb <= '1'
			when 2 => 
				data1_tb <= "10101010"; 
				data2_tb <= "01010101";
				valid_tb <= '0';
				link_tb <= '0';
				-- RESULT EXEPECTED : data_out_tb <= "00000000" ; grant1_tb <= '0' ; grant2_tb <= '0'
			when 3 => 
				data1_tb <= "10101010"; 
				data2_tb <= "01010101";
				valid_tb <= '0';
				link_tb <= '0';
				-- RESULT EXEPECTED : data_out_tb <= "00000000" ; grant1_tb <= '0' ; grant2_tb <= '0'
			when others => null;
		end case;
		t := t+1;
	end if;
	end process;
end test;
