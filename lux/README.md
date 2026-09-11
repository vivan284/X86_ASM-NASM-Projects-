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
* **Emulation Support:** Includes build scripts and a `Makefile` set up for QEMU deployment[cite: 3].

---

## Requirements

To assemble, link, package, and test this project, you need the following toolchain installed on your Linux or Unix environment:

* **NASM (Netwide Assembler):** Required for compiling x86 assembly source code (`lux.asm`)[cite: 3].
* **GNU Binutils (`ld`, `objcopy`):** Required for linking object files according to `lux.ld` and extracting raw binary binaries[cite: 2, 3].
* **QEMU (`qemu-system-i386`):** Required for emulating the 16-bit real-mode environment[cite: 3].
* **Bash & Core Utilities (`dd`, `truncate`, `chmod`):** Used in the build pipeline (`Makefile` and `ptable.sh`) for image creation and sector manipulation[cite: 3, 4].

### Installing Requirements (Ubuntu/Debian)

```bash
sudo apt update
sudo apt install nasm binutils qemu-system-x86 coreutils



### Installing Requirements (Arch Linux)

```bash
sudo pacman -S nasm binutils qemu-desktop

```

---

## File Structure

```text
.
├── lux.asm        # Core bootloader logic and MBR initialization code
├── lux.ld         # Linker script for exact memory placement
├── ptable.sh      # Shell script to merge real drive partition data into the image
├── Makefile       # Compilation pipeline and run configurations
└── include/
    └── lux.h      # Partition table structure definitions

```

---

## Getting Started

### 1. Build the Bootable Image

To assemble the source code, link the binaries into the correct MBR layout, and create `boot.img`:

```bash
make

```

> **Note:** The `ptable.sh` script checks for a local file named `disk` to overlay a real partition table into the final image. You can generate a mock disk image using `dd` if required.
> 
> 

### 2. Run with QEMU

To boot the output image directly inside an x86 QEMU virtual machine:

```bash
make run

```

---

## Creating a Virtual Machine Image (VMware / VirtualBox)

To test `boot.img` in Hypervisors like VirtualBox or VMware, convert the raw binary image into a Virtual Machine Disk format.

### Option A: Convert to VDI (VirtualBox)

Use VirtualBox's built-in management utility:

```bash
VBoxManage convertfromraw boot.img boot.vdi --format VDI

```

* **VirtualBox Setup:** Create a new 32-bit `Other/Unknown` VM, detach the default disk, and attach `boot.vdi` as an IDE hard disk. Ensure **Legacy Boot (BIOS)** mode is active (disable EFI).

### Option B: Convert to VMDK (VMware / Universal)

Use `qemu-img` to create a VMDK container:

```bash
qemu-img convert -f raw -O vmdk boot.img boot.vmdk

```

* **VMware Setup:** Create a new custom VM, select **Use an existing virtual disk**, and target `boot.vmdk`. Ensure the BIOS option (Legacy Boot) is selected in firmware options.

---

## Flashing to a Physical USB Drive

> **Warning:** Writing directly to a storage drive will overwrite its Master Boot Record and data. Double-check your target drive identity carefully.

### 1. Identify your USB Drive

Find the block device name corresponding to your USB drive:

```bash
# On Linux
lsblk

# On macOS
diskutil list

```

### 2. Write the MBR Image

**On Linux:**
Replace `/dev/sdX` with your exact drive (e.g., `/dev/sdb`).

```bash
sudo dd if=boot.img of=/dev/sdX bs=512 status=progress
sync

```

**On macOS:**
Replace `N` with your disk number (e.g., `disk2`).

```bash
sudo diskutil unmountDisk /dev/diskN
sudo dd if=boot.img of=/dev/rdiskN bs=512 status=progress

```

### 3. Booting the Hardware

1. Insert the USB drive into your target machine.
2. Enter the host system's BIOS/UEFI boot menu (usually `F12`, `F11`, `F8`, or `Del` at startup).
3. Select the USB drive under **Legacy / CSM Boot Mode** (do not use UEFI mode).

---

## Clean Build Artifacts

To remove compiled binaries, object files, and generated images:

```bash
make clean

```

```

```
