; lux.h

bits 16

struc partition
    .attr       resb 0x01
    .start      resb 0x03
    .type       resb 0x01
    .last       resb 0x03
    .lba        resd 0x01
    .nsect      resd 0x01
    
endstruc 
