#include<unistd.h>
#include<stdio.h>

int main(){
	fork();
	fork() && fork() || fork();
	fork();
	printf("+\n");
	return 0;
}
