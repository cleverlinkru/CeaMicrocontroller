library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity rom_tb is
    generic (
        TEST_FILE   : string := "tb/rom_test.mem";
        TEST_OUTPUT : string := "build/rom_test.out"
    );
end entity rom_tb;

architecture sim of rom_tb is
    signal addr       : std_logic_vector(7 downto 0) := (others => '0');
    signal write_data : std_logic_vector(7 downto 0) := (others => '0');
    signal write_en   : std_logic := '0';
    signal read_data  : std_logic_vector(7 downto 0);
begin
    dut: entity work.rom
        generic map (
            INIT_FILE  => TEST_FILE,
            WRITE_FILE => TEST_OUTPUT
        )
        port map (
            addr       => addr,
            write_data => write_data,
            write_en   => write_en,
            read_data  => read_data
        );

    process
        file out_file  : text;
        variable l     : line;
        variable value : std_logic_vector(7 downto 0);
    begin
        wait for 1 ns;
        assert read_data = x"00" report "read 00 failed" severity error;

        addr <= x"02";
        wait for 1 ns;
        assert read_data = x"FF" report "read 02 failed" severity error;

        addr <= x"03";
        wait for 1 ns;
        assert read_data = x"EE" report "read 03 failed" severity error;

        addr <= x"04";
        wait for 1 ns;
        assert read_data = x"89" report "read 04 failed" severity error;

        addr <= x"05";
        write_data <= x"A5";
        write_en <= '1';
        wait for 1 ns;
        write_en <= '0';
        wait for 1 ns;
        assert read_data = x"A5" report "write 05 failed" severity error;

        file_open(out_file, TEST_OUTPUT, read_mode);
        for i in 0 to 5 loop
            readline(out_file, l);
        end loop;
        hread(l, value);
        file_close(out_file);
        assert value = x"A5" report "output file write 05 failed" severity error;

        addr <= x"02";
        wait for 1 ns;
        assert read_data = x"FF" report "write changed 02" severity error;

        report "All tests passed" severity note;
        wait;
    end process;
end architecture sim;