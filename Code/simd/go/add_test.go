package main

import "testing"

var i, j float64 = 86.1111, 89.111

func Test(t *testing.T) {
	if a, b := add(i, j), addsd(i, j); a != b {
		t.Error("!=", a, b)
	}
}

func Benchmark_add(b *testing.B) {
	for k := 0; k < b.N; k++ {
		add(i, j)
	}
}

func Benchmark_addsd(b *testing.B) {
	for k := 0; k < b.N; k++ {
		addsd(i, j)
	}
}
