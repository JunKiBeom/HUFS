#include "queue.h"

void initQueue(Queue *queue){
    queue->front = queue->rear = 0;
    for (int i=0;i<MAX;i++)
        queue->items[i]=0;
}

void enQueue(Queue* queue, int data){
    if(isFull(queue)){
        return;
    }
    queue->items[queue->front] = data;
    queue->front++;
    queue->front = queue->front % MAX;
}

int deQueue(Queue* queue){
    int item = 0;
    if(isEmpty(queue))
        return -1;
    item = queue->items[queue->rear];
    queue->rear++;
    queue->rear = queue->rear % MAX;

    return item;
}

int isEmpty(Queue* queue){
    if(queue->rear == -1)
        return 1;
    else
        return 0;
}

int isFull(Queue* queue){
    if(queue->front == 0 && queue->rear == MAX - 1)
        return 1;
    else
        return 0;
}

int peek(Queue* queue){
    return queue->items[0];
}
