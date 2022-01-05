#include <stdio.h>
#include "UtilsHeader.h"

typedef struct QNode {
    int data;
    struct QNode *next;
}QNode, *QueuePtr;

typedef struct {
    QueuePtr front;
    QueuePtr rear;
}LinkQueue;

Status InitQueue(LinkQueue *Q) {
    Q->front =(QueuePtr)malloc(sizeof(QNode));
    if (!Q->front) {
        exit(OVERFLOW);
    }
    Q->rear = Q->front;
    Q->front->next = NULL;
    return OK;
}
//
Status DestroyQueue(LinkQueue *Q) {
    while (Q->front) {
        Q->rear = Q->front->next;
        free(Q->front);
        Q->front = Q->rear;
    }
    return OK;
}

Status EnQueue(LinkQueue *Q,int e) {
    QueuePtr p=(QueuePtr)malloc(sizeof(QNode));
    if (!p) {
        exit(OVERFLOW);
    }
    p->data  = e;
    p->next = NULL;
    Q->rear->next = p;
    Q->rear = p;
    return OK;
}
//
Status DeQueue(LinkQueue *Q,int *e) {
    if (Q->front == Q->rear) {
        return ERROR;
    }
    QueuePtr p = Q->front->next;
    *e = p->data;
    Q->front->next = p->next;
    if (Q->rear == p) {
        Q->rear = Q->front;
    }
    free(p);
    return OK;
}

//__attribute__((constructor))
static void beforeQueueMain(void) {
    LinkQueue queue;
    InitQueue(&queue);
    for (int i=0; i<10; i++) {
        EnQueue(&queue, i);
    }
 
    QueuePtr start = queue.front->next;
    while (start) {
        printf("%d\t",start->data);
        start = start->next;
    }
    int e;
    for (int i=0; i<5; i++) {
        DeQueue(&queue, &e);
    }
    start = queue.front->next;
    printf("\n");
    while (start) {
        printf("%d\t",start->data);
        start = start->next;
    }
}
