library IEEE;
use IEEE.std_logic_1164.all;

-------------------
-- D FLIP FLOP N --
-------------------

entity d_flip_flop_n is
	generic(N: integer); 
	Port(
		clk: in std_logic;
		rst: in std_logic;
		d: in std_logic_vector(N-1 downto 0);
		q: out std_logic_vector(N-1 downto 0)
	    );
end d_flip_flop_n;

architecture rtl of d_flip_flop_n is

begin
	d_flip_flop_n_process: process (clk, rst)
	begin
		if (rst = '0') then -- asynchronous low reset
			q <= (others => '0');
		elsif (rising_edge(clk)) then -- when the clk is high and on a rising edge, we give to q the value of d for all the bits
			q(N-1 downto 0) <= d(N-1 downto 0);
		end if;
	end process; 
end rtl;