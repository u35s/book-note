default :
	make ipl.bin
ipl.bin : ipl.asm Makefile
	nasm ipl.asm -o ipl.bin
run :
	qemu-system-x86_64 -fda ipl.bin
clean :
	-rm ./ipl.bin

