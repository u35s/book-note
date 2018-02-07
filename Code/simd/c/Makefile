.PHONY: e s c

default: e

s:
	gcc -S -o simd-c.s simd.c
e:
	gcc -o simd-c.exe simd.c
c:
	rm -f *.exe
	rm -f *.s
