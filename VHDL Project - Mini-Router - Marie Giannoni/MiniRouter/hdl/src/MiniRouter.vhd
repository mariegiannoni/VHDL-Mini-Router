library IEEE;
use IEEE.std_logic_1164.all;

-----------------
-- MINI ROUTER --
-----------------

entity MiniRouter is
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
end MiniRouter;

architecture rtl of MiniRouter is
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

-----------------
-- MULTIPLEXER --
-----------------

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
		
		-- DATA --
		data_out: out std_logic_vector(7 downto 0)
	    );
end component;

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

-------------------
-- D FLIP FLOP N --
-------------------

component d_flip_flop_n is
	generic(N: integer);
	Port(
		clk: in std_logic;
		rst: in std_logic;
		d: in std_logic_vector(N-1 downto 0);
		q: out std_logic_vector(N-1 downto 0)
	    );
end component;

------------
-- SIGNAL --
------------

-- LINK 1 --
signal data1_intermediate: std_logic_vector(9 downto 0);
signal req1_intermediate: std_logic;
signal data1_8_bits : std_logic_vector(7 downto 0);
signal data01 : std_logic;
signal data31 : std_logic;
signal grant1_intermediate : std_logic;

-- LINK 2 --
signal data2_intermediate: std_logic_vector(9 downto 0);
signal req2_intermediate: std_logic;
signal data2_8_bits : std_logic_vector(7 downto 0);
signal data02 : std_logic;
signal data32 : std_logic;
signal grant2_intermediate : std_logic;

-- ARBITER --
signal valid_intermediate : std_logic;
signal link : std_logic;

-- DATA OUTPUT --
signal data_out_intermediate : std_logic_vector(7 downto 0);

begin
	-- REGISTERED INPUT --
	-- of req1 --
	ff_req1: d_flip_flop
		port map (
			clk => clk,
			rst => rst,
			d => req1,
			q => req1_intermediate
		);
		
	-- of data1 --
	ff_10_data1: d_flip_flop_n
		generic map ( N => 10)
		port map (
			clk => clk,
			rst => rst,
			d => data1,
			q => data1_intermediate
		);

	-- of req 2 --
	ff_req2: d_flip_flop
		port map (
			clk => clk,
			rst => rst,
			d => req2,
			q => req2_intermediate
		);
		
	-- of data2 --
	ff_10_data2: d_flip_flop_n
		generic map ( N => 10)
		port map (
			clk => clk,
			rst => rst,
			d => data2,
			q => data2_intermediate
		);

	-- DECODER --
	-- we will retrieve the priority bits (0 and 3) and the data without the priority section for both links
	-- Link 1
	d_link1: Decoder 
	     port map ( 
			data_10_bits => data1_intermediate, -- input data for link 1
			data_8_bits => data1_8_bits, -- output data for link 1 if link 1 is chosen
			data0 => data01, -- second priority level
			data3 => data31 -- first priority level
		);
	
	-- Link 2
	d_link2: Decoder
	     port map ( 
			data_10_bits => data2_intermediate, -- input data for link 2
			data_8_bits => data2_8_bits, -- output data for link 2 if link 2 is chosen
			data0 => data02, -- second priority level
			data3 => data32 -- first priority level
		);
	
	-- PRIORITY AND ARBITER --
	-- we use a Round Robin Arbiter with two priority levels
	rr_arbiter: RoundRobin
	     port map ( 
			clk => clk, 
			rst => rst,
			req1 => req1_intermediate, -- request for link 1
			data01 => data01, -- second priority level of data1
			data31 => data31, -- first priority level of data1
			req2 => req2_intermediate, -- request for link 2
			data02 => data02, -- second priority level of data2
			data32 => data32, -- first priority level of data2
			valid => valid_intermediate, -- validity : '1' if output data is present, '0' otherwise
			link => link -- chosen link : '0' if link 1, '1' if link 2
		);
	
	-- we route the correct data input to data output (if we have an input link to route, otherwise data_out is set to "00000000")
	mux: Multiplexer
	     port map ( 
			data1 => data1_8_bits, -- data input for link 1
			data2 => data2_8_bits, -- data input for link 2
			valid => valid_intermediate, -- validity : '1' if output data is present, '0' otherwise
			link => link, -- chosen link : '0' if link 1, '1' if link 2
			grant1 => grant1_intermediate, -- ='1' if link 1 is chosen
			grant2 => grant2_intermediate, -- ='1' if link 1 is chosen
			data_out => data_out_intermediate -- data output => equal to the data1 or to data2 or null
		);
	
	-- REGISTERED OUTPUT --
	-- of valid --
	ff_valid: d_flip_flop
		port map (
			clk => clk,
			rst => rst,
			d => valid_intermediate,
			q => valid
		);

	-- of grant1 --
	ff_grant1: d_flip_flop
		port map (
			clk => clk,
			rst => rst,
			d => grant1_intermediate,
			q => grant1
		);
	
	-- of grant2 --
	ff_grant2: d_flip_flop
		port map (
			clk => clk,
			rst => rst,
			d => grant2_intermediate,
			q => grant2
		);
	
	-- of data_out -- 
	ff_8_data_out: d_flip_flop_n
		generic map ( N => 8)
		port map (
			clk => clk,
			rst => rst,
			d => data_out_intermediate,
			q => data_out
		);
end rtl;
