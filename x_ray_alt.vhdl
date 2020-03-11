library IEEE;
use IEEE.std_logic_1164.all;

entity x_ray_alt is
  port(
    clk : in std_logic;
    reset : in std_logic;
    b : in std_logic;
    x : out std_logic
  );
end entity x_ray_alt;

architecture behavioral of x_ray_alt is
  type states is (init, run, hold);
  signal state, next_state : states;

begin
  --state register
  process(clk, reset, b) begin
    if(reset = '1') then state <= init;
    elseif rising_edge(clk) then state <= next_state;
    end if;
  end process;

  --next state logic
  next_state <= run when (state = init and b = '1') else
                hold when state = run or (state = hold and b = '1') else
                init;


  --output logic
  x <= '1' when state = run else '0';
end behavioral;
