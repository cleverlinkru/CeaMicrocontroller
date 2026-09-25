library ieee;
use ieee.std_logic_1164.all;

entity or255_tb is
end entity or255_tb;

architecture sim of or255_tb is
    signal a : std_logic_vector(255 downto 0) := (others => '0');
    signal y : std_logic;
begin
    dut: entity work.or255
        port map (
            a => a,
            y => y
        );

    process
    begin
        a <= (others => '0');
        wait for 1 ns;
        assert y = '0' report "all zeros failed" severity failure;

        a <= (others => '1');
        wait for 1 ns;
        assert y = '1' report "all ones failed" severity failure;

        for i in 0 to 255 loop
            a <= (others => '0');
            a(i) <= '1';
            wait for 1 ns;
            assert y = '1' report "single one at bit " & integer'image(i) & " failed" severity failure;
        end loop;

        for i in 0 to 255 loop
            a <= (others => '1');
            a(i) <= '0';
            wait for 1 ns;
            assert y = '1' report "single zero at bit " & integer'image(i) & " failed" severity failure;
        end loop;

        report "All tests passed" severity note;
        wait;
    end process;
end architecture sim;
