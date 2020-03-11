flipflop: process (clk) is begin
  if rising_edge(clk) then
    if reset = '1' then
      q <= '0';
    elsif ce = '1' then
      q <= d;
    end if;
  end if;
end process flipflop;
