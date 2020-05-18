library IEEE;
use IEEE.std_logic_1164.all;

entity RoundRobin_tb is 
end RoundRobin_tb;

architecture test of RoundRobin_tb is

-----------------
-- ROUND ROBIN --
-----------------

component RoundRobin is
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
signal req1_tb: std_logic := '0';
signal data01_tb: std_logic := '0';
signal data31_tb: std_logic := '0';
-- LINK 2 --
signal req2_tb: std_logic := '0';
signal data02_tb: std_logic := '0';
signal data32_tb: std_logic := '0';
-- ARBITER --
signal arbiter_in_tb: std_logic := '0';
signal arbiter_out_tb: std_logic;
-- SELECTED LINK--
signal valid_tb: std_logic;
signal link_tb: std_logic;

begin
rr: RoundRobin
     port map ( 
		clk => clk_tb,
		rst => rst_tb,
		req1 => req1_tb,
		data01 => data01_tb,
		data31 => data31_tb,
		req2 => req2_tb,
		data02 => data02_tb,
		data32 => data32_tb,
		valid => valid_tb,
		link => link_tb
	);

clk_tb <= not(clk_tb) or end_sim after T_CLK / 2;
rst_tb <= '1' after 3*T_CLK;
end_sim <= '1' after 20*T_CLK;

test_process : process(rst_tb, clk_tb)
	variable t: integer := 0;
	begin
	if (rst_tb = '0') then
		req1_tb <= '0';
		req2_tb <= '0';
	elsif (rising_edge(clk_tb)) then
		case(t) is
		--- REQ IS HIGH FOR ONLY ONE LINK-
			-- 1ST CASE : req1 = '1' and req2 = '0'
			when 0 => 
				req1_tb <= '1'; 
				req2_tb <= '0'; 
				-- RESULT EXPECTED : link_tb = '0' and valid <= '1'
			-- 2ND CASE : req1 = '0' and req2 = '1'
			when 1 => 
				req1_tb <= '0';
				req2_tb <= '1'; 
				-- RESULT EXPECTED : link_tb = '1' and valid <= '1'
	
		--- REQ IS LOW FOR BOTH SIGNALS
			-- 3RD CASE : req1 = '0' and req2 = '0' 
			when 2 => 
				req1_tb <= '0';
				req2_tb <= '0'; 
				-- RESULT EXPECTED : link_tb = '0' and valid <= '0'

		--- REQ IS HIGH FOR BOTH SIGNALS
		    -- FIRST LEVEL OF PRIORITY
			-- 4TH CASE : req1 = '1' and req2 = '1'
			-- 	      data31 <= '1' and data32 <= '0'
			when 3 => 
				req1_tb <= '1';
				req2_tb <= '1';
				data31_tb <= '1';
				data32_tb <= '0'; 
				-- RESULT EXPECTED : link_tb = '0' and valid <= '1'
			-- 5TH CASE : req1 = '1' and req2 = '1'
			-- 	      data31 <= '0' and data32 <= '1'
			when 4 => 
				req1_tb <= '1';
				req2_tb <= '1';
				data31_tb <= '0';
				data32_tb <= '1'; 
				-- RESULT EXPECTED : link_tb = '1' and valid <= '1'

		    -- SECOND LEVEL OF PRIORITY
			-- 6TH CASE : req1 = '1' and req2 = '1'
			-- 	      data31 <= '1' and data32 <= '1' 
			-- 	      data01 <= '1' and data02 <= '0'
			when 5 => 
				req1_tb <= '1';
				req2_tb <= '1';
				data31_tb <= '1';
				data32_tb <= '1';
				data01_tb <= '1';
				data02_tb <= '0';
				-- RESULT EXPECTED : link_tb = '0' and valid <= '1'
			-- 7TH CASE : req1 = '1' and req2 = '1' 
			-- 	      data31 <= '1' and data32 <= '1' 
			-- 	      data01 <= '0' and data02 <= '1'
			when 6 => 
				req1_tb <= '1';
				req2_tb <= '1';
				data31_tb <= '1';
				data32_tb <= '1';
				data01_tb <= '0';
				data02_tb <= '1'; 
				-- RESULT EXPECTED : link_tb = '1' and valid <= '1'
			-- 8TH CASE : req1 = '1' and req2 = '1' 
			-- 	      data31 <= '0' and data32 <= '0'
			-- 	      data01 <= '1' and data02 <= '0'
			when 7 => 
				req1_tb <= '1';
				req2_tb <= '1';
				data31_tb <= '0';
				data32_tb <= '0';
				data01_tb <= '1';
				data02_tb <= '0'; 
				-- RESULT EXPECTED : link_tb = '0' and valid <= '1'
			-- 9TH CASE : req1 = '1' and req2 = '1'
			-- 	      data31 <= '0' and data32 <= '0'
			-- 	      data01 <= '0' and data02 <= '1'
			when 8 => 
				req1_tb <= '1';
				req2_tb <= '1';
				data31_tb <= '0';
				data32_tb <= '0';
				data01_tb <= '0';
				data02_tb <= '1'; 
				-- RESULT EXPECTED : link_tb = '1' and valid <= '1'

		    -- ROUND ROBIN ALGORITHM : CONFLICT
			-- 10TH CASE : req1 = '1' and req2 = '1'
			-- 	      data31 <= '1' and data32 <= '1'
			-- 	      data01 <= '0' and data02 <= '0'
			when 9 => 
				req1_tb <= '1';
				req2_tb <= '1';
				data31_tb <= '1';
				data32_tb <= '1';
				data01_tb <= '0';
				data02_tb <= '0'; 
				-- RESULT EXPECTED : link_tb = '0' and valid <= '1'
			-- 11TH CASE : req1 = '1' and req2 = '1' 
			-- 	      data31 <= '1' and data32 <= '1'
			-- 	      data01 <= '1' and data02 <= '1'
			when 10 => 
				req1_tb <= '1';
				req2_tb <= '1';
				data31_tb <= '1';
				data32_tb <= '1';
				data01_tb <= '1';
				data02_tb <= '1'; 
				-- RESULT EXPECTED : link_tb = '1' and valid <= '1'
			-- 12TH CASE : req1 = '1' and req2 = '1'
			-- 	      data31 <= '0' and data32 <= '0' 
			-- 	      data01 <= '0' and data02 <= '0'
			when 11 => 
				req1_tb <= '1';
				req2_tb <= '1';
				data31_tb <= '0';
				data32_tb <= '0';
				data01_tb <= '0';
				data02_tb <= '0'; 
				-- RESULT EXPECTED : link_tb = '0' and valid <= '1'
			-- 13TH CASE : req1 = '1' and req2 = '1'
			-- 	      data31 <= '0' and data32 <= '0'
			-- 	      data01 <= '1' and data02 <= '1'
			when 12 => 
				req1_tb <= '1';
				req2_tb <= '1';
				data31_tb <= '0';
				data32_tb <= '0';
				data01_tb <= '1';
				data02_tb <= '1';
				 -- RESULT EXPECTED : link_tb = '1' and valid <= '1'
			when others => null;
		end case;
		t := t+1;
	end if;
	end process;
end test;