#include "types.h"
#include "x86.h"
#include "defs.h"
#include "param.h"
#include "spinlock.h"
#include "mmu.h"
#include "proc.h"

#define NSEMS			32 // 32 entries for semophore table
#define MAX_WAITERS		64 // maximum no of waiters


extern struct {
	struct spinlock lock;
	struct proc proc[NPROC];
} ptable;

struct semaphore {
	int value;
	int active; // if it is used or not
	int waiters[MAX_WAITERS];
	struct spinlock lock;
} sem[NSEMS];

// function to initiallize the semophore table (at booting time)
// You don't need call this seminit function!!

void
seminit(void)
{
	int i, j;

	for(i = 0; i < NSEMS; ++i)
	{
		initlock(&sem[i].lock, "semaphore");
		sem[i].active = 0;
		sem[i].value = 0;

		for (j=0; j<MAX_WAITERS; j++)
			sem[i].waiters[j] = -1; // HUFS

	}
}

int
sem_create(int max)
{
	int i;

	// find an entry is NOT active (not used)
	for (i=0; i<NSEMS; i++) {
		acquire(&sem[i].lock);
		if (sem[i].active == 0) {
			sem[i].value = max;
			sem[i].active = 1; // mark it as used (will be)
			release(&sem[i].lock);
			return i;
		}
		release(&sem[i].lock);
	}

	return -1;
}

int
sem_destroy(int num)
{
	// check if the entry is valid
	if(num < 0 || num > NSEMS)
		return -1;

	acquire(&sem[num].lock);
	// check if the entry is actived
	if(sem[num].active != 1)
		return -1;
	sem[num].active = 0;
	release(&sem[num].lock);

	return 0;
}

/*
   You have to just fill up the following functions!!!
*/

int enqueue(struct semaphore *sem, int pid){
	int i;

	for (i=0; i<MAX_WAITERS; i++){
		if (sem->waiters[i]==-1){
			sem->waiters[i] = pid;
			return 0;
		}
	}
	return -1;
}

int dequeue(struct semaphore *sem){
	int i,pid;

	for (i=0; i<MAX_WAITERS; i++){
		if ((pid=sem->waiters[i])!=-1){
			sem->waiters[i]=-1;
			return pid;
		}
	}
	return -1;
}

int
sem_wait(int num)
{
	acquire(&sem[num].lock);

	if(sem[num].active == 0) {
		release(&sem[num].lock);
		return -1;
	}

	sem[num].value--;

	if (sem[num].value < 0){
		if (enqueue(&sem[num], proc->pid)==-1) {
			release(&sem[num].lock);
			return -1;
		}
		sleep(&sem[num],&sem[num].lock);
		// block(&sem[num].lock);

		release(&sem[num].lock);
		return 0;
	}
	else {
		release(&sem[num].lock);
		return 0;
	}
}

int
sem_signal(int num)
{
	acquire(&sem[num].lock);

	if(sem[num].active == 0)
		return -1;

	sem[num].value++;
	if (sem[num].value<=0){

		int pid = dequeue(&sem[num]);

		if (pid == -1) {
			release(&sem[num].lock);
			return -1;
		}

		// wakeup(&sem[num]);

		int ppid = wakeup_pid(pid, &sem[num].lock);
		if (ppid == -1) {
			release(&sem[num].lock);
			return -1;
		}

		release(&sem[num].lock);
        	return 0;
	}
	else {
		release(&sem[num].lock);
		return 0;
	}
}
