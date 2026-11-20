library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity controller is
    generic (
        G_SECOND     : natural := 125_000_000;
        G_ADDR_WIDTH : natural := 6;
        G_TIMER      : integer := 1_000_000
    );
    port (
        clk, reset             : in  std_logic;
        napred, nazad, odaberi : in  std_logic;
        cifra                  : out std_logic_vector(2 downto 0);
        otvori, greska         : out std_logic
    );
end controller;

architecture Behavioral of controller is
    signal napred_p  : std_logic;
    signal nazad_p   : std_logic;
    signal odaberi_p : std_logic;
begin

    ED_NAPRED: entity work.edge_detector(Behavioral)
        generic map (
            G_TIMER => G_TIMER
        )
        port map (
            clk    => clk,
            reset  => reset,
            taster => napred,
            zahtev => napred_p
        );

    ED_NAZAD: entity work.edge_detector(Behavioral)
        generic map (
            G_TIMER => G_TIMER
        )
        port map (
            clk    => clk,
            reset  => reset,
            taster => nazad,
            zahtev => nazad_p
        );

    ED_ODABERI: entity work.edge_detector(Behavioral)
        generic map (
            G_TIMER => G_TIMER
        )
        port map (
            clk    => clk,
            reset  => reset,
            taster => odaberi,
            zahtev => odaberi_p
        );

    KOMB: entity work.kombinacija_final(Behavioral)
        generic map (
            G_SECOND     => G_SECOND,
            G_ADDR_WIDTH => G_ADDR_WIDTH
        )
        port map (
            clk     => clk,
            reset   => reset,
            napred  => napred_p,
            nazad   => nazad_p,
            odaberi => odaberi_p,
            cifra   => cifra,
            otvori  => otvori,
            greska  => greska
        );

end Behavioral;
