library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CodeDetector is
  port (
    clk: in STD_LOGIC;
    r: in STD_LOGIC;
    g: in STD_LOGIC;
    b: in STD_LOGIC;
    lock: out STD_LOGIC;
    d: out STD_LOGIC
  );
end CodeDetector;

architecture behavior of CodeDetector is
  type statetype is (idle, red1, green, blue, red2);
  signal state: statetype;
begin
  --state register
  process(clk, reset, r, g, b) begin
    if (reset = '0') then state <= idle;
    elsif rising_edge(clk) then
      case (state) is
        when idle =>
          if(r='1') then state <= red1;
          else state <= idle;
          end if;
        when red1 =>
          if(r='1') then state <= red1;
          elsif(b='1') then state <= idle;
          elsif(g='1') then state <= green;
          end if;
        when green =>
          if(g='1') then state <= green;
          elsif(b='1') then state <= blue;
          elsif(r='1') then state <= red2;
          end if;
        when red2 =>
          if(r='1') then state <= red2;
          elsif(g='1') then state <= idle;
          elsif(b='1') then state <= blue;
          end if;
        when blue => state <= blue;
        when others => state <= idle;
      end case;
    end if;
  end process;
  --output logic
  lock <= '0' when state = blue else '1';
  d <= '1' when state = blue else '0';
end behavior;
