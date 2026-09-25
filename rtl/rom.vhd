library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity rom is
    generic (
        INIT_FILE : string := "mem/rom.mem"
    );
    port (
        addr         : in  std_logic_vector(7 downto 0);
        data_in      : in  std_logic_vector(7 downto 0);
        write_strobe : in  std_logic;
        data         : out std_logic_vector(7 downto 0)
    );
end entity rom;

architecture gates of rom is
    type mem_t is array (0 to 255) of std_logic_vector(7 downto 0);

    impure function load_mem(path : string) return mem_t is
        file f        : text;
        variable l    : line;
        variable mem  : mem_t := (others => (others => '0'));
    begin
        file_open(f, path, read_mode);
        for i in 0 to 255 loop
            if endfile(f) then
                exit;
            end if;
            readline(f, l);
            hread(l, mem(i));
        end loop;
        file_close(f);
        return mem;
    end function;

    constant mem : mem_t := load_mem(INIT_FILE);

    signal s_mem : mem_t := mem;
    signal s_sel : std_logic_vector(255 downto 0);
    signal s_out: mem_t;
    type s_out_bits_t is array(0 to 7) of std_logic_vector(255 downto 0);
    signal s_out_bits : s_out_bits_t;
begin
    process(write_strobe)
        file f            : text;
        variable l        : line;
        variable next_mem : mem_t;
    begin
        if rising_edge(write_strobe) then
            next_mem := s_mem;
            next_mem(to_integer(unsigned(addr))) := data_in;
            s_mem <= next_mem;

            file_open(f, INIT_FILE, write_mode);
            for i in 0 to 255 loop
                hwrite(l, next_mem(i));
                writeline(f, l);
            end loop;
            file_close(f);
        end if;
    end process;

    u_addr_to_sel: entity work.address_to_select_8
        port map (
            addr => addr,
            sel  => s_sel
        );
    
    gen_out: for i in 0 to 255 generate
        gen_out_bit: for j in 0 to 7 generate
            s_out(i)(j) <= s_sel(i) and s_mem(i)(j);
        end generate;
    end generate;

    gen_transpose: for j in 0 to 7 generate
        gen_transpose_bit: for i in 0 to 255 generate
            s_out_bits(j)(i) <= s_out(i)(j);
        end generate;
    end generate;

    gen_data: for j in 0 to 7 generate
        u_or255: entity work.or255
            port map(
                a => s_out_bits(j),
                y => data(j)
            );
    end generate;
end architecture gates;
