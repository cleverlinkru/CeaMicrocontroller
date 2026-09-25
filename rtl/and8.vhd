library ieee;
use ieee.std_logic_1164.all;

entity and8 is
    port (
        a : in  std_logic_vector(7 downto 0);
        y : out std_logic
    );
end entity and8;

architecture gates of and8 is
    signal l1 : std_logic_vector(3 downto 0);
    signal l2 : std_logic_vector(1 downto 0);
begin
    gen_l1: for i in 0 to 3 generate
        l1(i) <= a(2 * i) and a(2 * i + 1);
    end generate;

    gen_l2: for i in 0 to 1 generate
        l2(i) <= l1(2 * i) and l1(2 * i + 1);
    end generate;

    y <= l2(0) and l2(1);
end architecture gates;