library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity snake_head is port(
  clock: in std_logic;
  tile_x: in integer range 0 to 60;
  tile_y: in integer range 0 to 60;
  pos_x: out integer range 0 to 60;
  pos_y: out integer range 0 to 60;
  head_moved: out std_logic;
  UP: in std_logic;
  DOWN: in std_logic;
  LEFT: in std_logic;
  RIGHT: in std_logic
); end snake_head;

architecture Behavioral of snake_head is
	signal head_pos_x, head_pos_x_next: integer range 0 to 60 := 22;
	signal head_pos_y, head_pos_y_next: integer range 0 to 60 := 22;
	signal moved, moved_next: std_logic;

	type statetype is (init, iwait, up_go, up_wait, down_go, down_wait, left_go, left_wait, right_go, right_wait);
   signal state, nextstate: statetype;

begin
	--state register
	process(clock)
	begin
		 if rising_edge(clock) then
			  state <= nextstate;
			  head_pos_x <= head_pos_x_next;
			  head_pos_y <= head_pos_y_next;
			  moved <= moved_next;
		 end if;
	end process;
	
	OUTPUT_DECODE:
    process (state, UP, DOWN) begin
        case (state) is
            when init =>
                head_pos_x_next <= 22;
					 head_pos_y_next <= 22;
					 moved_next <= '0';

            when up_go =>
					 head_pos_x_next <= head_pos_x;
                head_pos_y_next <= head_pos_y + 1;
					 moved_next <= '1';

            when down_go =>
					 head_pos_x_next <= head_pos_x;
                head_pos_y_next <= head_pos_y - 1;
					 moved_next <= '1';
					 
				when right_go =>
					head_pos_x_next <= head_pos_x + 1;
               head_pos_y_next <= head_pos_y;
					moved_next <= '1';
					
				when left_go =>
					head_pos_x_next <= head_pos_x - 1;
               head_pos_y_next <= head_pos_y;
					moved_next <= '1';

            when others =>
                head_pos_x_next <= head_pos_x;
					 head_pos_y_next <= head_pos_y;
					 moved_next <= '0';
            end case;
    end process;

    NEXT_STATE_DECODE:
    process(state, UP, DOWN) begin
        case (state) is
            when init =>
                nextstate <= iwait;

            when iwait =>
                if(UP='0') then nextstate <= up_go;
                elsif (DOWN = '0') then nextstate <= down_go;
				    elsif (LEFT = '0') then nextstate <= left_go;
					 elsif (RIGHT = '0') then nextstate <= right_go;
                else nextstate <= iwait;
					  end if;

            when up_go =>
                nextstate <= up_wait;
					 
				when up_wait =>
					if(UP='0') then
						nextstate <= up_wait;
					else 
						nextstate <= iwait;
					end if;

            when down_go =>
                nextstate <= down_wait;
					 
				when down_wait =>
					if(DOWN='0') then
						nextstate <= down_wait;
					else 
						nextstate <= iwait;
					end if;
					
				when left_go =>
                nextstate <= left_wait;
					 
				when left_wait =>
					if(LEFT='0') then
						nextstate <= left_wait;
					else 
						nextstate <= iwait;
					end if;
					
				when right_go =>
                nextstate <= right_wait;
					 
				when right_wait =>
					if(RIGHT='0') then
						nextstate <= right_wait;
					else 
						nextstate <= iwait;
					end if;

            when others =>
                nextstate <= init;

        end case;
    end process;

	pos_x <= head_pos_x;
	pos_y <= head_pos_y;
	head_moved <= moved;
 end Behavioral;


