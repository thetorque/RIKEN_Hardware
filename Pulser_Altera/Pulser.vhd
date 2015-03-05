---------------
--- Pulser ----
---------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_misc.all;
use IEEE.std_logic_unsigned.all;

use work.FRONTPANEL.all;

entity Pulser is
	port (
		okUH      : in     STD_LOGIC_VECTOR(4 downto 0);
		okHU      : out    STD_LOGIC_VECTOR(2 downto 0);
		okUHU     : inout  STD_LOGIC_VECTOR(31 downto 0);
		okAA      : inout  STD_LOGIC;

		sys_clk   : in     STD_LOGIC;
		
		---- Puler pins connection ----
		dds_bus_out	:out		std_LOGIC_VECTOR(31 downto 0);
		dds_bus_in	:in 		std_logic_vector(7 downto 0);
		ttl_out		:out		std_logic_vector(35 downto 0);
		aux_clk_in	:in		std_logic;
		aux_io		:out		std_LOGIC_VECTOR(17 downto 0);
		pmt_in		:in		std_logic;
		trigger_in	:in		std_logic;
		aux_in		:in		std_logic;
		
		
		---- LED on the module ---
		led       : out    STD_LOGIC_VECTOR(1 downto 0);
		---- LED on the breakout board ----
		led_array : out    STD_LOGIC_VECTOR(7 downto 0)
	);
end Pulser;

architecture arch of Pulser is
	signal okClk      : STD_LOGIC;
	signal okHE       : STD_LOGIC_VECTOR(112 downto 0);
	signal okEH       : STD_LOGIC_VECTOR(64 downto 0);
	signal okEHx      : STD_LOGIC_VECTOR(65*5-1 downto 0);
	
	signal ep00wire   : STD_LOGIC_VECTOR(31 downto 0);
	signal ep20wire   : STD_LOGIC_VECTOR(31 downto 0);
	signal ep21wire   : STD_LOGIC_VECTOR(31 downto 0);
	signal ep22wire   : STD_LOGIC_VECTOR(31 downto 0);
	signal ep40wire   : STD_LOGIC_VECTOR(31 downto 0);
	signal ep60trig   : STD_LOGIC_VECTOR(31 downto 0);
	signal ep61trig   : STD_LOGIC_VECTOR(31 downto 0);


	
begin





-- Instantiate the okHost and connect endpoints
okHI : okHost port map (
	okUH=>okUH, 
	okHU=>okHU, 
	okUHU=>okUHU, 
	okAA=>okAA,
	okClk=>okClk, 
	okHE=>okHE, 
	okEH=>okEH
);

okWO : okWireOR     generic map (N=>5) port map (okEH=>okEH, okEHx=>okEHx);

ep00 : okWireIn     port map (okHE=>okHE,                                    ep_addr=>x"00", ep_dataout=>ep00wire);
ep20 : okWireOut    port map (okHE=>okHE, okEH=>okEHx( 1*65-1 downto 0*65 ), ep_addr=>x"20", ep_datain=>ep20wire);
ep21 : okWireOut    port map (okHE=>okHE, okEH=>okEHx( 2*65-1 downto 1*65 ), ep_addr=>x"21", ep_datain=>ep21wire);
ep22 : okWireOut    port map (okHE=>okHE, okEH=>okEHx( 3*65-1 downto 2*65 ), ep_addr=>x"22", ep_datain=>ep22wire);
ep40 : okTriggerIn  port map (okHE=>okHE,                                    ep_addr=>x"40", ep_clk=>sys_clk, ep_trigger=>ep40wire);
ep60 : okTriggerOut port map (okHE=>okHE, okEH=>okEHx( 4*65-1 downto 3*65 ), ep_addr=>x"60", ep_clk=>sys_clk, ep_trigger=>ep60trig);
ep61 : okTriggerOut port map (okHE=>okHE, okEH=>okEHx( 5*65-1 downto 4*65 ), ep_addr=>x"61", ep_clk=>sys_clk, ep_trigger=>ep61trig);

end arch;