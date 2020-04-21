library ieee;
use ieee.std_logic_1164.all;
--use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity sodaDispensor is
    port (
        clk   : in STD_LOGIC;
        reset : in STD_LOGIC;
        d     : out STD_LOGIC;
        s     : in STD_LOGIC_VECTOR (7 downto 0);
        a     : in STD_LOGIC_VECTOR (7 downto 0)
    )
end sodaDispensor;

architecture behavioral of sodaDispensor is
    -- define the states
    type statetype is (init, swait, add, disp);
    -- intermediate variable (register) state
    signal state, nextstate: statetype;
    -- intermediate variable (reguster) for total
    signal total: STD_LOGIC_VECTOR (7 downto 0);
begin
    SYNC_PROC:
    process(clk, reset) begin
        if( reset = '1')  then
            state <= init;
            total <= "00000000"
        elsif ( clk' event and clk = '1' ) then
            state <= nextstate;
        end if;
    end process;

    OUTPUT_DECODE:
    process (state, total): begin
        case (state) is
            when init =>
                total <= "00000000";
                d <= '0';

            when add =>
                total <= total + a;

            when disp =>
                d <= '1';

            when others =>
                d <= '0'
            end case;
    end process;

    NEXT_STATE_DECODE:
    process(state, c): begin
        case (state) is
            when init =>
                nextstate <= swait;

            when swait =>
                if(c='0' and total >= s) then
                    nextstate <= disp;
                elsif (c = '1') then
                    nextstate <= add;
                else
                    nextstate <= swait;

            when add =>
                nextstate <= swait;

            when disp =>
                nextstate <= init;

            when others =>
                nextstate <= init;

        end case;
    end process;

end architecture behavioral;
