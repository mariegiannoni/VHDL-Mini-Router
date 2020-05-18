library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity Adapter_tb is 
end Adapter_tb;

architecture test of Adapter_tb is

-------------
-- ADAPTER --
-------------

component Adapter is
Port(
		   --- INPUT ---
		-- CLK MANAGEMENT --
		clk : in std_logic;
		rst : in std_logic;

		-- LINK 1 --
		data1_serial: in std_logic;
		req1: in std_logic;
		
		-- LINK 2 --
		data2_serial: in std_logic;
		req2: in std_logic;

		   --- OUTPUT ---
		-- LINK 1 --
		grant1: out std_logic;
		
		-- LINK 2 --
		grant2: out std_logic;

		-- OUTLINK --
		valid: out std_logic;
		data_out_serial: out std_logic
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
signal data1_serial_tb : std_logic;
signal req1_tb : std_logic;
signal grant1_tb : std_logic;
-- LINK 2 --
signal data2_serial_tb : std_logic;
signal req2_tb : std_logic;
signal grant2_tb : std_logic;
-- OUTPUT --
signal valid_tb : std_logic;
signal data_out_serial_tb : std_logic;

begin
adapter_mini_router_2to1: Adapter
     port map ( 
		clk => clk_tb,
		rst => rst_tb,
		data1_serial => data1_serial_tb,
		req1 => req1_tb,
		data2_serial => data2_serial_tb,
		req2 => req2_tb,
		grant1 => grant1_tb,
		grant2 => grant2_tb,
		valid => valid_tb,
		data_out_serial => data_out_serial_tb
	);
clk_tb <= not(clk_tb) or end_sim after T_CLK / 2;
rst_tb <= '1' after 2*T_CLK;
end_sim <= '1' after 30*T_CLK;

test_process : process(rst_tb, clk_tb)
	variable t: integer := 0;
	begin
	if (rst_tb = '0') then
		req1_tb <= '0';
		req2_tb <= '0';
		data1_serial_tb <= '0';
		data2_serial_tb <= '0';
	elsif (rising_edge(clk_tb)) then
		case(t) is
			-- We send sequentially the data : 0111111111 to retrieve 01111111
			when 0 => 
				req1_tb <= '0'; 
				req2_tb <= '0'; 
				data1_serial_tb <= '0';
				data2_serial_tb <= '0';
			when 1 =>
				req1_tb <= '0'; 
				req2_tb <= '0'; 
				data1_serial_tb <= '1';
				data2_serial_tb <= '0';
			when 2 =>
				req1_tb <= '0'; 
				req2_tb <= '0'; 
				data1_serial_tb <= '1';
				data2_serial_tb <= '1';
			when 3 =>
				req1_tb <= '0'; 
				req2_tb <= '0'; 
				data1_serial_tb <= '1';
				data2_serial_tb <= '0';
			when 4 =>
				req1_tb <= '0'; 
				req2_tb <= '0'; 
				data1_serial_tb <= '1';
				data2_serial_tb <= '1';
			when 5 =>
				req1_tb <= '0'; 
				req2_tb <= '0'; 
				data1_serial_tb <= '1';
				data2_serial_tb <= '1';
			when 6 =>
				req1_tb <= '0'; 
				req2_tb <= '0'; 
				data1_serial_tb <= '1';
				data2_serial_tb <= '0';
			when 7 =>
				req1_tb <= '0'; 
				req2_tb <= '0'; 
				data1_serial_tb <= '1';
				data2_serial_tb <= '0';
			when 8 =>
				req1_tb <= '0'; 
				req2_tb <= '0'; 
				data1_serial_tb <= '1';
				data2_serial_tb <= '0';
			when 9 =>
				req1_tb <= '0'; 
				req2_tb <= '0'; 
				data1_serial_tb <= '1';
				data2_serial_tb <= '0'; 
			when 10 => 
				req1_tb <= '1'; -- the signal is complete: send the request
				req2_tb <= '0'; 
				data1_serial_tb <= '0';
				data2_serial_tb <= '0'; 
			-- RESULT EXPECTED : data_out_parallel <= "011111111" 
			-- and the bits will be sent each rising edge in this order : 0,1,1,1,1,1,1,1,1
			when 11 => 
				req1_tb <= '0'; 
				req2_tb <= '0'; 
				data1_serial_tb <= '0';
				data2_serial_tb <= '0'; 
			when others => null;
		end case;
		t := t+1;
	end if;
	end process;
end test;
