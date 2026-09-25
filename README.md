# CEA Microcontroller

VHDL implementation of a microcontroller with SPI interface.

## Project Structure

```text
.
├── rtl/                              # Design sources
│   ├── and4.vhd
│   ├── and8.vhd
│   ├── address_to_select_8.vhd
│   ├── rom.vhd
│   └── cea_microcontroller.vhd
├── tb/                               # Testbenches
│   ├── and4_tb.vhd
│   ├── and8_tb.vhd
│   ├── address_to_select_8_tb.vhd
│   └── cea_microcontroller_tb.vhd
├── mem/                              # Memory initialization files
│   └── rom.mem
├── scripts/                          # Automation scripts
│   └── test_module.sh
├── docs/                             # Documentation
├── tools/                            # Additional tools
├── build/                            # Generated files
├── Makefile
├── README.md
└── .gitignore
```

## Requirements

- GHDL (VHDL simulator)
- GTKWave (waveform viewer, optional)

## Running Tests

### Using Makefile

```bash
make
make address_to_select_8
make and4
make and8
make cea_microcontroller
```

Waveforms are generated in `build/wave.vcd`:

```bash
make wave
make wave-address
make wave-cea
```

Remove generated files with:

```bash
make clean
```

### Using the test script

```bash
./scripts/test_module.sh address_to_select_8
./scripts/test_module.sh and4
./scripts/test_module.sh and8
./scripts/test_module.sh cea_microcontroller
```

## Module Details

### `address_to_select_8`

Converts an 8-bit address to a 256-bit one-hot selector.

- Input: `addr` (`std_logic_vector(7 downto 0)`)
- Output: `sel` (`std_logic_vector(255 downto 0)`)

### `rom`

Loads initialization data from `mem/rom.mem` and selects the addressed byte.

### `cea_microcontroller`

Main microcontroller with SPI interface:

- `clk` — system clock
- `sclk` — SPI clock
- `mosi` — SPI master out, slave in
- `miso` — SPI master in, slave out
- `cs_n` — active-low SPI chip select

## Notes

- VHDL files use the `--std=08` standard.
- The default simulation stop time is `1000ns`.
- Testbenches use assertion-based verification.
