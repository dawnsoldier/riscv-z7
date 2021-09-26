-- args: --std=08 --ieee=synopsys

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.configure.all;
use work.wire.all;
use work.functions.all;

entity ahb is
	port(
		reset           : in  std_logic;
		clock           : in  std_logic;
		ahb_valid       : in  std_logic;
		ahb_ready       : out std_logic;
		ahb_instr       : in  std_logic;
		ahb_addr        : in  std_logic_vector(63 downto 0);
		ahb_wdata       : in  std_logic_vector(63 downto 0);
		ahb_wstrb       : in  std_logic_vector(7 downto 0);
		ahb_rdata       : out std_logic_vector(63 downto 0);
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
end ahb;

architecture behavior of ahb is

	type state_type is (IDLE, ACTIVE);

	type register_type is record
		state : state_type;
	end record;

	constant init_register : register_type := (
		state => IDLE
	);

	signal r,rin : register_type := init_register;

begin

	process(r,ahb_valid,ahb_instr,ahb_addr,ahb_wdata,ahb_wstrb,
					m_ahb_hready,m_ahb_hresp,m_ahb_hrdata)

	variable v : register_type;

	begin

		v := r;

		case r.state is
			when IDLE =>
				if ahb_valid = '1' then
					v.state := ACTIVE;
				end if;
			when ACTIVE =>
				null;
			when others =>
				null;
		end case;

		rin <= v;

	end process;

	process(clock)

	begin

		if (rising_edge(clock)) then

			if (reset = reset_active) then
				r <= init_register;
			else
				r <= rin;
			end if;

		end if;

	end process;

end architecture;
