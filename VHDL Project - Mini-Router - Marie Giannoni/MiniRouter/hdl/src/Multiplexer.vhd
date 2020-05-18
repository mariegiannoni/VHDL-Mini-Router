library IEEE;
use IEEE.std_logic_1164.all;

-----------------
-- MULTIPLEXER --
-----------------

entity Multiplexer is
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
end Multiplexer;

architecture rtl of Multiplexer is

signal valid_link: std_logic_vector(1 downto 0);

begin
    valid_link <= valid & link; -- we concatenate valid and link for simplicity
    multiplexer_process: process(valid_link, data1, data2)
    begin
        case valid_link is
            when "00" => -- no link is selected
                data_out <= "00000000";
                grant1 <= '0';
                grant2 <= '0';
            when "01" => -- no link is selected
                data_out <= "00000000";
                grant1 <= '0';
                grant2 <= '0';
            when "10" => -- link 1 is selected
                data_out <= data1;
                grant1 <= '1';
                grant2 <= '0';
            when "11" => -- link2 is selected
                data_out <= data2;
                grant1 <= '0';
                grant2 <= '1';
            when others => null;
        end case;
    end process;
end rtl;