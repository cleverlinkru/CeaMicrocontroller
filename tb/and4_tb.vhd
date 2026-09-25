library ieee;
use ieee.std_logic_1164.all;

entity and4_tb is
end entity and4_tb;

architecture sim of and4_tb is
    signal a : std_logic_vector(3 downto 0) := (others => '0');
    signal y : std_logic;
begin
    dut: entity work.and4
        port map (
            a => a,
            y => y
        );

    process
    begin
        a <= x"F";
        wait for 10 ns;
        assert y = '1' report "all ones failed" severity error;

        a <= x"0";
        wait for 10 ns;
        assert y = '0' report "all zeros failed" severity error;

        for i in 0 to 3 loop
            a <= (others => '1');
            a(i) <= '0';
            wait for 10 ns;
            assert y = '0' report "single zero bit failed" severity error;
        end loop;

        report "All tests passed" severity note;
        wait;
    end process;
end architecture sim;