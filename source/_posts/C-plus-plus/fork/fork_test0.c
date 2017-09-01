#include<unistd.h>
#include<stdio.h>

int main(){
	printf("current process id=%d, parent process id=%d\n", getpid(), getppid());
	return 0;
}
