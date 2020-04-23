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
	constant TILES_X: integer := 60;
	constant TILES_Y: integer := 60;

	-- border wall
	constant WALL_THICKNESS: integer := 2;

	-- object signals indicate if we are within on eof the objects
	signal pixels_on, wall_on, pgrid_on, tgrid_on: std_logic;
	signal pixels_rgb, wall_rgb, pgrid_rgb, tgrid_rgb: std_logic_vector(7 downto 0);
	 
	-- Intermediate register telling the exact position on display on screen.
	signal x : integer range 0 to 1023 := 100;
	signal y : integer range 0 to 1023 := 80;
	signal tile_x,tile_y: integer := 0;
	signal sw_buf: std_logic_vector(7 downto 0) := sw;
	signal x_grd, y_grd, tx_grd, ty_grd: integer range 0 to 7 := 0;

begin
  sw_buf <= sw;
  x <= hcounter;
  y <= vcounter;
  tile_x <= hcounter / TILE_SIZE;
  tile_y <= vcounter / TILE_SIZE;

  pixel_grid: process(clock) begin
		if rising_edge(clock) then
			pgrid_rgb <= "11111111";
			x_grd <= x mod TILE_SIZE;
			y_grd <= y mod TILE_SIZE;
			if((x_grd = 0) and (y_grd = 0))
			then pgrid_on <= '1';
			else pgrid_on <= '0';
			end if;
		end if;
  end process;
  
  tile_grid: process(clock) begin
	if rising_edge(clock) then
			tgrid_rgb <= "11111100";
			tx_grd <= tile_x mod 4;
			ty_grd <= tile_y mod 4;
			if((tx_grd = 0) and (ty_grd = 0))
			then tgrid_on <= '1';
			else tgrid_on <= '0';
			end if;
		end if;
  end process;
  
  -- background, switch controlled
  scan_area: process(clock) begin
		if rising_edge(clock) then
			 if ( 
				 (x >= 1) and 
				 (x < 480) and 
				 (y >= 1) and 
				 (y < 640 ))
			 then  pixels_on <= '1' ;
			 else pixels_on <='0';
			 end if;
			 pixels_rgb <= sw_buf;
		end if;
  end process;
  
  object_map: process(clock) begin
	if rising_edge(clock) then
		wall_rgb <= "00000011"; -- blue
		
		-- outer border wall
		if( (tile_x >= WALL_THICKNESS) and
			 (tile_x < TILES_X-WALL_THICKNESS) and
			 (tile_y >= WALL_THICKNESS ) and
			 (tile_y < TILES_Y-WALL_THICKNESS)) 
		then wall_on <= '0';
		else wall_on <= '1';
		end if;

   end if;
  end process;
  
	process (pixels_on, wall_on, pixels_rgb, wall_rgb, pgrid_on, pgrid_rgb, tgrid_on, tgrid_rgb) begin
		if (pixels_on = '0') then pixels <= "00000000"; -- blank
		else
		   if (pgrid_on = '1') then pixels <= pgrid_rgb;
			elsif (tgrid_on = '1') then pixels <= tgrid_rgb;
			elsif (wall_on = '1') then pixels <= wall_rgb;
			else pixels <= pixels_rgb;
			end if;
		end if;
	end process;
 end Behavioral;
