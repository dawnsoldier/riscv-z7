-- args: --std=08 --ieee=synopsys

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.configure.all;
use work.constants.all;
use work.functions.all;
use work.fp_wire.all;
use work.wire.all;

entity cpu is
	generic(
		bram_depth : integer := bram_depth
	);
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
end entity cpu;

architecture behavior of cpu is

	component core
		port(
			reset     : in  std_logic;
			clock     : in  std_logic;
			ibus_o    : in  mem_out_type;
			ibus_i    : out mem_in_type;
			dbus_o    : in  mem_out_type;
			dbus_i    : out mem_in_type;
			time_irpt : in  std_logic;
			ext_irpt  : in  std_logic
		);
	end component;

	component arbiter
		port(
			reset        : in  std_logic;
			clock        : in  std_logic;
			ibus_i       : in  mem_in_type;
			ibus_o       : out mem_out_type;
			dbus_i       : in  mem_in_type;
			dbus_o       : out mem_out_type;
			memory_valid : out std_logic;
			memory_ready : in  std_logic;
			memory_instr : out std_logic;
			memory_addr  : out std_logic_vector(63 downto 0);
			memory_wdata : out std_logic_vector(63 downto 0);
			memory_wstrb : out std_logic_vector(7 downto 0);
			memory_rdata : in  std_logic_vector(63 downto 0)
		);
	end component;

	component bram_mem
		port(
			clock      : in  std_logic;
			bram_wen   : in  std_logic;
			bram_waddr : in  std_logic_vector(bram_depth-1 downto 0);
			bram_raddr : in  std_logic_vector(bram_depth-1 downto 0);
			bram_wdata : in  std_logic_vector(63 downto 0);
			bram_wstrb : in  std_logic_vector(7 downto 0);
			bram_rdata : out std_logic_vector(63 downto 0)
		);
	end component;

	component timer
		port(
			reset       : in  std_logic;
			clock       : in  std_logic;
			rtc         : in  std_logic;
			timer_valid : in  std_logic;
			timer_ready : out std_logic;
			timer_instr : in  std_logic;
			timer_addr  : in  std_logic_vector(63 downto 0);
			timer_wdata : in  std_logic_vector(63 downto 0);
			timer_wstrb : in  std_logic_vector(7 downto 0);
			timer_rdata : out std_logic_vector(63 downto 0);
			timer_irpt  : out std_logic
		);
	end component;

	component ahb
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
	end component;

	signal ibus_i : mem_in_type;
	signal ibus_o : mem_out_type;
	signal dbus_i : mem_in_type;
	signal dbus_o : mem_out_type;

	signal memory_valid : std_logic;
	signal memory_ready : std_logic;
	signal memory_instr : std_logic;
	signal memory_addr  : std_logic_vector(63 downto 0);
	signal memory_wdata : std_logic_vector(63 downto 0);
	signal memory_wstrb : std_logic_vector(7 downto 0);
	signal memory_rdata : std_logic_vector(63 downto 0);

	signal bram_valid : std_logic;
	signal bram_wen   : std_logic;
	signal bram_ready : std_logic;
	signal bram_instr : std_logic;
	signal bram_addr  : std_logic_vector(bram_depth-1 downto 0);
	signal bram_wdata : std_logic_vector(63 downto 0);
	signal bram_wstrb : std_logic_vector(7 downto 0);
	signal bram_rdata : std_logic_vector(63 downto 0);

	signal timer_valid : std_logic;
	signal timer_ready : std_logic;
	signal timer_instr : std_logic;
	signal timer_addr  : std_logic_vector(63 downto 0);
	signal timer_wdata : std_logic_vector(63 downto 0);
	signal timer_wstrb : std_logic_vector(7 downto 0);
	signal timer_rdata : std_logic_vector(63 downto 0);

	signal ahb_valid : std_logic;
	signal ahb_ready : std_logic;
	signal ahb_instr : std_logic;
	signal ahb_addr  : std_logic_vector(63 downto 0);
	signal ahb_wdata : std_logic_vector(63 downto 0);
	signal ahb_wstrb : std_logic_vector(7 downto 0);
	signal ahb_rdata : std_logic_vector(63 downto 0);

	signal timer_irpt : std_logic;

begin

	process(memory_valid,memory_instr,memory_addr,memory_wdata,memory_wstrb,
					bram_rdata,bram_ready,timer_rdata,timer_ready,ahb_rdata,ahb_ready,
					bram_valid)

	begin

		if memory_valid = '1' then
			if (unsigned(memory_addr) >= unsigned(ahb_base_addr) and
					unsigned(memory_addr) < unsigned(ahb_top_addr)) then
				bram_valid <= '0';
				timer_valid <= '0';
				ahb_valid <= memory_valid;
			elsif (unsigned(memory_addr) >= unsigned(timer_base_addr) and
					unsigned(memory_addr) < unsigned(timer_top_addr)) then
				bram_valid <= '0';
				timer_valid <= memory_valid;
				ahb_valid <= '0';
			elsif (unsigned(memory_addr) >= unsigned(bram_base_addr) and
					unsigned(memory_addr) < unsigned(bram_top_addr)) then
				bram_valid <= memory_valid;
				timer_valid <= '0';
				ahb_valid <= '0';
			else
				bram_valid <= '0';
				timer_valid <= '0';
				ahb_valid <= '0';
			end if;
		else
			bram_valid <= '0';
			timer_valid <= '0';
			ahb_valid <= '0';
		end if;

		bram_wen <= bram_valid and or_reduce(memory_wstrb);
		bram_instr <= memory_instr;
		bram_addr <= memory_addr(bram_depth+2 downto 3) xor bram_base_addr(bram_depth+2 downto 3);
		bram_wdata <= memory_wdata;
		bram_wstrb <= memory_wstrb;

		timer_instr <= memory_instr;
		timer_addr <= memory_addr xor timer_base_addr;
		timer_wdata <= memory_wdata;
		timer_wstrb <= memory_wstrb;

		ahb_instr <= memory_instr;
		ahb_addr <= memory_addr xor ahb_base_addr;
		ahb_wdata <= memory_wdata;
		ahb_wstrb <= memory_wstrb;

		if (bram_ready = '1') then
			memory_rdata <= bram_rdata;
			memory_ready <= bram_ready;
		elsif (timer_ready = '1') then
			memory_rdata <= timer_rdata;
			memory_ready <= timer_ready;
		elsif (ahb_ready = '1') then
			memory_rdata <= ahb_rdata;
			memory_ready <= ahb_ready;
		else
			memory_rdata <= (others => '0');
			memory_ready <= '0';
		end if;

	end process;

	process(clock)
	begin

		if rising_edge(clock) then

			if bram_valid = '1' then
				bram_ready <= '1';
			else
				bram_ready <= '0';
			end if;

		end if;

	end process;

	core_comp : core
		port map(
			reset     => reset,
			clock     => clock,
			ibus_o    => ibus_o,
			ibus_i    => ibus_i,
			dbus_o    => dbus_o,
			dbus_i    => dbus_i,
			time_irpt => timer_irpt,
			ext_irpt  => '0'
		);

	arbiter_comp : arbiter
		port map(
			reset         => reset,
			clock         => clock,
			ibus_i        => ibus_i,
			ibus_o        => ibus_o,
			dbus_i        => dbus_i,
			dbus_o        => dbus_o,
			memory_valid  => memory_valid,
			memory_ready  => memory_ready,
			memory_instr  => memory_instr,
			memory_addr   => memory_addr,
			memory_wdata  => memory_wdata,
			memory_wstrb  => memory_wstrb,
			memory_rdata  => memory_rdata
		);

	bram_comp : bram_mem
		port map(
			clock      => clock,
			bram_wen   => bram_wen,
			bram_waddr => bram_addr,
			bram_raddr => bram_addr,
			bram_wdata => bram_wdata,
			bram_wstrb => bram_wstrb,
			bram_rdata => bram_rdata
		);

	timer_comp : timer
		port map(
			reset       => reset,
			clock       => clock,
			rtc         => rtc,
			timer_valid => timer_valid,
			timer_ready => timer_ready,
			timer_instr => timer_instr,
			timer_addr  => timer_addr,
			timer_wdata => timer_wdata,
			timer_wstrb => timer_wstrb,
			timer_rdata => timer_rdata,
			timer_irpt  => timer_irpt
		);

	ahb_comp : ahb
		port map(
			reset           => reset,
			clock           => clock,
			ahb_valid       => ahb_valid,
			ahb_ready       => ahb_ready,
			ahb_instr       => ahb_instr,
			ahb_addr        => ahb_addr,
			ahb_wdata       => ahb_wdata,
			ahb_wstrb       => ahb_wstrb,
			ahb_rdata       => ahb_rdata,
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
