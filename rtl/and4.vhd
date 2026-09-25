library ieee;
use ieee.std_logic_1164.all;

entity and4 is
    port (
        a : in  std_logic_vector(3 downto 0);
        y : out std_logic
    );
end entity and4;

architecture gates of and4 is
    signal l1 : std_logic_vector(1 downto 0);
begin
    gen_l1: for i in 0 to 1 generate
        l1(i) <= a(2 * i) and a(2 * i + 1);
    end generate;

    y <= l1(0) and l1(1);
end architecture gates;