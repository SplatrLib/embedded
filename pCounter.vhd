/* assignment 5

Design a custom single-purpose processor for a system that
counts up every time input button B is pressed and
counts down when button D is pressed.
It always outputs the count as an unsigned number on an 8-bit output C, which is initially 0.
A press is detected as a change from 1 to 0 the duration of that 0 does not matter.
The system count must roll over when the maximum value of C is reached.
7. Capture FSMD and draw the FSMD state diagram for this system.
8. Write the VHDL code for this custom single-purpose processor.

inputs:
clock
reset
B: button up
D: button down

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
           D : in STD_LOGIC;
           C : out  STD_LOGIC_VECTOR (7 downto 0));
end Proc_Counter;

architecture behavioral of Proc_Counter is
    type statetype is (start, swait, ucount, bwait, dcount, dwait);
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

process(state, B) begin
    case (state) is
        when start =>
            counternext <="00000000";
            nextstate <= swait;

        when swait =>
            counternext <=counter;

            if (B='0') then
                nextstate <= ucount;
            elsif (D='0') then
                nextstate <= dcount;
            else
                nextstate<= swait;
            end if;

        when ucount =>
            counternext <= counter + 1;

            if (B='0') then
                nextstate <= bwait;
            else
                nextstate<= swait;
            end if;

        when bwait =>
            counternext <=counter;

            if (B='0') then
                nextstate <= bwait;
            else
                nextstate<= swait;
            end if;

        when dcount =>
            counternext <= counter - 1;

            if(D='0') then
                nextstate <= dwait;
            else
                nextstate <= swait;

        when dwait =>
            counternext <= counter;

            if(D='0') then
                nextstate <= dwait;
            else
                nextstate <= swait;
            end if;
    end case;
end process;

--assign counter to c
c <= counter;

end architecture behavioral;

