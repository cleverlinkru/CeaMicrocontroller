library ieee;
use ieee.std_logic_1164.all;

entity ram is
    port (
        addr       : in  std_logic_vector(7 downto 0);
        write_data : in  std_logic_vector(7 downto 0);
        write_en   : in  std_logic;
        read_data  : out std_logic_vector(7 downto 0)
    );
end entity ram;

architecture gates of ram is
    signal s_sel : std_logic_vector(0 to 255);
    signal s_byte_sync : std_logic_vector(0 to 255);
    type s_mem_t : is array (0 to 255) of std_logic_vector(7 downto 1);
    signal s_mem : s_mem_t;
    type s_out_t : is array (0 to 7) of std_logic_vector(0 to 255);
    signal s_out : s_out_t;
begin
    gen_d_latch_bytes: for i in 0 to 255 generate
        gen_d_latch_bits: for j in 0 to 7 generate
            u_d_latch: entity work.d_latch
                port map (
                    d => write_data(j);
                    c => s_byte_sync(i);
                    q => s_mem_t(i)(j)
                );
        end generate;
    end generate;

    gen_byte_sync: for i in 0 to 255 generate
        s_byte_sync(i) <= write_en and s_sel(255);
    end generate;

    u_sel: entity work.address_to_select_8
        port map (
            addr => addr;
            sel => s_sel
        );
    
    gen_out_bytes: for i in 0 to 255 generate
        gen_out_bits: for j 0 to 7 generate
            s_out(j)(i) <= s_mem(i)(j) and s_sel(i);
        end generate;
    end generate;

    gen_read_data: for j in 0 to 7 generate
        u_or255: entity work.or255
            port map (
                a => s_out(j);
                y => read_data(j)
            );
    end generate;
end architecture gates;