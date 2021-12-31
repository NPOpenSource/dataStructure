//
//  LineList.c
//  DataStructure
//
//  Created by glodon on 2021/12/30.
//

#include <stdio.h>
#include "UtilsHeader.h"



struct DList {
    int maxLength;
    int length;
    int *data;
};

typedef struct DList *IntList;

Status InitList(IntList *list) {
    static int length = 1000;
    IntList temp = (IntList)malloc(sizeof(struct DList));
    if (!temp) {
        exit(OVERFLOW);
    }
    temp->maxLength = length;
    temp->length = 0;
    temp->data = (int *)malloc(length*sizeof(int));
    
    if (!temp->data) {
        exit(OVERFLOW);
    }
    *list = temp;
    return OK;
}

Status DestroyList(IntList *list){
    IntList temp = *list;
    free(temp->data);
    free(temp);
    return OK;
}

Status ClearList(IntList *list) {
    IntList temp = *list;
    temp->length = 0;
    return OK;
}

Status ListEmpty(IntList list) {
    return list->length == 0;
}

int ListLength(IntList list) {
    return list->length;
}

Status GetElem(IntList list, int i, int *e) {
    if (i>list->length && i<1) {
        return ERROR;
    }
    *e = list->data[i-1];
    return OK;
}

typedef int (* ListComare)(int, int);

int LocateElem(IntList list, int e, ListComare compare){
    int length = list->length;
    for (int i = 0; i<length; i++) {
        if (compare(e,list->data[i])) {
            return i+1;
        }
    }
    return 0;
}

Status ListInsert(IntList *list,int i, int e) {
    IntList temp = *list;
    int tempNext;
    for (int t = temp->length; t>=i; t--) {
        GetElem(temp, t, &tempNext);
        temp->data[t]=tempNext;
    }
    temp->data[i-1]=e;
    temp->length += 1;
    return OK;
}

int compareEqual(int a, int b) {
    return a == b;
}

//2-1
void unionList(IntList *la,IntList lb) {
    int La_len = ListLength(*la);
    int lb_len = ListLength(lb);
    int e;
    for (int i=1; i<=lb_len; i++) {
        GetElem(lb, i, &e);
        if (!LocateElem(*la, e, compareEqual)) {
            ListInsert(la, ++La_len, e);
        }
    }
}

//__attribute__((constructor))
static void beforeMain(void) {
    IntList list;
    InitList(&list);
    int m[5]={3,4,2,1,8};
    for (int i=0; i<5; i++) {
        ListInsert(&list, i+1, m[i]);
    }

    IntList listB;
    InitList(&listB);
    int n[5]={4,5,7,12,3};
    for (int i=0; i<5; i++) {
        ListInsert(&listB, i+1, n[i]);
    }
    
    unionList(&list,listB);
    
    int e;
    for (int i=0; i<list->length; i++) {
        GetElem(list, i+1, &e);
        printf("%d\n",e);
    }
    DestroyList(&list);
    DestroyList(&listB);
}

//2-2
void mergeList(IntList la,IntList lb,IntList *lc) {
    InitList(lc);
    int i=1, j=1, k=0;
    int la_len = ListLength(la);
    int lb_len = ListLength(lb);
    int ai;
    int bj;
    while ((i<=la_len) && (j<=lb_len)) {
        GetElem(la, i, &ai);
        GetElem(lb, j, &bj);
        if (ai<=bj) {
            ListInsert(lc, ++k, ai);
            i++;
        }else {
            ListInsert(lc, ++k, bj);
            j++;
        }
    }
    while (i<=la_len) {
        GetElem(la, i++, &ai);
        ListInsert(lc, ++k, ai);
    }
    while (j<=lb_len) {
        GetElem(lb, j++, &bj);
        ListInsert(lc, ++k, bj);
    }
}

//__attribute__((constructor))
static void beforeMergeMain(void) {
    IntList list;
    InitList(&list);
    int m[4]={3,5,8,11};
    for (int i=0; i<4; i++) {
        ListInsert(&list, i+1, m[i]);
    }

    IntList listB;
    InitList(&listB);
    int n[7]={2,6,8,9,11,15,20};
    for (int i=0; i<7; i++) {
        ListInsert(&listB, i+1, n[i]);
    }
    
    IntList listc;
    mergeList(list,listB,&listc);
    
    int e;
    for (int i=0; i<listc->length; i++) {
        GetElem(listc, i+1, &e);
        printf("%d\n",e);
    }
    
    DestroyList(&list);
    DestroyList(&listB);
    DestroyList(&listc);
}
