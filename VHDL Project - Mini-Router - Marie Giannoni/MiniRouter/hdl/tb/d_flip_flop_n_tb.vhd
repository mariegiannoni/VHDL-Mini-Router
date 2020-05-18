library IEEE;
use IEEE.std_logic_1164.all;

entity d_flip_flop_n_tb is 
end d_flip_flop_n_tb ;

architecture test of d_flip_flop_n_tb is

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
constant T_CLK: time := 100 ns;
constant N_tb: integer := 4;
signal clk_tb : std_logic := '0';
signal rst_tb : std_logic := '0';
signal end_sim : std_logic := '0';
signal d_tb : std_logic_vector(N_tb-1 downto 0);
signal q_tb : std_logic_vector(N_tb-1 downto 0);

begin
off_n: d_flip_flop_n
     generic map ( N => N_tb )
     port map (
     			d => d_tb,
			q => q_tb,
			clk => clk_tb,
			rst => rst_tb
		    );
clk_tb <= not(clk_tb) or end_sim after T_CLK / 2;
rst_tb <= '1' after 3*T_CLK;
end_sim <= '1' after 100*T_CLK;

test_process : process(rst_tb, clk_tb)
	variable t: integer := 0;
	begin
	if(rst_tb = '0') then
		d_tb <= (others => '0');
	elsif (rising_edge(clk_tb)) then
		case(t) is
			when 0 => d_tb <= (others => '0');
			when 1 => d_tb <= (others => '1');
			when 2 => d_tb <= (others => '0');
			when others => null;
		end case;
		t := t+1;
	end if;
	end process;
end test;