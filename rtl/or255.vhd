library ieee;
use ieee.std_logic_1164.all;

entity or255 is
    port (
        a : in  std_logic_vector(255 downto 0);
        y : out std_logic
    );
end entity or255;

architecture gates of or255 is
    signal l1 : std_logic_vector(127 downto 0);
    signal l2 : std_logic_vector(63 downto 0);
    signal l3 : std_logic_vector(31 downto 0);
    signal l4 : std_logic_vector(15 downto 0);
    signal l5 : std_logic_vector(7 downto 0);
    signal l6 : std_logic_vector(3 downto 0);
    signal l7 : std_logic_vector(1 downto 0);
begin
    gen_l1: for i in 0 to 127 generate
        l1(i) <= a(2 * i) or a(2 * i + 1);
    end generate;

    gen_l2: for i in 0 to 63 generate
        l2(i) <= l1(2 * i) or l1(2 * i + 1);
    end generate;

    gen_l3: for i in 0 to 31 generate
        l3(i) <= l2(2 * i) or l2(2 * i + 1);
    end generate;

    gen_l4: for i in 0 to 15 generate
        l4(i) <= l3(2 * i) or l3(2 * i + 1);
    end generate;

    gen_l5: for i in 0 to 7 generate
        l5(i) <= l4(2 * i) or l4(2 * i + 1);
    end generate;

    gen_l6: for i in 0 to 3 generate
        l6(i) <= l5(2 * i) or l5(2 * i + 1);
    end generate;

    gen_l7: for i in 0 to 1 generate
        l7(i) <= l6(2 * i) or l6(2 * i + 1);
    end generate;

    y <= l7(0) or l7(1);
end architecture gates;