library IEEE;
use IEEE.std_logic_1164.all;

-----------------
-- ROUND ROBIN --
-----------------

entity RoundRobin is
	Port(
		   --- INPUT ---
		-- CLOCK MANAGEMENT --
		clk: in std_logic;
		rst: in std_logic;
		-- LINK 1 --
		req1: in std_logic;
		data01: in std_logic;
		data31: in std_logic;
		-- LINK 2 --
		req2: in std_logic;
		data02: in std_logic;
		data32: in std_logic;

		   --- OUTPUT ---
		-- LINK --
		valid: out std_logic;
		link: out std_logic
	    );
end RoundRobin;

architecture rtl of RoundRobin is

-----------------
-- D FLIP FLOP --
-----------------

component d_flip_flop is
	Port(
		clk: in std_logic;
		rst: in std_logic;
		d: in std_logic;
		q: out std_logic
	    );
end component;

---------
-- LUT --
---------

-- The Look-Up Table : 
-- input of 7 bits : req1 & req2 & data31 & data32 & data01 & data02 & arbiter
-- output of 3 bits : valid & link & arbiter

-- The LUT retrieve the link chosen using priority rules of the Round Robin which are the following : 
-- 1. When the req signal from a link is high, and the req signal from the other link is low, we choose the link with a high req. valid is set to '1'.

-- 2. When both req are low, we don't choose a link. valid is set to '0'.

-- 3. When both req are high, we need to determinate which one has a higher priority level. 
--    We have two priority levels on one link. 
--    The first one is supported by the bit number 3 (data3i) from the initial datai input. 
--        --> If this data3i is high when data3j is low, we choose the link i. valid is set to '1'.
--        --> If both data3i are either low or high at the same time, we check the second priority level.
--    The second priority level is supported by the bit number 0 (data0i) from the initial datai input.
--        --> If this data0i is high when data0j is low, we choose the link i. valid is set to '1'
--        --> If both data1i are either low or high at the same time, we have a data conflict, so use the arbiter.

-- 4. The arbiter allows us to decide which link will be selected. 
--    It is set to '1' if the link to be chosen is link2 and to '0' if the link to be routed is link1.
--    At the first conflict after the reset, link1 will be the first chosen link. 
--    At the second, link2 will be selected.
--    At the third, we will decide link1 again and so on. 
--    So, when we use the arbiter, we modify it : arbiter <= not(arbiter). When we don't use use, we don't modify it.

component LUT is
	Port(
		lut_in : in std_logic_vector(6 downto 0);
		lut_out : out std_logic_vector(2 downto 0)
	);
end component;

signal arbiter: std_logic;
signal lut_in: std_logic_vector(6 downto 0);
signal lut_out: std_logic_vector(2 downto 0);

begin
	-- lut_in is the concatenation of req1, req2, data31, data32, data01, data02 and arbiter
	lut_in <= req1 & req2 & data31 & data32 & data01 & data02 & arbiter;

	-- lut_out give us valid, link and arbiter
	valid <= lut_out(2);
	link <= lut_out(1);

	-- we retrieve lut_out using lut_in
	rr_lut : LUT
		port map (
			lut_in => lut_in,
			lut_out => lut_out
		);
	
	-- we keep the arbiter in a d flip flop for the next time
	ff_arbiter : d_flip_flop
		port map (
			clk => clk,
			rst => rst,
			d => lut_out(0),
			q => arbiter
		);
end rtl;