library ieee;
use ieee.std_logic_1164.all;

entity sawtooth is
	generic(
		max_value : integer range 0 to 2147483647 := 255
	);
	port(
		clk: in std_logic;
		en : in std_logic;
		output : out integer range 0 to max_value;
		overflow : out std_logic
	);
end entity;
	
architecture behave of sawtooth is

	signal counter : integer range 0 to max_value;

begin

	process(clk, en)
	begin
		if en = '0' then
			counter <= 0;
			overflow <= '0';
		elsif rising_edge(clk) and counter = max_value then
			counter <= 0;
			overflow <= '1';
		elsif rising_edge(clk) then
			counter <= counter + 1;
			overflow <= '0';
		end if;
	end process;

	output <= counter;
end architecture;