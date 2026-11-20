library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity kombinacija_final is
    generic (
        G_SECOND     : natural := 125_000_000;
        G_ADDR_WIDTH : natural := 6
    );
    port (
        clk, reset             : in  std_logic;
        napred, nazad, odaberi : in  std_logic;
        cifra                  : out std_logic_vector(2 downto 0);
        otvori, greska         : out std_logic
    );
end kombinacija_final;

architecture Behavioral of kombinacija_final is
    type State_t is (stCifra, stTrazi, stOtvori, stGreska);
    signal state_reg, next_state : State_t;

    constant C_WAIT  : natural := 2 * G_SECOND;
    constant C_DEPTH : natural := 2**G_ADDR_WIDTH;

    signal cifra_reg : std_logic_vector(2 downto 0);
    signal guess     : std_logic_vector(11 downto 0);
    signal idx       : integer range 0 to 3;
    signal timer     : integer range 0 to C_WAIT - 1;

    signal rom_addr     : integer range 0 to C_DEPTH - 1;
    signal rom_addr_slv : std_logic_vector(G_ADDR_WIDTH - 1 downto 0);
    signal rom_dout     : std_logic_vector(11 downto 0);
    signal cmp_addr     : integer range 0 to C_DEPTH - 1;
begin

    ROM: entity work.pass_rom(Behavioral)
        generic map (
            G_ADDR_WIDTH => G_ADDR_WIDTH
        )
        port map (
            clk  => clk,
            addr => rom_addr_slv,
            dout => rom_dout
        );

    rom_addr_slv <= std_logic_vector(to_unsigned(rom_addr, G_ADDR_WIDTH));

    STATE_TRANSITION: process (clk) is
    begin
        if rising_edge(clk) then
            if reset = '1' then
                state_reg <= stCifra;
            else
                state_reg <= next_state;
            end if;
        end if;
    end process STATE_TRANSITION;

    NEXT_STATE_LOGIC: process (state_reg, odaberi, idx, guess, rom_dout, cmp_addr, timer) is
    begin
        case state_reg is
            when stCifra =>
                if odaberi = '1' and idx = 3 then
                    next_state <= stTrazi;
                else
                    next_state <= stCifra;
                end if;

            when stTrazi =>
                if rom_dout = guess then
                    next_state <= stOtvori;
                elsif cmp_addr = C_DEPTH - 1 then
                    next_state <= stGreska;
                else
                    next_state <= stTrazi;
                end if;

            when stOtvori | stGreska =>
                if timer = C_WAIT - 1 then
                    next_state <= stCifra;
                else
                    next_state <= state_reg;
                end if;

            when others =>
                next_state <= stCifra;
        end case;
    end process NEXT_STATE_LOGIC;

    CIFRA_PROC: process (clk) is
    begin
        if rising_edge(clk) then
            if reset = '1' or state_reg /= stCifra or odaberi = '1' then
                cifra_reg <= (others => '0');
            elsif napred = '1' and nazad = '0' then
                cifra_reg <= std_logic_vector(unsigned(cifra_reg) + 1);
            elsif nazad = '1' and napred = '0' then
                cifra_reg <= std_logic_vector(unsigned(cifra_reg) - 1);
            end if;
        end if;
    end process CIFRA_PROC;

    GUESS_PROC: process (clk) is
    begin
        if rising_edge(clk) then
            if reset = '1' or state_reg = stOtvori or state_reg = stGreska then
                guess <= (others => '0');
                idx   <= 0;
            elsif state_reg = stCifra and odaberi = '1' then
                case idx is
                    when 0      => guess(11 downto 9) <= cifra_reg;
                    when 1      => guess(8 downto 6)  <= cifra_reg;
                    when 2      => guess(5 downto 3)  <= cifra_reg;
                    when others => guess(2 downto 0)  <= cifra_reg;
                end case;
                if idx < 3 then
                    idx <= idx + 1;
                end if;
            end if;
        end if;
    end process GUESS_PROC;

    ROM_ADDR_PROC: process (clk) is
    begin
        if rising_edge(clk) then
            if reset = '1' or state_reg /= stTrazi then
                rom_addr <= 0;
                cmp_addr <= 0;
            else
                if rom_addr < C_DEPTH - 1 then
                    rom_addr <= rom_addr + 1;
                end if;
                cmp_addr <= rom_addr;
            end if;
        end if;
    end process ROM_ADDR_PROC;

    TIMER_PROC: process (clk) is
    begin
        if rising_edge(clk) then
            if reset = '1' or state_reg = stCifra or state_reg = stTrazi then
                timer <= 0;
            elsif timer < C_WAIT - 1 then
                timer <= timer + 1;
            end if;
        end if;
    end process TIMER_PROC;

    cifra  <= cifra_reg;
    otvori <= '1' when state_reg = stOtvori else '0';
    greska <= '1' when state_reg = stGreska else '0';

end Behavioral;
