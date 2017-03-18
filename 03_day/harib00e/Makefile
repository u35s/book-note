default :
	make ipl.bin 
	make haribote.sys
	make img
img : Makefile
	dd if=ipl.bin of=haribote.img
	dd if=name of=haribote.img bs=1 seek=9728 count=1
	dd if=haribote.sys of=haribote.img bs=1 seek=16896
ipl.bin : ipl.asm Makefile
	nasm ipl.asm -o ipl.bin
haribote.sys : haribote.asm Makefile
	nasm haribote.asm -o haribote.sys
run :
	qemu-system-x86_64 -fda haribote.img
clean :
	-rm ./ipl.bin
	-rm ./haribote.sys
	-rm ./haribote.img

