library ieee;
use ieee.std_logic_1164.all;

entity address_to_select_8_tb is
end entity address_to_select_8_tb;

architecture sim of address_to_select_8_tb is
    signal addr : std_logic_vector(7 downto 0) := (others => '0');
    signal sel  : std_logic_vector(255 downto 0);
begin
    dut: entity work.address_to_select_8
        port map (
            addr => addr,
            sel  => sel
        );

    process
    begin
        addr <= x"00";
        wait for 10 ns;
        assert sel(0) = '1' report "addr 00 failed" severity error;
        assert sel(255 downto 1) = (255 downto 1 => '0') report "addr 00 extra bits" severity error;

        addr <= x"FF";
        wait for 10 ns;
        assert sel(255) = '1' report "addr FF failed" severity error;
        assert sel(254 downto 0) = (254 downto 0 => '0') report "addr FF extra bits" severity error;

        addr <= x"80";
        wait for 10 ns;
        assert sel(128) = '1' report "addr 80 failed" severity error;

        addr <= x"01";
        wait for 10 ns;
        assert sel(1) = '1' report "addr 01 failed" severity error;

        report "All tests passed" severity note;
        wait;
    end process;
end architecture sim;