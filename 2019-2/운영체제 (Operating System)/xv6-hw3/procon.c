#include <pthread.h>
#include <stdio.h>
#include "types.h"
#include "stat.h"
// #include "user.h"
#include "fs.h"
#include "fcntl.h"
//#include "semaphore.c"
//#include <stdlib.h>
#include "defs.h"

#define BUF_SIZE 100
#define NTHREAD 4

void * consumer(int *id);
void * producer(int *id);

char buffer[BUF_SIZE];
int procnt=0, concnt=0;

int thread_id[NTHREAD]  = {0,1,2,3};

int main()
{
	int i;
	pthread_t thread[NTHREAD];
	pthread_create(&thread[0], NULL, (void *)consumer, &thread_id[0]);
	pthread_create(&thread[1], NULL, (void *)consumer, &thread_id[1]);
	pthread_create(&thread[2], NULL, (void *)producer, &thread_id[2]);
	pthread_create(&thread[3], NULL, (void *)producer, &thread_id[3]);

	for(i=0; i< NTHREAD ; i++){
		pthread_join(thread[i], NULL);
	}
    
    // Start all children
//    int pid[NTHREAD];
//    int *args[NTHREAD];
//    int i;
//
//    for (i=0; i<2; i++) {
//        pid[i] = hufs_thread_create(producer, args[i]);
//        if (pid[i]==-1) {
//            printf(1, "main: failed to creat a %d-th thread with pid %d\n", i);
//        }
//        else printf(1, "main: created thread with pid %d\n", pid[i]);
//    }
//
//    for (i=0; i<2; i++) {
//        pid[i] = hufs_thread_create(consumer, args[i]);
//        if (pid[i]==-1) {
//            printf(1, "main: failed to creat a %d-th thread with pid %d\n", i);
//        }
//        else printf(1, "main: created thread with pid %d\n", pid[i]);
//    }
//
//    // Wait for all children
//    for (i=0; i<NTHREAD; i++) {
//        printf(1, "before joining... \n");
//        if (pid[i]!=-1)
//            printf(1, "main: thread %d joined...\n", hufs_thread_join(pid[i]));
//    }
}

void * consumer(int *id){
    int i;
    for(i=0; i<1000; i++){
        int con_mutex = sem_create(1);
        int con_full = sem_create(0);
        int con_empty = sem_create(100);
        int out = 0;
        sem_wait(con_full);
        sem_wait(con_mutex);
        (* (int *) id) =  buffer[out];
        buffer[out] = 0;
        out = (out+1)%100;
        concnt++;
        sem_signal(con_mutex);
        sem_signal(con_empty);
        if (concnt == 1000)
            // exit();
		break;
    }
	return 0;
//	exit();
}

void * producer(int *id){
    int i;
    for(i=0; i<1000; i++){
        int pro_mutex = sem_create(1);
        int pro_full = sem_create(0);
        int pro_empty = sem_create(100);
        int in = 0;
        sem_wait(pro_empty);
        sem_wait(pro_mutex);
        buffer[in] = (* (int *) id);
        in = (in+1)%100;
        procnt++;
        sem_signal(pro_mutex);
        sem_signal(pro_full);
        if (procnt == 1000)
            // exit();
		break;
    }
	return 0;
//	exit();
}
