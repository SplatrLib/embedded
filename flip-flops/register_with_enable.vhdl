signal d, q: ...;
...
reg: process (clk) is
begin
if rising_edge(clk) then
if ce = '1' then
q <= d;
end if;
end if;
end process reg;
