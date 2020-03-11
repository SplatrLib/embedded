architecture repetitive of interval_timer is
  signal load_value, count_value : unsigned(9 downto 0);
begin
  count : process (clk) is
  begin
    if rising_edge(clk) then
      if load = '1' then
        load_value <= data;
        count_value <= data;
      elsif count_value = 0 then
        count_value <= load_value;
      else
        count_value <= count_value - 1;
      end if;
    end if;
  end process count;
  tc <= '1' when count_value = 0 else '0';
end architecture repetitive;
