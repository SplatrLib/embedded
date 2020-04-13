library ieee;
use ieee.std_logic_1164.all;
--use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity laserDistance is
    port (
        clk, reset  : in    std_logic;
        B, S        : in    std_logic;
        L           : out   std_logic;
        D           : out   std_logic_vector (15 downto 0)
    )
end laserDistance;

architecture behavioral of laserDistance is
    -- define the states
    type statetype is (s0, s1, s2, s3, s4);
    -- intermediate variable (register) state
    signal state, nextstate: statetype;
    -- intermediate variables (regusters)
    signal d_cnt, d_cnt_next;
    signal d_reg, d_reg_next;

    --constants
    constant ZERO = std_logic_vector(15 downto 0) := '000000000000000';
    constant ONE = std_logic_vector(15 downto 0) := '000000000000001';

begin
    SYNC_PROC:
    process(clk, reset) begin
        if( reset = '1')  then
            state <= s0;
            d_cnt <= ZERO;
            d_reg <= ZERO;
        elsif ( clk' event and clk = '1' ) then
            state <= nextstate;
            d_reg <= d_reg_next;
            d_cnt <= d_cnt_next;
        end if;
    end process;

    OUTPUT_DECODE:
    process (state, total): begin
        case (state) is
            when s0 =>
                L <= '0';
                d_reg_next <= ZERO;

            when s1 =>
                d_cnt_next <= ONE;

            when s2 =>
                L <= '1';

            when s3 =>
                L <= '0';
                d_cnt_next <= d_dnt + 1;

            when s4 =>
                d_reg_next <= shr(d_cnt, ONE);

            when others =>
                L <= '0';
                d_cnt_next <= ZERO;
                d_reg_next <= ZERO;
        end case;
    end process;

    --assign output
    D <= d_reg;

    NEXT_STATE_DECODE:
    process(state, c): begin
        case (state) is
            when s0 =>
                nextstate = s1;

            when s1 =>
                if(B = '1') then nextstate <= s2
                else nextstate <= s1 end if;

            when s2 =>
                nextstate <= s3;

            when s3 =>
                if(S = '1') then nextstate <= s4
                else nextstate <= s3 end if;

            when s2 =>
                nextstate <= s1;

            when others =>
                nextstate <= s0;
        end case;
    end process;

end architecture behavioral;
