library IEEE;
use IEEE.std_logic_1164.all; 
use IEEE.numeric_std.all;

-------------
-- WRAPPER --
-------------

entity MINI_ROUTER_WRAPPER is -- Mini Router Wrapper
	Port(
		   --- INPUT ---
		-- CLK MANAGEMENT --
		clk : in std_logic;
		rst : in std_logic;

		-- LINK 1 --
		data1: in std_logic;
		req1: in std_logic;
		
		-- LINK 2 --
		data2: in std_logic;
		req2: in std_logic;

		   --- OUTPUT ---
		-- LINK 1 --
		grant1: out std_logic;
		
		-- LINK 2 --
		grant2: out std_logic;

		-- OUTLINK --
		valid: out std_logic;
		data_out: out std_logic
	);
end MINI_ROUTER_WRAPPER;

architecture rtl of MINI_ROUTER_WRAPPER is

----------
-- DDFS --
----------

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

begin
	
adapter_serial_parallel : 
	Adapter
	port map(
		clk => clk,
		rst => rst,
		data1_serial => data1,
		req1 => req1,
		data2_serial => data2,
		req2 => req2,
		grant1 => grant1,
		grant2 => grant2,
		valid => valid,
		data_out_serial => data_out
	);	
end rtl;