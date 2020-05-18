library IEEE;
use IEEE.std_logic_1164.all;

entity piso_tb is 
end piso_tb ;

architecture test of piso_tb is

----------
-- PISO --
----------

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

------------
-- SIGNAL --
------------
constant T_CLK: time := 100 ns;
constant N_tb: integer := 8;
signal load_tb : std_logic := '0';
signal clk_tb : std_logic := '0';
signal rst_tb : std_logic := '0';
signal end_sim : std_logic := '0';
signal pi_tb : std_logic_vector(N_tb-1 downto 0);
signal so_tb : std_logic;

begin
piso_tb: piso
     generic map ( N => N_tb )
     port map (
			clk => clk_tb,
			rst => rst_tb,
			load => load_tb,
			parallel_input => pi_tb,
			serial_output => so_tb
		    );
clk_tb <= not(clk_tb) or end_sim after T_CLK / 2;
rst_tb <= '1' after 3*T_CLK;
end_sim <= '1' after 25*T_CLK;

test_process : process(rst_tb, clk_tb)
	variable t: integer := 0;
	begin
	if(rst_tb = '0') then
		pi_tb <= (others => '0');
	elsif (rising_edge(clk_tb)) then
		case(t) is
			when 0 => 
				pi_tb <= "11011010";
				load_tb <= '1';
			when 1 =>
				load_tb <= '0';
				pi_tb <= "11111111";
			when others => null;
		end case;
		t := t+1;
	end if;
	end process;
end test;
