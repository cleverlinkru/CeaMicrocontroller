library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity rom is
    generic (
        INIT_FILE : string := "mem/rom.mem"
    );
    port (
        addr : in  std_logic_vector(7 downto 0);
        data : out std_logic_vector(7 downto 0)
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

    signal s_mem : mem_t;
    signal s_sel : std_logic_vector(255 downto 0);
    signal s_out: mem_t;
    type s_out_bits_t is array(0 to 7) of std_logic_vector(255 downto 0);
    signal s_out_bits : s_out_bits_t;
begin
    gen_word: for i in 0 to 255 generate
        gen_bit: for j in 0 to 7 generate
            s_mem(i)(j) <= mem(i)(j);
        end generate;
    end generate;

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

    gen_data: for i in 0 to 255 generate
        gen_data_bit: for j in 0 to 7 generate
            u_or255: entity work.or255
                port map(
                    a => s_out_bits(j),
                    y => data(j)
                );
        end generate;
    end generate;
end architecture gates;
