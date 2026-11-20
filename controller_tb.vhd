library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity controller_tb is
--  Port ( );
end controller_tb;

architecture Behavioral of controller_tb is
    constant C_CLK_PERIOD : time := 8 ns;

    constant C_SECOND     : natural := 10;
    constant C_ADDR_WIDTH : natural := 6;
    constant C_TIMER      : integer := 3;

    signal clk     : std_logic := '1';
    signal reset   : std_logic;
    signal napred  : std_logic := '0';
    signal nazad   : std_logic := '0';
    signal odaberi : std_logic := '0';
    signal cifra   : std_logic_vector(2 downto 0);
    signal otvori  : std_logic;
    signal greska  : std_logic;
begin
    DUT : entity work.controller(Behavioral)
        generic map (
            G_SECOND     => C_SECOND,
            G_ADDR_WIDTH => C_ADDR_WIDTH,
            G_TIMER      => C_TIMER
        )
        port map (
            clk     => clk,
            reset   => reset,
            napred  => napred,
            nazad   => nazad,
            odaberi => odaberi,
            cifra   => cifra,
            otvori  => otvori,
            greska  => greska
        );

    clk <= not clk after C_CLK_PERIOD/2;

    STIMULUS: process is
    begin
        reset <= '1';
        wait for C_CLK_PERIOD*3.2;
        reset <= '0';
        wait for C_CLK_PERIOD*2;

        napred <= '1';
        wait for C_CLK_PERIOD*2;
        napred <= '0';
        wait for C_CLK_PERIOD*5;

        odaberi <= '1';
        wait for C_CLK_PERIOD*(C_TIMER + 5);
        odaberi <= '0';
        wait for C_CLK_PERIOD*3;

        odaberi <= '1';
        wait for C_CLK_PERIOD*(C_TIMER + 5);
        odaberi <= '0';
        wait for C_CLK_PERIOD*3;

        odaberi <= '1';
        wait for C_CLK_PERIOD*(C_TIMER + 5);
        odaberi <= '0';
        wait for C_CLK_PERIOD*3;

        napred <= '1';
        wait for C_CLK_PERIOD*(C_TIMER + 5);
        napred <= '0';
        wait for C_CLK_PERIOD*3;

        odaberi <= '1';
        wait for C_CLK_PERIOD*(C_TIMER + 5);
        odaberi <= '0';
        wait for C_CLK_PERIOD*40;

        nazad <= '1';
        wait for C_CLK_PERIOD*(C_TIMER + 5);
        nazad <= '0';
        wait for C_CLK_PERIOD*3;

        odaberi <= '1';
        wait for C_CLK_PERIOD*(C_TIMER + 5);
        odaberi <= '0';
        wait for C_CLK_PERIOD*3;

        odaberi <= '1';
        wait for C_CLK_PERIOD*(C_TIMER + 5);
        odaberi <= '0';
        wait for C_CLK_PERIOD*3;

        odaberi <= '1';
        wait for C_CLK_PERIOD*(C_TIMER + 5);
        odaberi <= '0';
        wait for C_CLK_PERIOD*3;

        odaberi <= '1';
        wait for C_CLK_PERIOD*(C_TIMER + 5);
        odaberi <= '0';
        wait for C_CLK_PERIOD*100;

        wait;
    end process STIMULUS;

end Behavioral;
