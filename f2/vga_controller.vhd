  
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library work;

entity vga_controller is
    Port ( clock: in  std_logic;
	 
           hsync : out  std_logic;
           vsync : out  std_logic;
			  
	        pixle: in  std_logic_vector(7 downto 0);
           rgb : out  std_logic_vector (7 downto 0);
			  
			  pos_x: out integer range 0 to 1023 := 641;
			  pos_y: out integer range 0 to 1023 := 480
          );
end vga_controller;

architecture Behavioral of vga_controller is
		signal rgb_out: std_logic_vector(7 downto 0);
		signal synh, synv: std_logic := '0';

     -- Set the resolution of the frame - 640 x 480
        signal hCount: integer range 0 to 1023 := 640;
        signal vCount: integer range 0 to 1023 := 480;

     -- Set the count from where it should start
        signal nextHCount: integer range 0 to 1023 := 641;
        signal nextVCount: integer range 0 to 1023 := 480;

begin
	rgb <= rgb_out;
	hsync <= synh;
	vsync <= synv;
	pos_x <= nextHCount;
	pos_y <= nextVCount;

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
                    then synv <= '0';
                    else synv <= '1';
                end if;

                -- Check if the Hcount is within the minimum and maximum value for the horizontal sync signal
                if (hCount >= 656 and hCount < 752)
                    then synh <= '0';
                    else synh <= '1';
                end if;

                -- If the Vcounter and Hcounter are within 640 and 480 then display the pixels.
                if (hCount < 640 and vCount < 480)
                then
                    --this section of code will cause the display to be Red
                    rgb_out <= pixle;
                end if;
            end if;

            -- Set divide_by_2 to zero
            divide_by_2 := not divide_by_2;
        end if;
    end process;

end architecture Behavioral;