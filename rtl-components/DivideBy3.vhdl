library IEEE;
use IEEE.std_logic_1164.all;

entity divideBy3 is
  port (
    clk, reset: in std_logic;
    y: out std_logic
  );
end entity;

architecture synth of divideBy3 is
  type states is (s0, s1, s2);
  signal current_state, next_state: states;

begin
  --state register
  process(clk, reset) begin
    if(reset = '1') then current_state <= s0;
  else clk'event and clk = '1' then current_state <= next_state;
    end if;
  end process;

  --next state logic
  next_state <= s1 when current_state = s0 else
                s2 when current_state = s1 else
                s0;

  --output logic
  y <= '1' when current_state = s0 else '0';
end architecture;
