#include <stdio.h>
#include "UtilsHeader.h"

#define MAXQUSZIE 100
typedef struct {
    int *base;
    int front;
    int real;
}SqQueue;

Status SqInitQueue(SqQueue *Q) {
    Q->base = (int *)malloc(MAXQUSZIE*sizeof(int));
    if (!Q->base) {
        exit(OVERFLOW);
    }
    Q->front = 0;
    Q->real = Q->front;
    return OK;
}

Status SqInQueue(SqQueue *Q,int e) {
    if ((Q->real+1)%MAXQUSZIE==Q->front) {
        return ERROR;
    }
    Q->base[Q->real]=e;
    Q->real = (Q->real+1)%MAXQUSZIE;
    return OK;
}

Status SqDeQueue(SqQueue *Q,int *e) {
    if (Q->front == Q->real) {
        return ERROR;
    }
    *e = Q->base[Q->front];
    Q->front = (Q->front+1)%MAXQUSZIE;
    return OK;
}

Status SqQueueLength(SqQueue Q) {
    return (Q.real-Q.front+MAXQUSZIE)%MAXQUSZIE;
}

__attribute__((constructor))
static void beforeQueueMain(void) {
    SqQueue queue;
    SqInitQueue(&queue);
    for (int i=0; i<10; i++) {
        SqInQueue(&queue, i);
    }

    int start = queue.front;
    int end = queue.real;
    while (start!=end) {
        printf("%d\t",queue.base[start]);
        start = (start+1)%MAXQUSZIE;
    }
    int e;
    for (int i=0; i<5; i++) {
        SqDeQueue(&queue, &e);
    }
    start = queue.front;
    end = queue.real;
    printf("\n");
    while (start!=end) {
        printf("%d\t",queue.base[start]);
        start = (start+1)%MAXQUSZIE;
    }
    printf("\n%d",SqQueueLength(queue));
    printf("\n");
}

