default :
	make ipl.bin 
	make haribote.sys
	make img
img : Makefile
	dd if=ipl.bin of=haribote.img
	dd if=haribote.sys of=haribote.img bs=1 seek=512
	dd if=/dev/zero of=haribote bs=1 seek=184320 count=0 
ipl.bin : ipl.asm Makefile
	nasm ipl.asm -o ipl.bin
bootpack.s : bootpack.c Makefile
	gcc -S -o bootpack.asm bootpack.c
haribote.sys : asmhead.asm bootpack.s Makefile
	nasm asmhead.asm -o haribote.sys
run :
	qemu-system-x86_64 -fda haribote.img
clean :
	-rm ./ipl.bin
	-rm ./haribote.sys
	-rm ./haribote.img

