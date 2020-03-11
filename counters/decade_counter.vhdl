library ieee; use ieee.std_logic_1164.all, ieee.numeric_std.all;
entity decade_counter is
port ( clk : in std_logic; q : out unsigned(3 downto 0) );
end entity decade_counter;
architecture rtl of decade_counter is
signal count_value : unsigned(3 downto 0);
begin
count : process (clk) is
begin
if rising_edge(clk) then
count_value <= (count_value + 1) mod 10;
end if;
end process count;
q <= count_value;
end architecture rtl;
