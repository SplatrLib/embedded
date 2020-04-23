library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity obj_snake is port(
  clock: in std_logic;
  tile_x: in integer range 0 to 60;
  tile_y: in integer range 0 to 60;
  
  object_on: out std_logic;
  object_rgb: out std_logic_vector(7 downto 0);
  UP: in std_logic;
  DOWN: in std_logic;
  LEFT: in std_logic;
  RIGHT: in std_logic

 ); end obj_snake;

architecture Behavioral of obj_snake is
	constant TILE_SIZE: integer := 8;
	constant head_rgb: std_logic_vector(7 downto 0) := "11100000";
	
	constant TILES_X: integer := 60;
	constant TILES_Y: integer := 60;
	constant WALL_THICKNESS: integer := 2;
	
	signal head_pos_x: integer := 3;
	signal head_pos_y: integer := 3;
	
	signal head_on: std_logic;


begin
  head_loc: entity work.snake_head
	 port map(
		clock =>  clock,
		tile_x => tile_x,
		tile_y => tile_y,
		pos_x => head_pos_x,
		pos_y => head_pos_y,
		UP => UP,
		DOWN => DOWN,
		LEFT => LEFT,
		RIGHT => RIGHT
	 );
	 
  head_obj: process(clock, head_pos_x, head_pos_y) begin
	if rising_edge(clock) then
		if( (tile_x = head_pos_x) and
			 (tile_y = head_pos_y)) 
		then head_on <= '0';
		else head_on <= '1';
		end if;
   end if;
  end process;
  


	object_on <= head_on;
	object_rgb <= head_rgb;
 end Behavioral;