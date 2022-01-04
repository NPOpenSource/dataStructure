//
//  SLinkList.c
//  DataStructure
//
//  Created by glodon on 2021/12/31.
//

#include <stdio.h>
#include "UtilsHeader.h"

#define MAXSIZE 100
typedef struct {
    int data;
    int cur;
}Component,SLinkList[MAXSIZE];

int LocateElem_SL(SLinkList s,int e) {
    int i = s[0].cur;
    while (i && s[i].data != e) {
        i=s[i].cur;
    }
    return i;
}

void InitSpace_SL(SLinkList *space) {
    for (int i=0; i<MAXSIZE-1; i++) {
        space[i]->cur = i+1;
    }
    space[MAXSIZE-1]->cur=0;
}

///相当于从未使用空间中取出一个结点.
int Malloc_SL(SLinkList *space) {
    int i =space[0]->cur;
    if (space[0]->cur) {
        space[0]->cur = space[i]->cur;
    }
    return i;
}

///space 是未使用空间,因此释放一个结点,相当于把结点放入释放空间的链表中
void Free_SL(SLinkList *space,int k) {
    space[k]->cur = space[0]->cur;
    space[0]->cur = k;
}


void differentce(SLinkList *space ,int *s) {
    
    InitSpace_SL(space);
    *s=Malloc_SL(space);
    int r = *s;
    
    int m = 5;
    int n = 4;
    for (int j=1; j<=m; j++) {
        int i = Malloc_SL(space);
        space[i]->data = j*2;
        space[r]->cur = i;
        r = i;
    }
    space[r]->cur = 0;
    for (int j = 1; j<=n; j++) {
        int b = random()%10;
        printf("[input]%d\n",b);
        //p是k的前一个结点
        int p = *s;
        int k = space[*s]->cur;
        while (k!=space[r]->cur && space[k]->data != b) {
            p = k;
            k = space[k]->cur;
        }
        if (k == space[r]->cur) {
            int i = Malloc_SL(space);
            space[i]->data = b;
            ///最后一个结点
            space[i]->cur = space[r]->cur;
            space[r]->cur = i;
        } else {
            space[p]->cur = space[k]->cur;
            Free_SL(space, k);
            if (r == k) {
                r = p;
            }
        }
    }
}


//__attribute__((constructor))
static void beforeSLinkListMain(void) {
    SLinkList list[MAXSIZE];
    int e;
    differentce(list,&e);
    
    int next =list[e]->cur;
    while (next) {
        printf("%d\t",list[next]->data);
        next = list[next]->cur;
    }
    printf("\n");
}
