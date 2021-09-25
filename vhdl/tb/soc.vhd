-- args: --std=08 --ieee=synopsys

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

use work.configure.all;
use work.constants.all;
use work.wire.all;
use work.functions.all;

entity soc is
end entity soc;

architecture behavior of soc is

	component cpu
		port(
			reset   : in  std_logic;
			clock   : in  std_logic;
			rtc     : in  std_logic;
			-- UART interface
			uart_rx : in  std_logic;
			uart_tx : out std_logic
		);
	end component;

	signal reset   : std_logic := '0';
	signal clock   : std_logic := '0';
	signal rtc     : std_logic := '0';
	signal count   : unsigned(31 downto 0) := (others => '0');
	-- UART interface
	signal uart_rx : std_logic := '1';
	signal uart_tx : std_logic := '1';

begin

	reset <= '1' after 100 ns;
	clock <= not clock after 20 ns;

	process (clock)

	begin

		if rising_edge(clock) then

			if count = clk_divider_rtc then
				rtc <= not rtc;
				count <= (others => '0');
			else
				count <= count + 1;
			end if;

		end if;

	end process;

	cpu_comp : cpu
		port map(
			reset   => reset,
			clock   => clock,
			rtc     => rtc,
			-- UART interface
			uart_rx => uart_rx,
			uart_tx => uart_tx
		);

end architecture;
