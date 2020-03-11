library ieee;
use ieee.std_logic_1164.all;
entity flipflop_n is
  port (
    clk_n, CE,
    pre_n, clr_n,
    D : in std_logic;

    Q, Q_n : out std_logic
  );
end entity flipflop_n;

architecture behavour of flipflop_n is begin
  ff: process (clk_n, pre_n, clr_n) is begin
    assert not ( pre_n = '0'and clr_n = '0')
    report "Illegal inputs:" & "pre_n and clr_n both '0'";

    if pre_n = '0' then
      Q <= '1'; Q_n <= '0';
    elsif clr_n = '0' then
      Q <= '0'; Q_n <= '1';
    elsif falling_edge(clk_n) then
      if CE = '1' then
        Q <= D; Q_n <= not D;
      end if;
    end if;
  end process ff;
end architecture behavour;
