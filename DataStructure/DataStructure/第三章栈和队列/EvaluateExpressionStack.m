#include <stdio.h>
#include "UtilsHeader.h"


typedef struct {
    int *base;
    int *top;
    int stacksize;
}ExpressStack;

Status ExpressInitStack(ExpressStack *S) {
    S->base = (int *)malloc(STACK_INIT_SIZE*sizeof(int));
    if (!S->base) {
        exit(OVERFLOW);
    }
    S->top = S->base;
    S->stacksize = STACK_INIT_SIZE;
    return OK;
}


int ExpressGetTop(ExpressStack S) {
    if (S.top==S.base) {
        return ERROR;
    }
    return *(S.top);
}

Status ExpressPush(ExpressStack *S, int e) {
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

Status ExpressPop(ExpressStack *S,int *e) {
    if (S->top == S->base) {
        return ERROR;
    }
    *e = *S->top--;
    return OK;
}

static int OP[7]={'+','-','*','/','(',')','#'};

Status In(int c ,int op[7]) {
    for (int i =0; i<7; i++) {
        if (c == op[i]) {
            return 1;
        }
    }
    return 0;
}

int getChar(void) {
    static int step = 0;
    static int values[8]= {3,'*','(',7,'-',2,')','#'};
    int value = values[step];
    step++;
    return value;
}

int Precede(int a, int b) {
    if (a == '(' && b == ')') {
        return '=';
    }
    if (a == '#' && b == '#' ) {
        return '=';
    }

    if (b==')') {
        return '>';
    }
    if (b=='#') {
        return '>';
    }
    
    if (b == '(') {
        return '<';
    }
  
    if (a == '(') {
        return '<';
    }
    if (a == ')') {
        return '>';
    }
    if (a == '#') {
        return '<';
    }
    
    if (b == '+' || b == '-') {
        return '>';
    }
    
    if (b == '*' || a == '/') {
        if (a =='*' || a=='/') {
            return '>';
        } else {
            return '<';
        }
    }
   
    return '=';
}

int Operate(int a, int theta, int b) {
    switch (theta) {
        case '+':
            return a+b;
        case '-':
            return a-b;
        case '*':
            return a*b;
        case '/':
            return a/b;
    }
    return 0;
}

//__attribute__((constructor))
static void beforeExpressMain(void) {
    ExpressStack OPTR;///运算符
    ExpressStack OPND;///数字
    ExpressInitStack(&OPTR);
    ExpressInitStack(&OPND);
    ExpressPush(&OPTR, '#');
    int c = getChar();
    // '#' 35
    // '*' 42
    // ')' 41
    // '(' 40
    // '-' 45
    while (c != '#' || ExpressGetTop(OPTR) != '#') {
        if (!In(c, OP)) {
            ExpressPush(&OPND, c);
            c = getChar();
        } else {
            switch (Precede(ExpressGetTop(OPTR), c)) {
                case '<': {
                    ExpressPush(&OPTR, c);
                    c = getChar();
                }
                    break;
                case '=': {
                    int x;
                    ExpressPop(&OPTR, &x);
                    c = getChar();
                }
                    break;
                case '>': {
                    int theta;
                    int a;
                    int b;
                    ExpressPop(&OPTR, &theta);
                    ExpressPop(&OPND, &b);
                    ExpressPop(&OPND, &a);
                    ExpressPush(&OPND, Operate(a,theta,b));
                    break;
                    
                }
              
            }
        }
    }
    printf("%d\n",ExpressGetTop(OPND));
}




