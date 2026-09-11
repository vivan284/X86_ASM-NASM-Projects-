# Lux Bootloader

**Lux** is a lightweight, 16-bit x86 Master Boot Record (MBR) bootloader written in NASM Assembly. Designed for x86 Real Mode, it demonstrates low-level hardware initialization, self-relocation, partition table parsing, and sector loading using standard BIOS interrupts.

---

## Features

* **Self-Relocation:** Automatically relocates its execution context from memory address `0x7C00` to `0x7800` to make room for loading the target partition's boot sector into `0x7C00`[cite: 1].
* **Partition Table Parsing:** Scans standard 16-byte MBR partition structures to find an active, bootable partition[cite: 1, 5].
* **BIOS Interrupt Integration:** 
  * `INT 0x10`: Real-mode video output[cite: 1]
  * `INT 0x16`: Keyboard input handling[cite: 1]
  * `INT 0x13`: Low-level disk sector reads[cite: 1]
* **Precise Linker Control:** Uses a custom linker script (`lux.ld`) to ensure strict layout constraints (446 bytes code/data, 64 bytes partition table, and the `0xAA55` boot signature)[cite: 2].
* **Emulation Support:** Includes build scripts and a `Makefile` set up for QEMU deployment.

---

## File Structure

```text
.
├── lux.asm        # Core bootloader logic and MBR initialization code
├── lux.h          # Partition table structure definitions
├── lux.ld         # Linker script for exact memory placement
├── ptable.sh      # Shell script to merge real drive partition data into the image
└── Makefile       # Compilation pipeline and run configurations
