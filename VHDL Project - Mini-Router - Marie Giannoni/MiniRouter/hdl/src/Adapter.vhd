library IEEE;
use IEEE.std_logic_1164.all;

-------------
-- ADAPTER --
-------------

entity Adapter is
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
end Adapter;

architecture rtl of Adapter is
----------
-- SIPO --
----------

--To convert the serial input into parallel output 
component sipo is
    generic(N: integer); 
	port(
		clk: in std_logic;
		rst: in std_logic;
		serial_input: in std_logic;
		parallel_output: out std_logic_vector(N-1 downto 0)
      	);
end component;

----------
-- PISO --
----------

-- To convert parallel input into serial output
component piso is
    generic(N: integer); 
	port(
		clk: in std_logic;
		rst: in std_logic;
		load: in std_logic;
		parallel_input: in std_logic_vector(N-1 downto 0);
		serial_output: out std_logic
      	);
end component;

-----------------
-- D FLIP FLOP --
-----------------

component d_flip_flop is
	port(
		clk: in std_logic;
		rst: in std_logic;
		d: in std_logic;
		q: out std_logic
      	);
end component;


----------------
-- MINIROUTER --
----------------

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

-------------
-- SIGNALS --
-------------

-- LINK 1 --
signal data1_parallel: std_logic_vector(9 downto 0);
signal data1_serial_intermediate: std_logic;
signal req1_intermediate: std_logic;
signal grant1_intermediate : std_logic;

-- LINK 2 --
signal data2_parallel: std_logic_vector(9 downto 0);
signal data2_serial_intermediate: std_logic;
signal req2_intermediate: std_logic;
signal grant2_intermediate : std_logic;

-- VALID --
signal valid_intermediate : std_logic;

-- DATA OUTPUT --
signal data_out_parallel: std_logic_vector(7 downto 0);
signal data_out_intermediate: std_logic;

begin
    -- REGISTERS FOR SERIAL INPUT --
    ff_data1_serial: d_flip_flop
		port map (
			clk => clk,
			rst => rst,
			d => data1_serial,
			q => data1_serial_intermediate
		);
		
	ff_data2_serial: d_flip_flop
		port map (
			clk => clk,
			rst => rst,
			d => data2_serial,
			q => data2_serial_intermediate
		);

    -- REGISTERED INPUT --
	-- of req1 --
	ff_req1: d_flip_flop
		port map (
			clk => clk,
			rst => rst,
			d => req1,
			q => req1_intermediate
		);

	-- of req2 --
	ff_req2: d_flip_flop
		port map (
			clk => clk,
			rst => rst,
			d => req2,
			q => req2_intermediate
		);

	-- of data1 --
	ff_data1: d_flip_flop
		port map (
			clk => clk,
			rst => rst,
			d => data1_serial,
			q => data1_serial_intermediate
		);

	-- of data2 --
	ff_data2: d_flip_flop
		port map (
			clk => clk,
			rst => rst,
			d => data2_serial,
			q => data2_serial_intermediate
		);
    
    -- REGISTER FOR SERIAL OUTPUT --
	ff_data_out_serial: d_flip_flop
		port map (
			clk => clk,
			rst => rst,
			d => data_out_intermediate,
			q => data_out_serial
		);
		
    -- REGISTER FOR VALID --
	ff_valid: d_flip_flop
		port map (
			clk => clk,
			rst => rst,
			d => valid_intermediate,
			q => valid
		);

    -- REGISTERED OUTPUT --
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

    -- SIPO --
    sipo_data1: sipo
		generic map ( N => 10)
		port map (
			clk => clk,
			rst => rst,
			serial_input => data1_serial_intermediate,
			parallel_output => data1_parallel
		);
		
	sipo_data2: sipo
		generic map ( N => 10)
		port map (
			clk => clk,
			rst => rst,
			serial_input => data2_serial_intermediate,
			parallel_output => data2_parallel
		);
		
    -- PISO --
    piso_data_out: piso
        generic map ( N => 8)
		port map (
			clk => clk,
			rst => rst,
			load => valid_intermediate,
			parallel_input => data_out_parallel,
			serial_output => data_out_intermediate
		);
		
    -- Mini-Router --
    mini_router: MiniRouter
        port map(
            clk => clk,
            rst => rst,
            data1 => data1_parallel,
            req1 => req1_intermediate,
            data2 => data2_parallel,
            req2 => req2_intermediate,
            grant1 => grant1_intermediate,
            grant2 => grant2_intermediate,
            valid => valid_intermediate,
            data_out => data_out_parallel
        );
	
end rtl;
