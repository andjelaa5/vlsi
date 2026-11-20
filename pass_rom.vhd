library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pass_rom is
    generic (
        G_ADDR_WIDTH : natural := 6
    );
    port (
        clk  : in  std_logic;
        addr : in  std_logic_vector(G_ADDR_WIDTH-1 downto 0);
        dout : out std_logic_vector(11 downto 0)
    );
end pass_rom;

architecture Behavioral of pass_rom is
    constant C_DEPTH : natural := 2**G_ADDR_WIDTH;

    type rom_type is array (0 to C_DEPTH-1) of std_logic_vector(11 downto 0);
    constant ROM : rom_type := (
        0      => o"5274",
        1      => o"1234",
        2      => o"7070",
        3      => o"0001",
        4      => o"7654",
        5      => o"3141",
        others => o"0000"
    );
begin
    process (clk) is
    begin
        if rising_edge(clk) then
            dout <= ROM(to_integer(unsigned(addr)));
        end if;
    end process;
end Behavioral;
