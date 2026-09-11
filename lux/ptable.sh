#!/bin/bash
# partition table 

if ! [ -e ./disk ]; then 
    >&2 echo \
        "./disk Not found. Run: sudo dd if=/dev/sda of=disk bs=512 count=1"
    exit 1 
fi

rm -f ./tmp.1 ./tmp.2 2> /dev/null
dd if=boot.img of=tmp.1 bs=1 count=$((0x1be))
dd if=disk of=tmp.2 bs=1 skip=$((0x1be))
cat tmp.1 tmp.2 > boot.img
rm -f ./tmp.1 ./tmp.2 2> /dev/null
