section .text

	global _start

_start:
	
	xor ecx, ecx
	mul ecx
	jmp two

one:
	pop ebx
	mov al, 0x5	
	int 0x80
	
	mov esi, eax
	jmp read

exit:

	mov al, 0x1
	xor ebx, ebx
	int 0x80

read:
	mov ebx, esi
	mov al, 0x3
	sub esp, 0x1
	mov ecx, esp
	mov dl, 0x1	
	int 0x80

	xor ebx, ebx
	cmp eax, ebx
	je exit

	mov al, 0x4
	mov bl, 0x1
	mov dl, 0x1
	int 0x80
	
	add esp, 0x1
	jmp	read

two:
	call one
	string: db "/etc/passwd"
