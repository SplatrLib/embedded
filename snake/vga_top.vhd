
--/* https://langster1980.blogspot.com/2015/08/driving-vga-port-using-elbert-v2-and_7.html */

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity VGA_top_module is
    port (
        --/* Input: the 12MHz input clock */
        Clk : IN STD_LOGIC;
		  sw : in std_logic_vector(7 downto 0);
        --/* Output: ElbertV2 VGA Display */
        hsync : OUT STD_LOGIC;
        vsync : OUT STD_LOGIC;
        rgb   : OUT STD_LOGIC_VECTOR(7 downto 0);
		  UP: in std_logic;
		  DOWN: in std_logic;
		  LEFT: in std_logic;
		  RIGHT: in std_logic;
		  START: in std_logic;
		  RESET: in std_logic
    );

end VGA_top_module;

architecture Behavioral of VGA_top_module is

    component clocking_inst
        port(
            --/*Input clock of 12MHz */
            CLKIN_IN         : in     std_logic;

            --/* Output clock has to been set to 100 MHz.
            --If input clock frequency changes then update clocking_inst to reflect the change */
            CLKFX_OUT          : out    std_logic
        );
    end component;

    component VGA_sync
        port    (
            -- Input Clock 100MHz
            Clk   : in std_logic;
				sw: in std_logic_vector(7 downto 0);
            -- Output for the VGA Display
            hsync    : out std_logic;
            vsync    : out std_logic;
            rgb      : out std_logic_vector(7 downto 0);
				UP: in std_logic;
			  DOWN: in std_logic;
			  LEFT: in std_logic;
			  RIGHT: in std_logic;
			  START: in std_logic;
			  RESET: in std_logic
        );
    end component;

    signal  clock   : std_logic := '0';

begin 

    clocking: clocking_inst
    port map (
        CLKIN_IN        => Clk,
        CLKFX_OUT       => clock
    );

    VGA_inst: VGA_sync
    port map (
        Clk   => clock,
		  sw => sw,
        hsync => hsync,
        vsync => vsync,
        rgb => rgb,
		  UP => UP,
			DOWN => DOWN,
			LEFT => LEFT,
			RIGHT => RIGHT,
			START => START,
			RESET => RESET
    );

end architecture Behavioral;