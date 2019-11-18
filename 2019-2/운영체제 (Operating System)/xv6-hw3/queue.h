#include <stdio.h>
#define MAX 64

typedef struct Queue{
    int items[MAX];
    int front;
    int rear;
}Queue;

void initQueue(Queue *queue);
void enQueue(Queue* queue, int data);
int deQueue(Queue* queue);
int isEmpty(Queue* queue);
int isFull(Queue* queue);
int peek(Queue* queue);
