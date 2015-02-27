
library ieee;
use ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
use ieee.numeric_std.all;
USE work.all;

entity DDS_RIKEN is
  port(
    clk_dds : in std_logic; -- clock in from DDS divided clock
	 clk_in0: in std_logic; --clock in from local oscillator of 25 MHz

    -- LED driver ---
	 LED_CLK: OUT STD_LOGIC;
	 LED_SDI: OUT STD_LOGIC_VECTOR (0 DOWNTO 0);
	 LED_LE: OUT STD_LOGIC;
	 LED_OE: OUT STD_LOGIC;
	 
	 ----address set pins----
	 add_in: in std_logic_vector (3 downto 0) -- set address of the DDS board (4bit)
    );

end DDS_RIKEN;

architecture behaviour of DDS_RIKEN is
	signal led_value: STD_LOGIC_VECTOR (7 downto 0);
	signal clk_system: STD_LOGIC;



begin

	led_value <= "00001111";
	
	------- generate slower clock --------
	process (clk_in0)
		variable count: integer range 0 to 21 :=0;
	begin
		if (rising_edge(clk_in0)) then
			count := count + 1;
			if (count <= 10) then
				clk_system <= '1';
			elsif (count <= 20) then
				clk_system <= '0';
			elsif (count=21) then
				count :=0;
			end if;
		end if;
	end process;
	
	
	PROCESS
		VARIABLE count_serial: INTEGER RANGE 0 to 19:=0;
	BEGIN
		WAIT UNTIL (clk_system'EVENT AND clk_system='1');
		CASE count_serial IS
			WHEN 0  => LED_OE <= '0'; LED_LE <= '0'; LED_CLK <= '0';
			WHEN 1  => LED_SDI <= LED_VALUE (7 DOWNTO 7); LED_CLK <= '0';---- first----
			WHEN 2  => LED_CLK <= '1';
			WHEN 3  => LED_SDI <= LED_VALUE (6 DOWNTO 6); LED_CLK <= '0';
			WHEN 4  => LED_CLK <= '1';
			WHEN 5  => LED_SDI <= LED_VALUE (5 DOWNTO 5); LED_CLK <= '0';
			WHEN 6  => LED_CLK <= '1';
			WHEN 7  => LED_SDI <= LED_VALUE (4 DOWNTO 4); LED_CLK <= '0';
			WHEN 8  => LED_CLK <= '1';
			WHEN 9  => LED_SDI <= LED_VALUE (3 DOWNTO 3); LED_CLK <= '0';
			WHEN 10  => LED_CLK <= '1';
			WHEN 11  => LED_SDI <= LED_VALUE (2 DOWNTO 2); LED_CLK <= '0';
			WHEN 12  => LED_CLK <= '1';
			WHEN 13  => LED_SDI <= LED_VALUE (1 DOWNTO 1); LED_CLK <= '0';
			WHEN 14  => LED_CLK <= '1';
			WHEN 15  => LED_SDI <= LED_VALUE (0 DOWNTO 0); LED_CLK <= '0';---- last bit----
			WHEN 16  => LED_CLK <= '1';
			WHEN 17 => LED_OE <= '0';LED_LE <= '1';
			WHEN 18 => LED_OE <= '0';LED_LE <= '0';
			WHEN 19 => LED_OE <= '0';LED_LE <= '0';
		END CASE;
		count_serial := count_serial +1;
		IF (count_serial = 18) THEN
			count_serial :=0;	
		END IF;
	END PROCESS;


end behaviour;
