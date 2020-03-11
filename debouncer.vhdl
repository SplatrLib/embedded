library ieee; use ieee.std_logic_1164.all;
entity debouncer is
  port ( clk, reset : in std_logic; -- clk frequency = 50MHz
  pb : in std_logic; pb_debounced : out std_logic );
end entity debouncer;

architecture rtl of debouncer is
  signal count500000 : integer range 0 to 499999;
  signal clk_100Hz : std_logic;
  signal pb_sampled : std_logic;
begin

  div_100Hz : process (clk, reset) is begin
    if reset = '1' then
      clk_100Hz <= '0';
      count500000 <= 0;
    elsif rising_edge(clk) then
      if count500000 = 499999 then
        count500000 <= 0;
        clk_100Hz <= '1';
      else
        count500000 <= count500000 + 1;
        clk_100Hz <= '0';
      end if;
    end if;
  end process div_100Hz;

  debounce_pb : process (clk) is begin
    if rising_edge(clk) then
      if clk_100Hz = '1' then
        if pb = pb_sampled then
          pb_debounced <= pb;
        end if;
        pb_sampled <= pb;
      end if;
    end if;
  end process debounce_pb;
  
end architecture rtl;
