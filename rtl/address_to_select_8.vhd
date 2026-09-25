library ieee;
use ieee.std_logic_1164.all;

entity address_to_select_8 is
    port (
        addr : in std_logic_vector(7 downto 0);
        sel  : out std_logic_vector(255 downto 0)
    );
end entity address_to_select_8;

architecture gates of address_to_select_8 is
    signal not_addr : std_logic_vector(7 downto 0);

    type sel_in_t is array (0 to 255) of std_logic_vector(7 downto 0);
    signal sel_in : sel_in_t;
begin
    gen_not: for i in 0 to 7 generate
        not_addr(i) <= not addr(i);
    end generate;

    gen_sel_in: for i in 0 to 255 generate
        gen_bit: for b in 0 to 7 generate
            gen_on: if (i / 2 ** b) mod 2 = 1 generate
                sel_in(i)(b) <= addr(b);
            end generate;
            gen_off: if (i / 2 ** b) mod 2 = 0 generate
                sel_in(i)(b) <= not_addr(b);
            end generate;
        end generate;
    end generate;

    gen_sel: for i in 0 to 255 generate
        u_and8: entity work.and8
            port map (
                a(0) => sel_in(i)(0),
                a(1) => sel_in(i)(1),
                a(2) => sel_in(i)(2),
                a(3) => sel_in(i)(3),
                a(4) => sel_in(i)(4),
                a(5) => sel_in(i)(5),
                a(6) => sel_in(i)(6),
                a(7) => sel_in(i)(7),
                y    => sel(i)
            );
    end generate;
end architecture gates;