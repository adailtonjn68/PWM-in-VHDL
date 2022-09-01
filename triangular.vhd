library ieee;
use ieee.std_logic_1164.all;

entity triangular is
	generic(
		max_value : integer range 0 to 2147483647 := 1
	);
	port(
		clk : in std_logic;
		en : in std_logic;
		output : out integer range 0 to max_value;
		underflow : out std_logic;
		period_match : out std_logic
	);
end entity;

architecture behave of triangular is

	signal counter : integer range 0 to max_value := 0;
	signal dir : std_logic := '0';

begin

	process(clk, en)
	begin
		if en='0' then
			counter <= 0;
			dir <= '0';
		elsif rising_edge(clk) then
			if dir='0' then
				
				if counter=max_value then
					dir <= '1';
					counter <= counter - 1;
				else 
				counter <= counter + 1;
				end if;

			
			elsif dir='1' then
				if counter=0 then
					dir <= '0';
					counter <= counter + 1;
				else
				counter <= counter - 1;
				end if;
			end if;
			
		end if;
	end process;
	
	process(en, counter)
	begin
		if en='0' then
			period_match <='0';
			underflow <= '0';
		else
			if counter=max_value then
				period_match <= '1';
			elsif counter=0 then
				underflow <= '1';
			else
				period_match <= '0';
				underflow <= '0';
			end if;
		end if;
	end process;
	output <= counter;

end architecture;