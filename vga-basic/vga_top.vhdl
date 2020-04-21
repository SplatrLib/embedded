
--/* https://langster1980.blogspot.com/2015/08/driving-vga-port-using-elbert-v2-and_7.html */

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity VGA_top_module is
    port (
        --/* Input: the 12MHz input clock */
        Clk : IN STD_LOGIC;

        --/* Output: ElbertV2 VGA Display */
        hsync : OUT STD_LOGIC;
        vsync : OUT STD_LOGIC;
        Red   : OUT STD_LOGIC_VECTOR(2 downto 0);
        Green : OUT STD_LOGIC_VECTOR(2 downto 0);
        Blue  : OUT STD_LOGIC_VECTOR(2 downto 1)
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

            -- Output for the VGA Display
            hsync    : out std_logic;
            vsync    : out std_logic;
            Red      : out std_logic_vector(2 downto 0);
            Green    : out std_logic_vector(2 downto 0);
            Blue     : out std_logic_vector(2 downto 1)
        );
    end component;

    signal  clock   : std_logic := '0';

begin architecture Behavioral

    clocking: clocking_inst
    port map (
        CLKIN_IN        => Clk,
        CLKFX_OUT       => clock
    );

    VGA_inst: VGA_sync
    port map (
        Clk   => clock,
        hsync => hsync,
        vsync => vsync,
        Red   => Red,
        Green => Green,
        Blue  => Blue
    );

end architecture Behavioral;
