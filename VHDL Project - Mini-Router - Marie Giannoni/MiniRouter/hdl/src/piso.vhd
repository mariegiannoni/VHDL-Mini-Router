library IEEE;
use IEEE.std_logic_1164.all;

----------
-- PISO --
----------

-- to convert a serial input to a parallel output

entity piso is
    generic(N: integer); 
	port(
		clk: in std_logic;
		rst: in std_logic;
		load: in std_logic;
		parallel_input: in std_logic_vector(N-1 downto 0);
		serial_output: out std_logic
      	);
end piso;

architecture rtl of piso is
signal intermediate: std_logic_vector(N-1 downto 0);

begin
	piso_process: process (clk, rst, load, parallel_input, intermediate)
	begin
		if (rst = '0') then -- asynchronous low reset
			intermediate <= (others => '0');
		elsif(load = '1') then
			-- we give to intermediate the value of parallel_input
		        intermediate <= parallel_input;
		elsif (rising_edge(clk)) then -- when the clk is high and on a rising edge
		    	-- we give the the output the value of the LSB
	                serial_output <= intermediate(N-1);
		    	-- we shift by one bit the signal
		    	intermediate(N-1 downto 0) <= intermediate(N-2 downto 0) & '0';
		end if;
	end process; 
end rtl;