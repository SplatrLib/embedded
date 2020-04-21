library IEEE;
use IEEE.std_logic_1164.all;

entity x_ray is
  port(
    clk : in std_logic;
    reset : in std_logic;
    b : in std_logic;
    x : out std_logic
  );
end entity x_ray;

architecture behavioral of x_ray is
  type states is (init, run, hold);
  signal state : states;

begin
  --state register
  process(clk, reset, b) begin
    if(reset = '1') then state <= init;
    elseif rising_edge(clk) then

      case (state) is
        when init =>
          if(b='1') then state <= run;
          elseif(b='0') then state < init;
          end if;

        when run =>
          state <= hold;

        when hold =>
          if(b='1') then state <= hold;
          elseif(b = '0') then state <= init;
          end if;
      end case;
    end if;
  end process;

  --output logic
  x <= '1' when state = run else '0';
end behavioral;
