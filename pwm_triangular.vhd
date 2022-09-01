library ieee;
use ieee.std_logic_1164.all;

entity pwm_triangular is
	generic(
		max_value : integer range 0 to 2147483647 := 3
	);
	port(
		clk : in std_logic;
		en : in std_logic;
		input : in integer range 0 to max_value;
		output : out std_logic;
		period_match : out std_logic;
		underflow : out std_logic;
		triangular_value : out integer range 0 to max_value
	);
end entity;

architecture behave of pwm_triangular is

	component triangular is
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
	end component;
	
	signal output_sig : std_logic := '0';
	signal period_match_sig : std_logic := '0';
	signal underflow_sig : std_logic := '0';
	signal interruption_sig : std_logic := '0';
	signal input_sig : integer range 0 to max_value := 0;
	signal triangular_value_sig: integer range 0 to max_value:= 0;

begin

	triangular_wave: triangular
		generic map (
			max_value=>max_value
		)
		port map (
			clk=>clk,
			en=>en,
			output=>triangular_value_sig,
			underflow=>underflow_sig,
			period_match=>period_match_sig
		);
	
	process(input, interruption_sig)
	begin
		if rising_edge(interruption_sig) then
			input_sig <= input;
		end if;
		
		if input_sig > triangular_value_sig then
			output_sig <= '1';
		else
			output_sig <= '0';
		end if;
	end process;
	
	interruption_sig <= (period_match_sig or underflow_sig) when en='1' else '0';
	triangular_value <= triangular_value_sig when en='1' else 0;
	period_match <= period_match_sig when en='1' else '0';
	underflow <= underflow_sig when en='1' else '0';
	output <= output_sig when en='1' else '0';

end architecture;