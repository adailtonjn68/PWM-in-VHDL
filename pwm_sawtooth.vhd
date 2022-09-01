library ieee;
use ieee.std_logic_1164.all;

entity pwm_sawtooth is
	generic(
		max_value : integer range 0 to 2147483647 := 7
	);
	port(
		clk : in std_logic;
		en : in std_logic;
		input: in integer range 0 to max_value;
		output : out std_logic;
		sawtooth_count : out integer range 0 to max_value;
		overflow : out std_logic
	);
end entity;

architecture behave of pwm_sawtooth is

	component sawtooth is
		generic(
			max_value : integer range 0 to 2147483647 := 255
		);
		port(
			clk: in std_logic;
			en : in std_logic;
			output : out integer range 0 to max_value;
			overflow : out std_logic
		);
	end component;

	signal output_sig : std_logic := '0';
	signal sawtooth_value_internal : integer range 0 to max_value;
	signal input_internal : integer range 0 to max_value := 0;
	signal overflow_internal : std_logic := '0';

begin
	

	sawtooth1: sawtooth 
		generic map(
			max_value=>max_value
		)
		port map(
			clk=>clk,
			en=>en,
			output=>sawtooth_value_internal,
			overflow=>overflow_internal
		);
	
	process(input,overflow_internal) 
	begin
		if input_internal > sawtooth_value_internal then
			output_sig <= '1';
		else
			output_sig <= '0';
		end if;
		
		if rising_edge(overflow_internal) then
			input_internal <= input;
		end if;
	end process;
	
	overflow <= overflow_internal;
	output <= output_sig when en='1' else '0';
	sawtooth_count <= sawtooth_value_internal;
end architecture;