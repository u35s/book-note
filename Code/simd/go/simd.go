package main

import "fmt"

func main() {
	var num1, num2 float64
	for i := float64(1); i < 100; i++ {
		for j := float64(1); j < 100; j++ {
			num1 += add(i, j)
			num2 += addsd(i, j)
		}
	}

	fmt.Println(num1, num2)
}

func add(i, j float64) float64 { return i + j }
func addsd(i, j float64) float64
