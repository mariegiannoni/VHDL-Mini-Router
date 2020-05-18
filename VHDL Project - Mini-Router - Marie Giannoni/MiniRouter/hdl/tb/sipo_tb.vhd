library IEEE;
use IEEE.std_logic_1164.all;

entity sipo_tb is 
end sipo_tb ;

architecture test of sipo_tb is

-----------
-- DSIPO --
-----------

component sipo is
    generic(N: integer); 
	port(
		clk: in std_logic;
		rst: in std_logic;
		serial_input: in std_logic;
		parallel_output: out std_logic_vector(N-1 downto 0)
      	);
end component;

------------
-- SIGNAL --
------------
constant T_CLK: time := 100 ns;
constant N_tb: integer := 8;
signal clk_tb : std_logic := '0';
signal rst_tb : std_logic := '0';
signal end_sim : std_logic := '0';
signal si_tb : std_logic;
signal po_tb : std_logic_vector(N_tb-1 downto 0);

begin
sipo_tb: sipo
     generic map ( N => N_tb )
     port map (
			clk => clk_tb,
			rst => rst_tb,
			serial_input => si_tb,
			parallel_output => po_tb
		    );
clk_tb <= not(clk_tb) or end_sim after T_CLK / 2;
rst_tb <= '1' after 3*T_CLK;
end_sim <= '1' after 15*T_CLK;

test_process : process(rst_tb, clk_tb)
	variable t: integer := 0;
	begin
	if(rst_tb = '0') then
		si_tb <= '0';
	elsif (rising_edge(clk_tb)) then
		case(t) is -- OUTPUT : "11011010"
			when 0 => si_tb <= '1';
			when 1 => si_tb <= '1';
			when 2 => si_tb <= '0';
			when 3 => si_tb <= '1';
			when 4 => si_tb <= '1';
			when 5 => si_tb <= '0';
			when 6 => si_tb <= '1';
			when 7 => si_tb <= '0';
			when others => null;
		end case;
		t := t+1;
	end if;
	end process;
end test;
