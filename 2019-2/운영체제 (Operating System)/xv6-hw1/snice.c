#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

int main(int argc, char *argv[])
{
  int pid, nice;

  if ((argc<3)||(argc>3)){
    printf(1,"***** Argument Error *****\n");
    printf(1,"Usage : snice pid nice \n");
    exit();
  }

  //printf(1,"%c %c\n",argv[2][0],argv[2][1]);
  if (argv[2][0] == '-'){
    printf(1,"***** Negative Input *****\n");
    printf(1,"Invalid nice (0~40)\nresult : -1\n");
    exit();
  }

  pid = atoi (argv[1]);
  nice = atoi (argv[2]);

  printf(1,"pid=%d, nice=%d\n",pid,nice);
  printf(1,"result : %d\n",snice(pid,nice));

  exit();
}
