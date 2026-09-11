flags := -f elf
ldflags := -m elf_i386 -T lux.ld
NASMENV=-i include/
export NASMENV

.PHONY: clean run

all: boot.img

boot.img: lux.elf	
	objcopy -I elf32-i386 -O binary $^ lux.bin
	truncate -s %512 lux.bin
	mv -f lux.bin $@
	chmod 644 $@
	chmod 755 ptable.sh
	./ptable.sh

lux.elf: lux.o
	ld $(ldflags) $^ -o $@
	chmod 644 $@

lux.o: lux.asm
	nasm $(flags) $^ -o $@

clean:
	rm -f *.o *.img *.elf

run: boot.img
	qemu-system-i386 -nographic -hda $^ -m 512