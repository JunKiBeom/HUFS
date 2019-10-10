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
	int rv;
	int val;

	if(argc != 3){
		printf(1,"Usage : snice PID NICE\n");
		exit();
	}

	pid = myatoi(argv[1]); 
	val = myatoi(argv[2]);

	if((rv = setnice(pid, val)) != -1)
		printf(1, "Nice of PID <%d> is set to %d\n", pid, val);
	else{
		printf(2, "Error: PID <%d> NOT found or illegal nice <%d> \n", pid, val);
	}
	exit();
}
