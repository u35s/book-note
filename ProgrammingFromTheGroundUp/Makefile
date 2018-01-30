.PHONY: exit max power clean toupper
as=as -32 
ld=ld -m elf_i386

default:exit max power toupper

exit:
	$(as) exit.s -o exit.o
	$(ld) exit.o -o exit.exe
max:
	$(as) maximum.s -o maximum.o
	$(ld) maximum.o -o maximum.exe
power:
	$(as) power.s -o power.o
	$(ld) power.o -o power.exe
toupper:
	$(as) toupper.s -o toupper.o
	$(ld) toupper.o -o toupper.exe
clean:
	rm *.o *.exe
