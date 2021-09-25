-- args: --std=08 --ieee=synopsys

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.configure.all;
use work.wire.all;
use work.functions.all;

entity avalon is
	port(
		reset                      : in  std_logic;
		clock                      : in  std_logic;
		avalon_valid               : in  std_logic;
		avalon_ready               : out std_logic;
		avalon_instr               : in  std_logic;
		avalon_addr                : in  std_logic_vector(63 downto 0);
		avalon_wdata               : in  std_logic_vector(63 downto 0);
		avalon_wstrb               : in  std_logic_vector(7 downto 0);
		avalon_rdata               : out std_logic_vector(63 downto 0);
		-- Master Avalon interface
		m_avalon_address           : out std_logic_vector(63 downto 0);
		m_avalon_byteenable        : out std_logic_vector(7 downto 0);
		m_avalon_debugaccess       : out std_logic;
		m_avalon_read              : out std_logic;
		m_avalon_readdata          : in  std_logic_vector(63 downto 0);
		m_avalon_response          : in  std_logic_vector(1 downto 0);
		m_avalon_write             : out std_logic;
		m_avalon_writedata         : out std_logic_vector(63 downto 0);
		m_avalon_lock              : out std_logic;
		m_avalon_waitrequest       : in  std_logic;
		m_avalon_readdatavalid     : in  std_logic;
		m_avalon_writereponsevalid : in  std_logic;
		m_avalon_burstcount        : out std_logic_vector(2 downto 0)
	);
end avalon;

architecture behavior of avalon is

	type state_type is (IDLE, SEND, GET);

	type register_type is record
		state : state_type;
	end record;

	constant init_register : register_type := (
		state => IDLE
	);

	signal r,rin : register_type := init_register;

begin

	process(r,avalon_valid,avalon_instr,avalon_addr,avalon_wdata,avalon_wstrb,
					m_avalon_readdata,m_avalon_response,m_avalon_waitrequest,
					m_avalon_readdatavalid,m_avalon_writereponsevalid)

	variable v : register_type;

	begin

		v := r;

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
