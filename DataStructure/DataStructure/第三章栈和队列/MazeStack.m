#include <stdio.h>
#include "UtilsHeader.h"

typedef struct {
    int x;
    int y;
}PosType;

typedef struct {
    int ord;
    PosType seat;
    int di;
}SElemType;

typedef struct {
    int x;
    int y;
    int qiang;
}MiGongLocType;


typedef struct {
    SElemType *base;
    SElemType *top;
    int stacksize;
}MazeStack;

Status MazeInitStack(MazeStack *S) {
    S->base = (SElemType *)malloc(STACK_INIT_SIZE*sizeof(SElemType));
    if (!S->base) {
        exit(OVERFLOW);
    }
    S->top = S->base;
    S->stacksize = STACK_INIT_SIZE;
    return OK;
}


Status MazeGetTop(MazeStack S,SElemType *e) {
    if (S.top==S.base) {
        return ERROR;
    }
    *e = *(S.top-1);
    return OK;
}

Status MazePush(MazeStack *S, SElemType e) {
    if (S->top-S->base>=S->stacksize) {
        S->base = (SElemType *)realloc(S->base, (S->stacksize+STACKINCREMENT)*sizeof(SElemType));
        if (!S->base) {
            exit(OVERFLOW);
        }
        S->top = S->base+S->stacksize;
        S->stacksize += STACKINCREMENT;
    }
    S->top++;
    SElemType *ele =S->top;
    ele->ord = e.ord;
    ele->seat = e.seat;
    ele->di = e.di;
    return OK;
}

Status MazePop(MazeStack *S,SElemType *e) {
    if (S->top == S->base) {
        return ERROR;
    }
    *e = *S->top--;
    return OK;
}

Status MazeStackEmpty(MazeStack s) {
    if (s.top == s.base) {
        return 1;
    } else {
        return 0;
    }
}

static MiGongLocType maze[10][10];
Status Pass(PosType curpos) {
    int j = curpos.y;
    int i = curpos.x;
    if (maze[i][j].qiang==0) {
        return 1;
    }
    return 0;
}

PosType NextPos(PosType cur,int ord) {
    int i = cur.x;
    int j = cur.y;
    if (ord == 1) {
        i++;
    }
    if (ord==2) {
        i--;
    }
    if (ord==3) {
        j++;
    }
    if (ord == 4) {
        j--;
    }
    PosType pos;
    pos.x = i;
    pos.y = j;
    return pos;
}

void FootPrint(PosType pos) {
    int j = pos.y;
    int i = pos.x;
    maze[i][j].qiang=2;
}

void MarkPrint(PosType pos) {
    int j = pos.y;
    int i = pos.x;
    maze[i][j].qiang=0;
}

Status MazePath(MiGongLocType maze[10][10],PosType start,PosType end) {
    for (int j = 0; j<10; j++) {
        for (int i=0; i<10; i++) {
            MiGongLocType loc = maze[i][j];
            printf("(%d %d %d)",loc.x,loc.y, loc.qiang);
        }
        printf("\n");
    }
    MazeStack stack;
    MazeInitStack(&stack);
    PosType curpos = start;
    int curstep = 1;
    do {
        if (Pass(curpos)) {
            FootPrint(curpos);
            SElemType e;
            e.ord = curstep;
            e.seat = curpos;
            e.di = 1;
            MazePush(&stack, e);
            if (curpos.x==end.x && curpos.y == end.y) {
                return OK;
            }
          
            curpos = NextPos(curpos, 1);
            curstep++;
            
        } else {
            if (!MazeStackEmpty(stack)) {
                SElemType e;
                MazePop(&stack, &e);
                while (e.di==4 && !MazeStackEmpty(stack)) {
                    MarkPrint(e.seat);
                    MazePop(&stack, &e);
                }
                if (e.di<4) {
                    e.di++;
                    MazePush(&stack, e);
                    curpos = NextPos(e.seat, e.di);
                }
            }
    
        }
    } while (!MazeStackEmpty(stack));
    return 0;
}

//__attribute__((constructor))
static void beforeMiGongMain(void) {
    for (int i=0; i<10; i++) {
        for (int j=0; j<10; j++) {
            maze[i][j].x = i;
            maze[i][j].y = j;
            maze[i][j].qiang = 0;
            if (i==0 || i==9) {
                maze[i][j].qiang = 1;
            }
            if (j==0 || j==9) {
                maze[i][j].qiang = 1;
            }
            if (i==1 && j==8) {
                maze[i][j].qiang = 1;
            }
            if (i==2 &&(j==4 || j == 6 || j == 7)) {
                maze[i][j].qiang = 1;
            }
            if (i==3 && (j==1 || j == 2 || j==4 || j==7)) {
                maze[i][j].qiang = 1;
            }
            if (i==4 &&(j==4 || j==5 || j== 7)) {
                maze[i][j].qiang = 1;
            }
            if (i==5 && j==3) {
                maze[i][j].qiang = 1;
            }
            if (i==6 && (j==3 || j==6 || j==7 )) {
                maze[i][j].qiang = 1;
            }
            if (i==7 &&(j==1 || j== 2 || j==7)) {
                maze[i][j].qiang = 1;
            }
        }
    }
    PosType start;
    start.x = 1;
    start.y = 1;
    PosType end;
    end.x = 8;
    end.y = 8;
    MazePath(maze, start, end);
    printf("\n");
    for (int j = 0; j<10; j++) {
        for (int i=0; i<10; i++) {
            MiGongLocType loc = maze[i][j];
            printf("(%d %d %d)",loc.x,loc.y, loc.qiang);
        }
        printf("\n");
    }
}
