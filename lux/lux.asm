; lux bootloader
%include "lux.h"
bits 16
global _start 

section .bootloader
 _start:
 stack:
   jmp main

  offset:
      dw 0x0000

 msg1:
  db "Relocating...",0x0a,0x0d,0x00
 msg2:
  db "Lux bootloader, press any key to boot Linux.",0x0a,0x0d,0x00
 err1:
  db "FATAL: No bootable partitions",0x0a,0x0d,0x00

 print:
   push bp 
   mov bp,sp
   mov si,[bp+4]

   cmp dl,0x80
   je .nooff
   sub si,0x0400

 .nooff:
   mov ax,0x0e00
   xor bx,bx

 .loop:
   lodsb
   or al,al
   jz .end
   int 0x10
   jmp .loop
 .end: 
   mov sp,bp
   pop bp
   ret

 diskread:
  push bp
  mov bp,sp
  mov ax,0x0201
  mov bx,0x7c00
  clc
  int 0x13

  mov sp,bp
  pop bp
  ret


 getchs:
  push bp
  mov bp,sp
  mov bx,partition
  xor ax,ax
  mov cx,0x04

 .loop:
  mov byte al,[bx]
  and al,0x80
  cmp al,0x80
  je .chs
  
  dec cx
  jz .err
  add bx,0x10
  jmp .loop

 .err:
  stc 
  mov sp,bp
  pop bp 
  ret 
  

 .chs:
   add bx,[partition.start]
   xor cx,cx
   mov byte ch,[bx]
   inc bx
   mov byte dh,[bx]
   inc bx 
   mov byte cl,[bx]

   mov sp,bp
   pop bp 
   clc 
   ret

 main:
   cli
   mov ax,cs
   mov ss,ax
   mov ds,ax
   mov es,ax
   mov ax,stack
   sub ax,0x02
   mov sp,ax
   sti

   cmp byte dl,0x80
   je relocation
   jmp successful

 relocation:

   mov ax,msg1
   push ax
   call print
   sub sp,0x02


   mov si,0x7c00
   mov di,0x7800
   mov cx,0x0200
   rep movsb

   mov byte dl,0x90
   jmp 0x0000:0x7800
   jmp halt

 successful:
   mov ax,msg2
   push ax
   call print
   sub sp,0x02
   xor ax,ax
   int 0x16

   call getchs
   jc .err
   call diskread
   jc .err

   jmp 0:0x7c00
   jmp halt

 .err:
   mov ax,err1
   push ax
   call print
   sub sp,0x02
   jmp halt
   nop

 halt:
   hlt
 .loop:
   nop
   jmp .loop

section .ptable
 first:
   istruc partition
      at partition,   times 16 db 0x01
   iend
 second:
   istruc partition
      at partition,   times 16 db 0x02
   iend
 third:
   istruc partition
      at partition,   times 16 db 0x03
   iend
 fourth:
   istruc partition
      at partition,   times 16 db 0x04
   iend

section .sign
 signature dw 0xaa55