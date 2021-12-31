//
//  LinkList.c
//  DataStructure
//
//  Created by glodon on 2021/12/31.
//

#include <stdio.h>
#include "UtilsHeader.h"

typedef struct LNode{
    int data;
    struct LNode *next;
}LNode, *LinkList;


Status Get_Elem_L(LinkList L,int i, int *e) {
    LinkList p=L->next;
    int j = 1;
    while (p && j<i) {
        p=p->next;
        j++;
    }
    if (!p||j>i) {
        return ERROR;
    }
    *e = p->data;
    return OK;
}

Status ListInsert_L(LinkList *l, int i, int e) {
    LinkList p = *l;
    int j = 0;
    while (p && j<i-1) {
        p = p->next;
        j++;
    }
    if (!p || j>i-1) {
        return ERROR;
    }
    
    LinkList s = (LinkList)malloc(sizeof(LNode));
    s->data = e;
    s->next = p->next;
    p->next = s;
    return OK;
}

Status ListDelete_L(LinkList *l, int i, int *e) {
    LinkList p = *l;
    int j = 0;
    while (p && j<i-1) {
        p = p->next;
        j++;
    }
    if (!p || j>i-1) {
        return ERROR;
    }
    
    LinkList q = p->next;
    *e = q->data;
    p->next = q->next;
    free(q);
    return OK;
}

void CreateList_L(LinkList *l, int n) {
    LinkList s = (LinkList)malloc(sizeof(LNode));
    s->next=NULL;
    for (int i=n; i>0; i--) {
        LinkList p = (LinkList)malloc(sizeof(LNode));
        p->data = i;
        p->next = s->next;
        s->next = p;
    }
    *l = s;
}

void MergeList_L(LinkList *la, LinkList *lb, LinkList *lc) {
    LinkList pa = *la;
    pa = pa->next;
    LinkList pb = *lb;
    pb = pb->next;
    LinkList pc = *la;
    *lc = pc;
    
    while (pa && pb) {
        if (pa->data<=pb->data) {
            pc->next = pa;
            pc=pa;
            pa = pa->next;
        } else {
            pc->next = pb;
            pc = pb;
            pb = pb->next;
        }
    }
    
    pc->next = pa?pa:pb;
    free(*lb);
}

//__attribute__((constructor))
static void beforeLinkInsertMain(void) {
    LinkList L;
    CreateList_L(&L, 10);
    ListInsert_L(&L, 3, 10);
    int e ;
    ListDelete_L(&L, 5,&e);
    printf("%d\n",e);
    LinkList next = L->next;
    while (next) {
        printf("%d\n",next->data);
        next = next->next;
    }
}

//__attribute__((constructor))
static void beforeMergeLinkInsertMain(void) {
    LinkList L;
    CreateList_L(&L, 10);
    
    LinkList L1;
    CreateList_L(&L1, 10);

    LinkList L2;
    MergeList_L(&L, &L1, &L2);
    LinkList next = L2->next;
    while (next) {
        printf("%d\n",next->data);
        next = next->next;
    }
}
