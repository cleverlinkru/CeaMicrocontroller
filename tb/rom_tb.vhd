library ieee;
use ieee.std_logic_1164.all;

entity rom_tb is
    generic (
        TEST_FILE : string := "tb/rom_test.mem"
    );
end entity rom_tb;

architecture sim of rom_tb is
    signal addr         : std_logic_vector(7 downto 0) := (others => '0');
    signal data_in      : std_logic_vector(7 downto 0) := (others => '0');
    signal write_strobe : std_logic := '0';
    signal data         : std_logic_vector(7 downto 0);
begin
    dut: entity work.rom
        generic map (
            INIT_FILE => TEST_FILE
        )
        port map (
            addr         => addr,
            data_in      => data_in,
            write_strobe => write_strobe,
            data         => data
        );

    process
    begin
        wait for 1 ns;
        assert data = x"00" report "read 00 failed" severity error;

        addr <= x"02";
        wait for 1 ns;
        assert data = x"FF" report "read 02 failed" severity error;

        addr <= x"03";
        wait for 1 ns;
        assert data = x"EE" report "read 03 failed" severity error;

        addr <= x"04";
        wait for 1 ns;
        assert data = x"89" report "read 04 failed" severity error;

        addr <= x"05";
        data_in <= x"A5";
        write_strobe <= '1';
        wait for 1 ns;
        write_strobe <= '0';
        wait for 1 ns;
        assert data = x"A5" report "write 05 failed" severity error;

        addr <= x"02";
        wait for 1 ns;
        assert data = x"FF" report "write changed 02" severity error;

        report "All tests passed" severity note;
        wait;
    end process;
end architecture sim;