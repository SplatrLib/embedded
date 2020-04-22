library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library work;

entity VGA_sync is
    Port ( Clk : in  STD_LOGIC;
	        sw : in std_logic_vector(7 downto 0);
           hsync : out  STD_LOGIC;
           vsync : out  STD_LOGIC;
           rgb : out  STD_LOGIC_VECTOR (7 downto 0)
          );
end VGA_sync;

architecture Behavioral of VGA_sync is

     -- Intermediate register used internally
        signal clock: std_logic := '0';

     -- Internal register to store the colour required
        signal clr: std_logic_vector(7 downto 0);

     -- Set the resolution of the frame - 640 x 480
        signal hCount: integer range 0 to 1023 := 640;
        signal vCount: integer range 0 to 1023 := 480;

     -- Set the count from where it should start
        signal nextHCount: integer range 0 to 1023 := 641;
        signal nextVCount: integer range 0 to 1023 := 480;

begin

    -- Divide the clock from 100 MHz to 50 MHz
    divideClock: process(Clk) begin
        if rising_edge (Clk) then
            clock <= not clock;
        end if;
    end process;

    -- create a file which contains the code which causes something to be displayed.
    -- The clock which should be given here is 50MHz
    VGA_display: entity work.VGA_display
    port map(
        clock =>  clock,
		  sw => sw,
        hcounter  =>  nextHCount,
        vcounter => nextVCount,
        pixels  => clr
    );

    -- The process is carried out for every positive edge of the clock
    vgasignal: process(clock)
        variable divide_by_2 : std_logic := '0';
    begin
        -- Make sure the process begins at the correct point between sync pulses
        if rising_edge(clock) then
            -- Further divide down the clock from 50 MHz to 25 MHz
            if divide_by_2 = '1' then
                -- Has an entire scanline been displayed?
                if(hCount = 799)
                    then hCount <= 0;
                        -- Has an entire frame been displayed?
                        if(vCount = 524)
                            then vCount <= 0;
                            else vCount <= vCount + 1;
                        end if;
                else hCount <= hCount + 1;
                end if;

                -- Once the Hcounter has reached the end of the line we reset it to zero
                if (nextHCount = 799)
                    then nextHCount <= 0;

                    -- Once the frame has been displayed then reset the Vcounter to zero
                    if (nextVCount = 524)
                        then nextVCount <= 0;
                        else nextVCount <= vCount + 1;
                    end if;

                else nextHCount <= hCount + 1;
                end if;

                -- Check if the Vcount is within the minimum and maximum value for the vertical sync signal
                if (vCount >= 490 and vCount < 492)
                    then vsync <= '0';
                    else vsync <= '1';
                end if;

                -- Check if the Hcount is within the minimum and maximum value for the horizontal sync signal
                if (hCount >= 656 and hCount < 752)
                    then hsync <= '0';
                    else hsync <= '1';
                end if;

                -- If the Vcounter and Hcounter are within 640 and 480 then display the pixels.
                if (hCount < 640 and vCount < 480)
                then
                    --this section of code will cause the display to be Red
                    rgb <= clr (7 downto 0);
                end if;
            end if;

            -- Set divide_by_2 to zero
            divide_by_2 := not divide_by_2;
        end if;
    end process;

end architecture Behavioral;