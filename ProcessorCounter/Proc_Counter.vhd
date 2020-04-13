/*
count the number of times an input button is pressed
output as 8-bit unsigned
must roll over when the maximum value is reached

inputs:
clock
reset
B: button press

outputs:
count
*/
library IEEE;
use IEEE.STD_LOGIC_1164.all;
--use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity Proc_Counter is
    port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           B : in  STD_LOGIC;
           C : out  STD_LOGIC_VECTOR (7 downto 0));
end Proc_Counter;

architecture behavioral of Proc_Counter is
    type statetype is (start, swait, count, bwait);
    signal state, nextstate: statetype;
    signal counter, counternext: STD_LOGIC_VECTOR (7 downto 0);
begin

--state register
process(clk, reset)
begin
    if(reset ='0') then
        state <= start;
        counter <= "00000000";
    elsif (clk' event and clk='1') then
        state <= nextstate;
        counter <=counternext;
    end if;
end process;

--combinational logic
process(state, B) begin
    case (state) is
        when start =>
            counternext <="00000000";
            nextstate <= swait;

        when swait =>
            counternext <=counter;

            if (B='0') then
                nextstate <= count;
            else
                nextstate<= swait;
            end if;

        when count =>
            counternext <= counter + 1;

            if (B='0') then
                nextstate <= bwait;
            else
                nextstate<= swait;
            end if;

        when bwait =>
            counternext <=counter;

            if (B='0') then
                --c <= counter;
                nextstate <= bwait;
            else
                --c <= counter;
                nextstate<= swait;
            end if;
    end case;
end process;

--assign counter to c
c <= counter;

end architecture behavioral;

