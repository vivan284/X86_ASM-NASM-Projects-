asmflags = -f elf32
cflags   = -m32 -O0 -Wall -std=c23 -I.
ldflags  = -m elf_i386

.PHONY: clean all

all:  ccapi

# cc: cc.o
# 	ld $(ldflags) $^ -o $@

cc.o: cc.asm cc.asmh
	nasm $(asmflags) $< -o $@

ccapi: ccapi.o cc.o
	$(CC) $(cflags) $^ -o $@

ccapi.o: ccapi.c ccapi.h
	$(CC) $(cflags) -c $< -o $@

clean:
	rm -f *.o ccapi