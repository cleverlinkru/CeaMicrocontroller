GHDL := ghdl
STD := --std=08
BUILD_DIR := build
RTL_DIR := rtl
TB_DIR := tb
TB_SUFFIX := _tb
VCD_FLAGS := --vcd=$(BUILD_DIR)/wave.vcd --stop-time=1000ns

RTL_SOURCES := \
	$(RTL_DIR)/and4.vhd \
	$(RTL_DIR)/and8.vhd \
	$(RTL_DIR)/d_latch.vhd \
	$(RTL_DIR)/or255.vhd \
	$(RTL_DIR)/address_to_select_8.vhd \
	$(RTL_DIR)/rom.vhd \
	$(RTL_DIR)/cea_microcontroller.vhd

MODULES := address_to_select_8 and4 and8 d_latch or255 rom cea_microcontroller

.PHONY: all test clean wave wave-address wave-cea $(MODULES)

all: test

test: $(MODULES)

$(MODULES): %: $(RTL_SOURCES) $(TB_DIR)/%$(TB_SUFFIX).vhd
	@mkdir -p $(BUILD_DIR)
	@echo "Running testbench for $*..."
	$(GHDL) -a $(STD) --workdir=$(BUILD_DIR) $(RTL_SOURCES) $(TB_DIR)/$*$(TB_SUFFIX).vhd
	$(GHDL) -e $(STD) --workdir=$(BUILD_DIR) $*$(TB_SUFFIX)
	$(GHDL) -r $(STD) --workdir=$(BUILD_DIR) $*$(TB_SUFFIX) $(VCD_FLAGS)

clean:
	rm -rf $(BUILD_DIR)
	mkdir -p $(BUILD_DIR)

wave: wave-address

wave-address: address_to_select_8
	gtkwave $(BUILD_DIR)/wave.vcd

wave-cea: cea_microcontroller
	gtkwave $(BUILD_DIR)/wave.vcd
