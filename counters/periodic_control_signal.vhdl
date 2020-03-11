library ieee; use ieee.std_logic_1164.all, ieee.numeric_std.all;
entity decoded_counter is
    port ( clk : in std_logic; ctrl : out std_logic );
end entity decoded_counter;

architecture rtl of decoded_counter is
    signal count_value : unsigned(3 downto 0);

    begin
        counter : process (clk) is begin
            if rising_edge(clk) then
                count_value <= count_value + 1;
            end if;
        end process counter;

    ctrl <= '1' when count_value = "0111" or count_value = "1011" else '0';
end architecture rtl;
