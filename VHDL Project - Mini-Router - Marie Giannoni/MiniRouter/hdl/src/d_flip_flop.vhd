library IEEE;
use IEEE.std_logic_1164.all;

entity d_flip_flop is
	port(
		clk: in std_logic;
		rst: in std_logic;
		d: in std_logic;
		q: out std_logic
      	);
end d_flip_flop;

architecture rtl of d_flip_flop is

begin
	d_flip_flop_process: process (clk, rst)
	begin
		if (rst = '0') then -- asynchronous low reset
			q <= '0';
		elsif (rising_edge(clk)) then -- when the clk is high and on a rising edge, we give to q the value of d
			q <= d;
		end if;
	end process; 
end rtl;

