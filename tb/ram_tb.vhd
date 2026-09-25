library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ram_tb is
end entity ram_tb;

architecture sim of ram_tb is
    signal addr       : std_logic_vector(7 downto 0) := (others => '0');
    signal write_data : std_logic_vector(7 downto 0) := (others => '0');
    signal write_en   : std_logic := '0';
    signal read_data  : std_logic_vector(7 downto 0);
begin
    uut: entity work.ram
        port map (
            addr       => addr,
            write_data => write_data,
            write_en   => write_en,
            read_data  => read_data
        );

    process
        procedure write_byte(a : std_logic_vector(7 downto 0); d : std_logic_vector(7 downto 0)) is
        begin
            addr       <= a;
            write_data <= d;
            wait for 20 ns;
            write_en   <= '1';
            wait for 20 ns;
            write_en   <= '0';
            wait for 20 ns;
        end procedure;

        procedure read_byte(a : std_logic_vector(7 downto 0); expected : std_logic_vector(7 downto 0)) is
        begin
            addr <= a;
            wait for 20 ns;
            assert read_data = expected
                report "READ FAIL: addr=" & to_hstring(a) & " got=" & to_hstring(read_data) & " exp=" & to_hstring(expected)
                severity error;
            report "READ OK:  addr=" & to_hstring(a) & " data=" & to_hstring(read_data);
        end procedure;
    begin
        report "=== RAM TB START ===";

        wait for 50 ns;

        write_byte(x"00", x"AA");
        write_byte(x"FF", x"55");
        write_byte(x"7F", x"33");
        write_byte(x"80", x"CC");
        write_byte(x"12", x"DE");
        write_byte(x"34", x"AD");

        read_byte(x"00", x"AA");
        read_byte(x"FF", x"55");
        read_byte(x"7F", x"33");
        read_byte(x"80", x"CC");
        read_byte(x"12", x"DE");
        read_byte(x"34", x"AD");

        -- Initialize some other locations to test reading zeros
        write_byte(x"01", x"00");
        write_byte(x"FE", x"00");
        read_byte(x"01", x"00");
        read_byte(x"FE", x"00");

        write_byte(x"00", x"11");
        read_byte(x"00", x"11");

        report "=== ALL TESTS PASSED ===";
        wait;
    end process;
end architecture sim;