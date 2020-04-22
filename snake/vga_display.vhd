library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity VGA_display is port
 (
  -- Assuming 50MHz clock.If the clock is reduced then it might give the unexpected output.
  clock: in std_logic;
  sw: in std_logic_vector(7 downto 0);
  -- The counter tells whether the correct position on the screen is reached where the data is to be displayed.
  hcounter: in integer range 0 to 1023;
  vcounter: in integer range 0 to 1023;

  -- Output the colour that should appear on the screen.
  pixels : out std_logic_vector(7 downto 0)
 ); end VGA_display;

architecture Behavioral of VGA_display is
	-- screen dimensions
    constant MAX_X: integer := 640;
    constant MAX_Y: integer := 480;
	-- tile mesh 
	 constant TILE_SIZE: integer := 8;
	 constant TILES_X: integer := 80;
	 constant TILES_Y: integer :=60;
	 
	  -- wall left and right boundary of wall (full height)
    constant WALL_X_L: integer := 7;
    constant WALL_X_R: integer := 10;
	 -- object output signals -- new signal to indicate if
    -- scan coord is within ball
	 
    signal pixels_on, wall_on: std_logic;
    signal pixels_rgb, wall_rgb: std_logic_vector(7 downto 0);
	 
 -- Intermediate register telling the exact position on display on screen.
    signal x : integer range 0 to 1023 := 100;
    signal y : integer range 0 to 1023 := 80;
	 signal tile_x: integer range 0 to TILES_X := 0;
	 signal tile_y: integer range 0 to TILES_Y := 0;
	 signal sw_buf: std_logic_vector(7 downto 0) := sw;
begin

  sw_buf <= sw;
  x <= hcounter;
  y <= vcounter;
  -- On every positive edge of the clock counter condition is checked,
  
  video_output: process(clock) begin
	if rising_edge(clock) then
	
		-- background, switch controlled
		
		 if ( 
			 (x >= 1) and 
			 (x < 480) and 
			 (y >= 1) and 
			 (y < 640 ))
		 then  pixels_on <= '1' ;
		 else pixels_on <='0';
		 end if;
		 pixels_rgb <= sw_buf;
	 
		-- wall left vertical stripe
		 if( 
		  (WALL_X_L <= x) and(x <= WALL_X_R))
	   then wall_on <= '1';
		else wall_on <= '0';
		end if;
		wall_rgb <= "00000011"; -- blue
   end if;
  end process;
  
	process (pixels_on, wall_on, pixels_rgb, wall_rgb) begin
		if (pixels_on = '0') then pixels <= "00000000"; -- blank
		else
			if (wall_on = '1') then pixels <= wall_rgb;
			else pixels <= pixels_rgb;
			end if;
		end if;
	end process;
 end Behavioral;