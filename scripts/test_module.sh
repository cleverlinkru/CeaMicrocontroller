#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd -- "${SCRIPT_DIR}/.." && pwd)"
cd -- "${ROOT_DIR}"
BUILD_DIR="build"
RTL_DIR="rtl"
TB_DIR="tb"
TB_SUFFIX="_tb"

RTL_SOURCES=(
    "${RTL_DIR}/and4.vhd"
    "${RTL_DIR}/and8.vhd"
    "${RTL_DIR}/d_latch.vhd"
    "${RTL_DIR}/or255.vhd"
    "${RTL_DIR}/address_to_select_8.vhd"
    "${RTL_DIR}/rom.vhd"
    "${RTL_DIR}/cea_microcontroller.vhd"
)

if [ "$#" -ne 1 ]; then
    printf 'Usage: %s <module_name>\n' "$0"
    printf 'Available modules:\n'
    for testbench in "${TB_DIR}"/*"${TB_SUFFIX}".vhd; do
        [ -e "$testbench" ] || continue
        basename "${testbench%.vhd}"
    done
    exit 1
fi

MODULE="$1"
TESTBENCH="${TB_DIR}/${MODULE}${TB_SUFFIX}.vhd"

if [ ! -f "${TESTBENCH}" ]; then
    printf 'Error: Testbench not found: %s\n' "$TESTBENCH" >&2
    exit 1
fi

if [ ! -f "${RTL_DIR}/${MODULE}.vhd" ]; then
    printf 'Error: Module not found: %s\n' "${RTL_DIR}/${MODULE}.vhd" >&2
    exit 1
fi

mkdir -p "${BUILD_DIR}"

printf 'Compiling %s...\n' "$MODULE"
ghdl -a --std=08 --workdir="${BUILD_DIR}" "${RTL_SOURCES[@]}" "${TESTBENCH}"
ghdl -e --std=08 --workdir="${BUILD_DIR}" "${MODULE}${TB_SUFFIX}"

printf 'Running %s...\n' "${MODULE}${TB_SUFFIX}"
ghdl -r --std=08 --workdir="${BUILD_DIR}" "${MODULE}${TB_SUFFIX}" \
    --vcd="${BUILD_DIR}/wave.vcd" --stop-time=1000ns

printf 'Test completed. View waveform with: gtkwave %s\n' "${BUILD_DIR}/wave.vcd"
