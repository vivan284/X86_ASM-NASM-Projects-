; cc.asm
%include "cc.asmh"
bits 32
global _start
global encrypt

Section .bss noexec write
	argc resd 0x01
	argv resd 0x05
	_ebx resd 0x01
	_ecx resd 0x01
	_edx resd 0x01
	_edi resd 0x01
	_esi resd 0x01

Section .data noexec write


Section .text exec nowrite
_start:
		nop

_end:
		mov eax,0x01
		xor ebx,ebx
		int 0x80
		hlt


; ebx - argv+0
; ecx +4
; edx +8
; edi +12
; esi +16

encrypt:
		jmp .init
	.error:
		ret
	.init:
		call setup
		cmp eax,0x00
		jz .error

		add ebx,ecx
		mov eax,ebx
		ret

setup: 
		jmp .init
	.error:
		xor eax,eax
		ret
	.init:
		%define arg [esp+0x04]

		mov eax,arg

		mov ebx,[eax]
		mov ecx,argc
		mov [ecx],ebx
		
	.sanity:
		cmp ebx,0x06
		jg .error 
		cmp ebx,0x00
		jz .error

	.args5:
		mov eax,argc
		mov ebx,[eax]
		cmp ebx,0x05
		jle .args4

		mov ebx,0x04
		mov ecx,argc
		mov eax,[ecx]
		dec eax
		mul ebx
		mov edx,arg
		add eax,edx
		mov ebx,[eax]
		mov ecx,_esi
		mov [ecx],ebx

	.args4:
		mov eax,argc
		mov ebx,[eax]
		cmp ebx,0x04
		jle .args3

		mov ebx,0x04
		mov ecx,argc
		mov eax,[ecx]
		dec eax
		mul ebx
		mov edx,arg
		add eax,edx
		mov ebx,[eax]
		mov ecx,_edi
		mov [ecx],ebx

	.args3:
		mov eax,argc
		mov ebx,[eax]
		cmp ebx,0x03
		jle .args2

		mov ebx,0x04
		mov ecx,argc
		mov eax,[ecx]
		dec eax
		mul ebx
		mov edx,arg
		add eax,edx
		mov ebx,[eax]
		mov ecx,_edx
		mov [ecx],ebx

	.args2:
		mov eax,argc
		mov ebx,[eax]
		cmp ebx,0x02
		jle .args1

		mov ebx,0x04
		mov ecx,argc
		mov eax,[ecx]
		dec eax
		mul ebx
		mov edx,arg
		add eax,edx
		mov ebx,[eax]
		mov ecx,_ecx
		mov [ecx],ebx

	.args1:
		mov edx,arg
		add edx,0x04
		mov ebx,[edx]
		mov ecx,_ebx
		mov [ecx],ebx


	.registers:
		mov eax,_ebx
		mov ebx,[eax]
		mov eax,_ecx
		mov ecx,[eax]
		mov eax,_edx
		mov edx,[eax]
		mov eax,_edi
		mov edi,[eax]
		mov eax,_esi
		mov esi,[eax]

		mov eax,0x01
		ret