#include "types.h"
#include "stat.h"
#include "user.h"

int myatoi(char str[])
{
	if (str[0]=='-') {
		return -1*atoi(&str[1]);
	}
	else return atoi(str);
}

int main(int argc, char* argv[]){
	int pid; 
	int val;
	
	if(argc != 2){
		printf(1, "Usage : gnice PID \n");
		exit();
	}

	pid = myatoi(argv[1]);

	if((val = getnice(pid)) != -1)
		printf(1, "Nice of PID <%d> is %d.\n", pid, val);
	else{
		printf(2, "Error: PID <%d> NOT found!\n", pid);
	}
	exit();
}
