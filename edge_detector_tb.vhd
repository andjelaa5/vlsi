library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity edge_detector_tb is
end edge_detector_tb;

architecture Behavioral of edge_detector_tb is
    constant CLK_PERIOD : time := 10 ns;
    signal clk, reset, taster, zahtev : std_logic := '0';
begin

    uut: entity work.edge_detector
        generic map ( G_TIMER => 3 )   -- kratak tajmer za simulaciju
        port map ( clk => clk, reset => reset, taster => taster, zahtev => zahtev );

    clk <= not clk after CLK_PERIOD / 2;

    stim: process
    begin
        reset <= '1';
        wait for 3 * CLK_PERIOD;
        reset <= '0';
        wait for 2 * CLK_PERIOD;

        -- 1) kratak pritisak (1 takt): kraci od tajmera -> NEMA zahteva
        taster <= '1'; wait for CLK_PERIOD;
        taster <= '0'; wait for 10 * CLK_PERIOD;

        -- 2) dug pritisak: tacno jedan impuls zahteva
        taster <= '1'; wait for 20 * CLK_PERIOD;
        taster <= '0'; wait for 5 * CLK_PERIOD;

        -- 3) dug pritisak sa treperenjem na pocetku (bounce)
        taster <= '1'; wait for CLK_PERIOD;
        taster <= '0'; wait for CLK_PERIOD;
        taster <= '1'; wait for 20 * CLK_PERIOD;
        taster <= '0'; wait for 10 * CLK_PERIOD;

        wait;
    end process;

end Behavioral;
