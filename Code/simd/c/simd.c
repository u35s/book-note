#include <stdio.h>

double add(double i,double j){
	return i+j;
}
double addsd(double i,double j ){
	__asm__ __volatile__ (
		"addsd %xmm1,%xmm0\n\t" 
		"popq %rbp\n\t"
		"retq"
	);
}

int main(void){
	double num1;
	double num2;
	for (double i=1;i<100;i++){
		for(double j=1;j<100;j++){
				num1+=add(i,j);
				num2+=addsd(i,j);
		}
	}
	printf("%f\n",num1);
	printf("%f\n",num2);
}
