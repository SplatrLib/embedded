library ieee; use ieee.std_logic_1164.all, ieee.numeric_std.all;

entity interval_timer is
  port (
    clk, load : in std_logic;
    data : in unsigned(9 downto 0);
    tc : out std_logic
  );
end entity interval_timer;

architecture rtl of interval_timer is
  signal count_value : unsigned(9 downto 0);
begin
  count : process (clk) is begin
    if rising_edge(clk) then
      if load = '1' then
        count_value <= data;
      else
        count_value <= count_value - 1;
      end if;
    end if;
  end process count;
  tc <= '1' when count_value = 0 else '0';
end architecture rtl;
