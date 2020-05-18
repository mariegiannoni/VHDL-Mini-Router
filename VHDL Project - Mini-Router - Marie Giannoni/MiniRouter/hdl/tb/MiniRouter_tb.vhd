library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity MiniRouter_tb is 
end MiniRouter_tb;

architecture test of MiniRouter_tb is

-----------------
-- MINI ROUTER --
-----------------

component MiniRouter is
	Port(
		   --- INPUT ---
		-- CLK MANAGEMENT --
		clk : in std_logic;
		rst : in std_logic;

		-- LINK 1 --
		data1: in std_logic_vector(9 downto 0);
		req1: in std_logic;
		
		-- LINK 2 --
		data2: in std_logic_vector(9 downto 0);
		req2: in std_logic;

		   --- OUTPUT ---
		-- LINK 1 --
		grant1: out std_logic;
		
		-- LINK 2 --
		grant2: out std_logic;

		-- OUTLINK --
		valid: out std_logic;
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
signal data1_tb : std_logic_vector(9 downto 0) := "0000000000";
signal req1_tb : std_logic;
signal grant1_tb : std_logic;
-- LINK 2 --
signal data2_tb : std_logic_vector(9 downto 0) := "0000000000";
signal req2_tb : std_logic;
signal grant2_tb : std_logic;
-- OUTPUT --
signal valid_tb : std_logic;
signal data_out_tb : std_logic_vector(7 downto 0);

begin
mini_router_2to1: MiniRouter
     port map ( 
		clk => clk_tb,
		rst => rst_tb,
		data1 => data1_tb,
		req1 => req1_tb,
		data2 => data2_tb,
		req2 => req2_tb,
		grant1 => grant1_tb,
		grant2 => grant2_tb,
		valid => valid_tb,
		data_out => data_out_tb
	);
clk_tb <= not(clk_tb) or end_sim after T_CLK / 2;
rst_tb <= '1' after 2*T_CLK;
end_sim <= '1' after 25*T_CLK;

test_process : process(rst_tb, clk_tb)
	variable t: integer := 0;
	begin
	if (rst_tb = '0') then
		req1_tb <= '0';
		req2_tb <= '0';
		data1_tb <= "0000000000";
		data2_tb <= "0000000000";
	elsif (rising_edge(clk_tb)) then
		case(t) is
		--- REQ IS HIGH FOR ONLY ONE LINK-
			-- 1ST CASE : req1 = '1' and req2 = '0'
			when 0 => 
				req1_tb <= '1'; 
				req2_tb <= '0'; 
				data1_tb <= "0000000010";
				data2_tb <= "0100000000";
				-- RESULT EXPECTED : link_tb = '0' and valid <= '1'
				-- and data_out <= "00000001"
			-- 2ND CASE : req1 = '0' and req2 = '1'
			when 1 => 
				req1_tb <= '0';
				req2_tb <= '1'; 
				data1_tb <= "0000000010";
				data2_tb <= "0100000000";
				-- RESULT EXPECTED : link_tb = '1' and valid <= '1' 
				-- and data_out <= "01000000"
	
		--- REQ IS LOW FOR BOTH SIGNALS
			-- 3RD CASE : req1 = '0' and req2 = '0' 
			when 2 => 
				req1_tb <= '0';
				req2_tb <= '0'; 
				data1_tb <= "0000000010";
				data2_tb <= "0100000000";
				-- RESULT EXPECTED : link_tb = '0' and valid <= '0' 
				-- and data_out <= "00000000"

		--- REQ IS HIGH FOR BOTH SIGNALS
		    -- FIRST LEVEL OF PRIORITY
			-- 4TH CASE : req1 = '1' and req2 = '1'
			-- 	      data31 <= '1' and data32 <= '0'
			when 3 => 
				req1_tb <= '1';
				req2_tb <= '1';
				data1_tb <= "0000001010";
				data2_tb <= "0100000000";
				-- RESULT EXPECTED : link_tb = '0' and valid <= '1' 
				-- and data_out <= "00000001"
			-- 5TH CASE : req1 = '1' and req2 = '1'
			-- 	      data31 <= '0' and data32 <= '1'
			when 4 => 
				req1_tb <= '1';
				req2_tb <= '1';
				data1_tb <= "0000000010";
				data2_tb <= "0100001000";
				-- RESULT EXPECTED : link_tb = '1' and valid <= '1' 
				-- and data_out <= "01000000"

		    -- SECOND LEVEL OF PRIORITY
			-- 6TH CASE : req1 = '1' and req2 = '1'
			-- 	      data31 <= '1' and data32 <= '1' 
			-- 	      data01 <= '1' and data02 <= '0'
			when 5 => 
				req1_tb <= '1';
				req2_tb <= '1';
				data1_tb <= "0000001011";
				data2_tb <= "0100001000";
				-- RESULT EXPECTED : link_tb = '0' and valid <= '1' 
				-- and data_out <= "00000001"
			-- 7TH CASE : req1 = '1' and req2 = '1' 
			-- 	      data31 <= '1' and data32 <= '1' 
			-- 	      data01 <= '0' and data02 <= '1'
			when 6 => 
				req1_tb <= '1';
				req2_tb <= '1';
				data1_tb <= "0000001010";
				data2_tb <= "0100001001";
				-- RESULT EXPECTED : link_tb = '1' and valid <= '1' 
				-- and data_out <= "01000000"
			-- 8TH CASE : req1 = '1' and req2 = '1' 
			-- 	      data31 <= '0' and data32 <= '0'
			-- 	      data01 <= '1' and data02 <= '0'
			when 7 => 
				req1_tb <= '1';
				req2_tb <= '1';
				data1_tb <= "0000000011";
				data2_tb <= "0100000000";
				-- RESULT EXPECTED : link_tb = '0' and valid <= '1'  
				-- and data_out <= "00000001"
			-- 9TH CASE : req1 = '1' and req2 = '1'
			-- 	      data31 <= '0' and data32 <= '0'
			-- 	      data01 <= '0' and data02 <= '1'
			when 8 => 
				req1_tb <= '1';
				req2_tb <= '1';
				data1_tb <= "0000000010";
				data2_tb <= "0100000001";
				-- RESULT EXPECTED : link_tb = '1' and valid <= '1'

		    -- ROUND ROBIN ALGORITHM : CONFLICT
			-- 10TH CASE : req1 = '1' and req2 = '1'
			-- 	      data31 <= '1' and data32 <= '1'
			-- 	      data01 <= '0' and data02 <= '0'
			when 9 => 
				req1_tb <= '1';
				req2_tb <= '1';
				data1_tb <= "0000001010";
				data2_tb <= "0100001000";
				-- RESULT EXPECTED : link_tb = '0' and valid <= '1'  
				-- and data_out <= "00000001"
			-- 11TH CASE : req1 = '1' and req2 = '1' 
			-- 	      data31 <= '1' and data32 <= '1'
			-- 	      data01 <= '1' and data02 <= '1'
			when 10 => 
				req1_tb <= '1';
				req2_tb <= '1';
				data1_tb <= "0000001011";
				data2_tb <= "0100001001";
				-- RESULT EXPECTED : link_tb = '1' and valid <= '1'  
				-- and data_out <= "01000000"
			-- 12TH CASE : req1 = '1' and req2 = '1'
			-- 	      data31 <= '0' and data32 <= '0' 
			-- 	      data01 <= '0' and data02 <= '0'
			when 11 => 
				req1_tb <= '1';
				req2_tb <= '1';
				data1_tb <= "0000000010";
				data2_tb <= "0100000000";
				-- RESULT EXPECTED : link_tb = '0' and valid <= '1'  
				-- and data_out <= "00000001"
			-- 13TH CASE : req1 = '1' and req2 = '1'
			-- 	      data31 <= '0' and data32 <= '0'
			-- 	      data01 <= '1' and data02 <= '1'
			when 12 => 
				req1_tb <= '1';
				req2_tb <= '1';
				data1_tb <= "0000000011";
				data2_tb <= "0100000001";
				 -- RESULT EXPECTED : link_tb = '1' and valid <= '1'  
				-- and data_out <= "01000000"
			when 13 =>
				req1_tb <= '0';
				req2_tb <= '0';
				data1_tb <= "0000000011";
				data2_tb <= "0100000001";
				-- RESULT EXPECTED : link_tb = '1' and valid <= '1'  
				-- and data_out <= "00000000"
			when others => null;
		end case;
		t := t+1;
	end if;
	end process;
end test;
