library ieee;
use ieee.std_logic_1164.all;

entity turnon_delay is 
	generic(
		max_value : integer range 0 to 2147483647 := 3
	);
	port(
		clk, en : in std_logic;
		in_bit : in std_logic;
		out_bit : out std_logic
	);
end entity;

architecture behave of turnon_delay is

	signal count : integer range 0 to max_value := 0;
	signal count_flag : std_logic := '0';
	signal out_sig : std_logic := '0';

begin

	process(clk, in_bit, en)
	begin
		if rising_edge(clk) and en='1' then
				if out_sig='0' then
					if count < max_value then
						count <= (count + 1);
					else
						out_sig <= '1';
					end if;
					
				end if;
		end if;
		if in_bit = '0' or en='0' then
			out_sig <= '0';
			count <= 0;
		end if;
	end process;

	out_bit <= out_sig and in_bit when en='1' else '0';
end architecture;