reg: process (clk, reset) is
begin
if reset = '1' then
q <= "00000000";
elsif rising_edge(clk) then
if ce = '1' then
q <= d;
end if;
end if;
end process reg;
