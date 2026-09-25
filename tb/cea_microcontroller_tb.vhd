library ieee;
use ieee.std_logic_1164.all;

entity cea_microcontroller_tb is
end entity cea_microcontroller_tb;

architecture sim of cea_microcontroller_tb is
    signal clk  : std_logic := '0';
    signal sclk : std_logic;
    signal mosi : std_logic;
    signal miso : std_logic;
    signal cs_n : std_logic;

    constant CLK_PERIOD : time := 20 ns;
begin
    clk <= not clk after CLK_PERIOD / 2;

    dut: entity work.cea_microcontroller
        port map (
            clk  => clk,
            sclk => sclk,
            mosi => mosi,
            miso => miso,
            cs_n => cs_n
        );
end architecture sim;
