library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pass_rom_tb is
--  Port ( );
end pass_rom_tb;

architecture Behavioral of pass_rom_tb is
    constant C_CLK_PERIOD : time := 8 ns;

    constant C_ADDR_WIDTH : natural := 6;

    signal clk  : std_logic := '1';
    signal addr : std_logic_vector(C_ADDR_WIDTH-1 downto 0) := (others => '0');
    signal dout : std_logic_vector(11 downto 0);
begin
    DUT : entity work.pass_rom(Behavioral)
        generic map (
            G_ADDR_WIDTH => C_ADDR_WIDTH
        )
        port map (
            clk  => clk,
            addr => addr,
            dout => dout
        );

    clk <= not clk after C_CLK_PERIOD/2;

    STIMULUS: process is
    begin
        wait for C_CLK_PERIOD*2.2;
        addr <= std_logic_vector(to_unsigned(0, C_ADDR_WIDTH));
        wait for C_CLK_PERIOD*3;
        addr <= std_logic_vector(to_unsigned(1, C_ADDR_WIDTH));
        wait for C_CLK_PERIOD*3;
        addr <= std_logic_vector(to_unsigned(2, C_ADDR_WIDTH));
        wait for C_CLK_PERIOD*3;
        addr <= std_logic_vector(to_unsigned(5, C_ADDR_WIDTH));
        wait for C_CLK_PERIOD*3;
        addr <= std_logic_vector(to_unsigned(2**C_ADDR_WIDTH - 1, C_ADDR_WIDTH));
        wait for C_CLK_PERIOD*3;
        wait;
    end process STIMULUS;

end Behavioral;
