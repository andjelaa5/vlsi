library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity edge_detector is
    generic ( G_TIMER : integer := 1000000 );
    port (
        clk    : in  std_logic;
        reset  : in  std_logic;
        taster : in  std_logic;
        zahtev : out std_logic
    );
end edge_detector;

architecture Behavioral of edge_detector is
    type State_t is (s1, s2, s3, s4, s5);
    signal state_reg, next_state : State_t;
    signal tajmer : integer range 0 to G_TIMER := G_TIMER;
begin

    -- registar stanja
    STATE_REG_PROC: process (clk) is
    begin
        if rising_edge(clk) then
            if reset = '1' then
                state_reg <= s1;
            else
                state_reg <= next_state;
            end if;
        end if;
    end process;

    -- tajmer: u stanju 1 se puni, u stanju 2 odbrojava
    TIMER_PROC: process (clk) is
    begin
        if rising_edge(clk) then
            if reset = '1' then
                tajmer <= G_TIMER;
            else
                case state_reg is
                    when s1 => tajmer <= G_TIMER;
                    when s2 => if tajmer > 0 then tajmer <= tajmer - 1; end if;
                    when others => null;
                end case;
            end if;
        end if;
    end process;

    -- logika sledeceg stanja
    NEXT_STATE_LOGIC: process (state_reg, taster, tajmer) is
    begin
        next_state <= state_reg;
        case state_reg is
            when s1 =>
                if taster = '1' then next_state <= s2; end if;
            when s2 =>
                if tajmer = 0 then next_state <= s3; end if;
            when s3 =>
                if taster = '1' then next_state <= s4;
                else next_state <= s1; end if;
            when s4 =>
                next_state <= s5;
            when s5 =>
                if taster = '0' then next_state <= s1; end if;
        end case;
    end process;

    -- izlaz (Mooreov)
    zahtev <= '1' when state_reg = s4 else '0';

end Behavioral;