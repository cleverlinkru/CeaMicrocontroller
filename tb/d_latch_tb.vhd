library ieee;
use ieee.std_logic_1164.all;

entity d_latch_tb is
end entity d_latch_tb;

architecture sim of d_latch_tb is
    signal d   : std_logic := '0';
    signal c   : std_logic := '0';
    signal q   : std_logic;
    signal n_q : std_logic;
begin
    dut: entity work.d_latch
        port map (
            d   => d,
            c   => c,
            q   => q,
            n_q => n_q
        );

    process
    begin
        d <= '0';
        c <= '1';
        wait for 1 ns;
        assert q = '0' report "latch did not open with d=0" severity failure;
        assert n_q = '1' report "n_q incorrect with d=0" severity failure;

        d <= '1';
        wait for 1 ns;
        assert q = '1' report "latch is not transparent while c=1" severity failure;
        assert n_q = '0' report "n_q incorrect with d=1" severity failure;

        d <= '0';
        wait for 1 ns;
        assert q = '0' report "latch did not follow d while c=1" severity failure;
        assert n_q = '1' report "n_q incorrect after d=0" severity failure;

        c <= '0';
        wait for 1 ns;
        d <= '1';
        wait for 1 ns;
        assert q = '0' report "latch did not hold while c=0" severity failure;
        assert n_q = '1' report "n_q incorrect while holding" severity failure;

        c <= '1';
        wait for 1 ns;
        assert q = '1' report "latch did not open after c=1" severity failure;
        assert n_q = '0' report "n_q incorrect after opening" severity failure;

        report "All tests passed" severity note;
        wait;
    end process;
end architecture sim;