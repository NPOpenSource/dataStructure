#include <stdio.h>
#include "UtilsHeader.h"



typedef struct {
    int *base;
    int *top;
    int stacksize;
}SqStack;

Status InitStack(SqStack *S) {
    S->base = (int *)malloc(STACK_INIT_SIZE*sizeof(int));
    if (!S->base) {
        exit(OVERFLOW);
    }
    S->top = S->base;
    S->stacksize = STACK_INIT_SIZE;
    return OK;
}


Status GetTop(SqStack S,int *e) {
    if (S.top==S.base) {
        return ERROR;
    }
    *e = *(S.top);
    return OK;
}

Status Push(SqStack *S, int e) {
    if (S->top-S->base>=S->stacksize) {
        S->base = (int *)realloc(S->base, (S->stacksize+STACKINCREMENT)*sizeof(int));
        if (!S->base) {
            exit(OVERFLOW);
        }
        S->top = S->base+S->stacksize;
        S->stacksize += STACKINCREMENT;
    }
    S->top++;
    *S->top = e;
    return OK;
}

Status Pop(SqStack *S,int *e) {
    if (S->top == S->base) {
        return ERROR;
    }
    *e = *S->top--;
    return OK;
}

//__attribute__((constructor))
static void beforeSqStackMain(void) {
    SqStack stack;
    InitStack(&stack);
    
    for (int i =0; i<10; i++) {
        Push(&stack, i);
    }
    int e;
    for (int i=0; i<10; i++) {
        Pop(&stack, &e);
        printf("%d\n",e);
    }
}

Status StackEmpty(SqStack s) {
    if (s.top == s.base) {
        return 1;
    } else {
        return 0;
    }
}

//__attribute__((constructor))
static void beforeConvertMain(void) {
    SqStack stack;
    InitStack(&stack);
        
    int N = (int)1348;
    printf("%d\n",N);

    while (N) {
        Push(&stack, N%8);
        N=N/8;
    }

    while (!StackEmpty(stack)) {
        int e;
        Pop(&stack,&e);
        printf("%d",e);
    }
    printf("\n");
}









