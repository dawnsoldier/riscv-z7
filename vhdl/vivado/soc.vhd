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
	port(
		reset           : in  std_logic;
		clock           : in  std_logic;
		-- Master AHB-Lite interface
		m_ahb_haddr     : out std_logic_vector(63 downto 0);
		m_ahb_hburst    : out std_logic_vector(2 downto 0);
		m_ahb_hmastlock : out std_logic;
		m_ahb_hprot     : out std_logic_vector(3 downto 0);
		m_ahb_hrdata    : in  std_logic_vector(63 downto 0);
		m_ahb_hready    : in  std_logic;
		m_ahb_hresp     : in  std_logic;
		m_ahb_hsize     : out std_logic_vector(2 downto 0);
		m_ahb_htrans    : out std_logic_vector(1 downto 0);
		m_ahb_hwdata    : out std_logic_vector(63 downto 0);
		m_ahb_hwrite    : out std_logic
	);
end entity soc;

architecture behavior of soc is

	component cpu
		port(
			reset           : in  std_logic;
			clock           : in  std_logic;
			rtc             : in  std_logic;
			-- Master AHB-Lite interface
			m_ahb_haddr     : out std_logic_vector(63 downto 0);
			m_ahb_hburst    : out std_logic_vector(2 downto 0);
			m_ahb_hmastlock : out std_logic;
			m_ahb_hprot     : out std_logic_vector(3 downto 0);
			m_ahb_hrdata    : in  std_logic_vector(63 downto 0);
			m_ahb_hready    : in  std_logic;
			m_ahb_hresp     : in  std_logic;
			m_ahb_hsize     : out std_logic_vector(2 downto 0);
			m_ahb_htrans    : out std_logic_vector(1 downto 0);
			m_ahb_hwdata    : out std_logic_vector(63 downto 0);
			m_ahb_hwrite    : out std_logic
		);
	end component;

	signal rtc   : std_logic := '0';
	signal count : unsigned(31 downto 0) := (others => '0');

	signal clk_pll   : std_logic := '0';
	signal count_pll : unsigned(31 downto 0) := (others => '0');

begin

	process (clock)

	begin

		if rising_edge(clock) then
			if count = clk_divider_rtc then
				rtc <= not rtc;
				count <= (others => '0');
			else
				count <= count + 1;
			end if;

			if count_pll = clk_divider_pll then
				clk_pll <= not clk_pll;
				count_pll <= (others => '0');
			else
				count_pll <= count_pll + 1;
			end if;
		end if;

	end process;

	cpu_comp : cpu
		port map(
			reset           => reset,
			clock           => clk_pll,
			rtc             => rtc,
			-- Master AHB-Lite interface
			m_ahb_haddr     => m_ahb_haddr,
			m_ahb_hburst    => m_ahb_hburst,
			m_ahb_hmastlock => m_ahb_hmastlock,
			m_ahb_hprot     => m_ahb_hprot,
			m_ahb_hrdata    => m_ahb_hrdata,
			m_ahb_hready    => m_ahb_hready,
			m_ahb_hresp     => m_ahb_hresp,
			m_ahb_hsize     => m_ahb_hsize,
			m_ahb_htrans    => m_ahb_htrans,
			m_ahb_hwdata    => m_ahb_hwdata,
			m_ahb_hwrite    => m_ahb_hwrite
		);

end architecture;
