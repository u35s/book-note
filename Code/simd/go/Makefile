.PHONY: e s t

default:e
e:
	go build -gcflags "-N -l" -o simd-go.exe .
s:
	go tool compile -N -l -S simd.go 
t:
	go test -v -gcflags "-N -l" -bench=. .
	go test -v -gcflags "-N -l" .
c:
	rm -f *.exe
	rm -f *.o
