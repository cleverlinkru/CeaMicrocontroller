library ieee;
use ieee.std_logic_1164.all;

entity d_latch is
    port (
        d : in  std_logic;
        c : in  std_logic;
        q : out std_logic;
        n_q : out std_logic
    );
end entity d_latch;

architecture rtl of d_latch is
    signal q_int : std_logic := '0';
begin
    q   <= q_int;
    n_q <= not q_int;

    process(c, d)
    begin
        if c = '1' then
            q_int <= d;
        end if;
    end process;
end architecture rtl;