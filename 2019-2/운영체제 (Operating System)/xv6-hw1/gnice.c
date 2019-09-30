#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

int main(int argc, char *argv[])
{
  if ((argc<2)||(argc>2)){
    printf(1,"***** Argument Error *****\n");
    printf(1,"Usage : gnice pid \n");
    exit();
  }

  int pid;
  pid = atoi(argv[1]);
  printf(1,"result : %d\n",gnice(pid));

  exit();
}
