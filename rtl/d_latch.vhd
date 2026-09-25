library ieee;
use ieee.std_logic_1164.all;

entity d_latch is
    port (
        d : in std_logic;
        c : in std_logic;
        q : out std_logic;
        n_q : out std_logic
    );
end entity d_latch;

architecture gates of d_latch is
    signal s : std_logic;
    signal r : std_logic;
begin
    q <= not (s and n_q);
    n_q <= not (r and q);
    s <= not (d and c);
    r <= not (c and s);
end architecture gates;