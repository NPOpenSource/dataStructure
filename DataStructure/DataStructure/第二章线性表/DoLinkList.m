

#include <stdio.h>
#include "UtilsHeader.h"


///双向链表
typedef struct DuLNode {
    int data;
    struct DuLNode *prior;
    struct DuLNode *next;
}DuLNode, * DuLinkList;

void CreateDuLList_L(DuLinkList *l, int n) {
    DuLinkList s = (DuLinkList)malloc(sizeof(DuLNode));
    *l = s;
    s->next = s;
    s->prior = s;
    for (int i=n; i>0; i--) {
        DuLinkList p = (DuLinkList)malloc(sizeof(DuLNode));
        p->data = i;
        p->next = s->next;
        p->prior = s;
        s->next->prior = p;
        s->next = p;
    }
}

DuLinkList GetElemP_DuL(DuLinkList l,int i) {
    DuLinkList p=l;
    int j = 1;
    while (p->next != l && j<i) {
        p=p->next;
        j++;
    }
    if (j>i) {
        return NULL;
    }
    return p;
}

Status ListInsert_DuL(DuLinkList *l,int i,int e) {
    DuLinkList p = NULL;
    if (!(p = GetElemP_DuL(*l, i))) {
        return ERROR;
    }
    DuLinkList s = (DuLinkList)malloc(sizeof(DuLNode));
    if (!s) {
        return ERROR;
    }
    s->data = e;
    s->prior = p->prior;
    p->prior->next = s;
    s->next = p;
    p->prior = s;
    return OK;
}

Status ListDelete_DuL(DuLinkList *l, int i, int *e) {
    DuLinkList p = NULL;
    if (!(p = GetElemP_DuL(*l, i))) {
        return ERROR;
    }
    *e = p->data;
    p->prior->next = p->next;
    p->next->prior = p->prior;
    free(p);
    return OK;
}

//__attribute__((constructor))
static void beforeDuLinkListMain(void) {
    DuLinkList list;
    CreateDuLList_L(&list, 5);
    DuLinkList next = list->next;
    
    while (next!=list) {
        printf("%d\n",next->data);
        next = next->next;
    }

    ListInsert_DuL(&list, 1, 19);
    next = list->next;
    while (next!=list) {
        printf("%d\n",next->data);
        next = next->next;
    }
    int e;
    ListDelete_DuL(&list, 3, &e);
    printf("%d\n",e);
}

