library ieee;
use ieee.std_logic_1164.all;

/**
                              clk
                               |
            +-------+  next   ++-+  current +--------+
inputs +----+ next  |  state  |\/|  state   | output |
            | state +---------+  +------+---+ logic  +---+ outputs
       +----+ logic |         |  |      |   |        |
       |    +-------+         +--+      |   +--------+
       |                                |
       +--------------------------------+
*/


entity F_Divider is
  port (
    clk: in std_logic;
    a: in std_logic;
    reset: in std_logic;
    x: out std_logic
  );
end entity F_Divider;

architecture behavour of F_Divider is
  -- an enumeration type can be used for states
  type statetype is (zero, one, two, three);

  -- signal to represent the current state of state machine
  signal current_state, next_state: statetype;

begin
  -- state register
  process(clk) begin
    if(clk = '1' and clk' event) then
      if(reset = '1') then current_state <= zero;
      elseif(a = '0') then current_state <= state;
      else current_state <= next_state;
      end if;
    end if;
  end process;

  --next state logic
  next_state <= one when current_state = zero else
                two when current_state = one  else
                three when current_state = two else
                zero when current_state = three;

  --output logic
  x <= '1' when current_state = three else '0';

end behavour;
