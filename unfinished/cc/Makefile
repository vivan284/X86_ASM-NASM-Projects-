flags=-f elf
ldflags=-m elf_i386

.PHONY: clean

all: cc

cc: cc.o
	ld $(ldflags) $^ -o $@

cc.o: cc.asm cc.asmh
	nasm $(flags) $<

clean:
	rm -f *.o cc