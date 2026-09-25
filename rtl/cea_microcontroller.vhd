library ieee;
use ieee.std_logic_1164.all;

entity cea_microcontroller is
    port (
        clk  : in  std_logic;
        sclk : out std_logic;
        mosi : out std_logic;
        miso : in  std_logic;
        cs_n : out std_logic
    );
end entity cea_microcontroller;

architecture rtl of cea_microcontroller is
begin

end architecture rtl;
