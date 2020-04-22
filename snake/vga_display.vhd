library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity VGA_display is port(
  -- Assuming 50MHz clock.If the clock is reduced then it might give the unexpected output.
  clock: in std_logic;
  -- switches that control background
  sw: in std_logic_vector(7 downto 0);
  -- x counter
  hcounter: in integer range 0 to 1023;
  -- y counter
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
    constant WALL_X_L: integer := 2;
    constant WALL_X_R: integer := 4;

    -- border wall
    constant WALL_THICKNESS = 3;
    signal

    -- object output signals -- signal to indicate if the coord is within the object
    signal pixels_on, landscape_on: std_logic;
    signal pixels_rgb, landscape_rgb: std_logic_vector(7 downto 0);

    -- register telling the exact position on display on screen.
    signal pos_x : integer range 0 to 1023 := 100;
    signal pos_y : integer range 0 to 1023 := 80;
    signal tile_x: integer range 0 to TILES_X := 0;
    signal tile_y: integer range 0 to TILES_Y := 0;
    signal sw_buf: std_logic_vector(7 downto 0) := sw;
begin

  sw_buf <= sw;
  pos_x <= hcounter;
  pos_y <= vcounter;
  tile_x <= hcounter / TILE_SIZE;
  tile_y <= vcounter / TILE_SIZE;

  -- On every positive edge of the clock counter condition is checked,
    video_output: process(clock) begin
        if rising_edge(clock) then
            -- background, switch controlled
             if (
                 (pos_x >= 1) and
                 (pos_x < MAX_X) and
                 (pos_y >= 1) and
                 (pos_y < MAX_Y ))
             then  pixels_on <= '1' ;
             else  pixels_on <='0';
             end if;
             pixels_rgb <= sw_buf;

            -- outer border wall
            if( pixesl_on and
                (tile_x > WALL_THICKNESS) and
                (tile_x < (TILES_X-WALL_THICKNESS)) and
                (tile_y > WALL_THICKNESS) and
                (tile_y < (TILES_Y - WALL_THICKNESS))
            )then landscape_on <= '0';
            else landscape_on <= '1'
            landscape_rgb <= "00000011";

            -- wall 1
            if (pixels_on and (not landscape_on) and
                ((tile_x > 20 ) and
                (tile_x < (20 + 2 - WALL_THICKNESS)) and
                (tile_y > 30) and
                (tile_y < (30 + 5 - WALL_THICKNESS)))
            )then landscape_on <= '0';
            else landscape_on <= '1'

        end if;
    end process;

    process (pixels_on, landscape_on, pixels_rgb, landscape_rgb) begin
        if (pixels_on = '0') then pixels <= "00000000"; -- blank
        else
            if (landscape_on = '1') then pixels <= landscape_rgb;
            else pixels <= pixels_rgb;
            end if;
        end if;
    end process;
 end Behavioral;
