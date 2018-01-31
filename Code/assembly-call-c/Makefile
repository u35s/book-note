.PHONY: main.s test.o test
default: test main
main.s:
	gcc -S -o main.s -m64 main.c
main.o: main.s
	as -o main.o  main.s
main: main.o
	ld -o main -lc main.o -e main
test.o: main.s
	as -o test.o  test.s
test: test.o
	ld -o test -lc test.o -e start

clean: 
	rm main.s *.o test main
