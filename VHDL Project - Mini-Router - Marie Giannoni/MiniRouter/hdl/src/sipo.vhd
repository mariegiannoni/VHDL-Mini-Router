library IEEE;
use IEEE.std_logic_1164.all;

----------
-- SIPO --
----------

-- to convert a serial input to a parallel output

entity sipo is
    generic(N: integer); 
	port(
		clk: in std_logic;
		rst: in std_logic;
		serial_input: in std_logic;
		parallel_output: out std_logic_vector(N-1 downto 0)
      	);
end sipo;

architecture rtl of sipo is
signal intermediate: std_logic_vector(N-1 downto 0);

begin
	sipo_process: process (clk, rst)
	begin
		if (rst = '0') then -- asynchronous low reset
			intermediate <= (others => '0');
		elsif (rising_edge(clk)) then -- when the clk is high and on a rising edge
			-- we shift by one bit the signal
			intermediate(N-1 downto 1) <= intermediate(N-2 downto 0);
			-- we insert the new bit
			intermediate(0) <= serial_input;
		end if;
	end process; 
	
	parallel_output <= intermediate;
end rtl;
