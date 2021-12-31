//
//  LineSqList.c
//  DataStructure
//
//  Created by glodon on 2021/12/30.
//

#include <stdio.h>
#include "UtilsHeader.h"

#define LIST_INIT_SIZE 100
#define LISTINCREMENT 10

typedef struct {
    int *elem;
    int length;
    int listsize;
}Sqlist;


Status InitList_Sq(Sqlist *l) {
    l->elem = (int *)malloc(LIST_INIT_SIZE*sizeof(int));
    if (!l->elem) {
        exit(OVERFLOW);
    }
    l->length = 0;
    l->listsize = LIST_INIT_SIZE;
    return OK;
}

Status ListInsert_Sq(Sqlist *l,int i,int e) {
    if (i<1 || i>l->length+1) {
        return ERROR;
    }
    
    if (l->length>=l->listsize) {
        int *newbase = (int*)realloc(l->elem, (l->listsize+LISTINCREMENT)*sizeof(int));
        if (!newbase) {
            exit(OVERFLOW);
        }
        l->elem = newbase;
        l->listsize+=LISTINCREMENT;
    }
    
    ///运用指针来计算的
    int *q = &(l->elem[i-1]);
    for (int *p = &(l->elem[l->length-1]) ; p>=q; --p) {
        *(p+1)=*p;
    }
    *q = e;
    l->length++;
    return OK;
}

Status DestroyList_Sq(Sqlist *list){
    Sqlist temp = *list;
    free(temp.elem);
    return OK;
}

Status GetElem_sq(Sqlist list, int i, int *e) {
    if (i>list.length && i<1) {
        return ERROR;
    }
    *e = list.elem[i-1];
    return OK;
}

Status ListDelete_Sq(Sqlist *l ,int i,int *e) {
    if (i<1 || i>l->length+1) {
        return ERROR;
    }
    
    int *p =  &(l->elem[i-1]);
    *e = *p;
    int *q = l->elem+l->length-1;
    for (++p; p<=q; ++p) {
        *(p-1)=*p;
    }
    l->length--;
    return OK;
}

typedef Status (* ListSqComare)(int, int);
int compareEqualSq(int a, int b) {
    return a == b;
}

int LocateElem_sq(Sqlist list, int e, ListSqComare compare){
    int length = list.length;
    for (int i = 0; i<length; i++) {
        if (compare(e,list.elem[i])) {
            return i+1;
        }
    }
    return 0;
}

void mergeList_sq(Sqlist la, Sqlist lb, Sqlist *lc) {
    int *pa = la.elem;
    int *pb = lb.elem;
    int length = la.length+lb.length;
    lc->length = length;
    lc->listsize = length;
    int *pc = (int *)malloc(lc->listsize*sizeof(int));
    lc->elem = pc;
    if (!lc->elem) {
        exit(OVERFLOW);
    }
    int *palast = la.elem+la.length-1;
    int *pblast = lb.elem+lb.length-1;
    
    while (pa<=palast && pb<=pblast) {
        if (*pa<=*pb) {
            *pc++=*pa++;
        } else {
            *pc++=*pb++;
        }
    }
    while (pa<=palast) {
        *pc++=*pa++;
    }
    while (pb<=pblast) {
        *pc++=*pb++;
    }
}

//__attribute__((constructor))
static void beforeSqMain(void) {
    Sqlist list;
    InitList_Sq(&list);
   
    ListInsert_Sq(&list, 1, 1);
    ListInsert_Sq(&list, 1, 2);
    ListInsert_Sq(&list, 1, 3);
    ListInsert_Sq(&list, 1, 4);

    for (int i=0; i<list.length; i++) {
        int e;
        GetElem_sq(list,i+1,&e);
        printf("%d\n",e);
    }
    
    DestroyList_Sq(&list);
}

//__attribute__((constructor))
static void beforedeSqMain(void) {
    Sqlist list;
    InitList_Sq(&list);
   
    ListInsert_Sq(&list, 1, 1);
    ListInsert_Sq(&list, 1, 2);
    ListInsert_Sq(&list, 1, 3);
    ListInsert_Sq(&list, 1, 4);
    int e;
    ListDelete_Sq(&list, 3, &e);
    printf("删除元素:%d\n",e);
    
    for (int i=0; i<list.length; i++) {
        int e;
        GetElem_sq(list,i+1,&e);
        printf("%d\n",e);
    }
    
    DestroyList_Sq(&list);
}

//__attribute__((constructor))
static void beforeQuerySqMain(void) {
    Sqlist list;
    InitList_Sq(&list);
   
    ListInsert_Sq(&list, 1, 1);
    ListInsert_Sq(&list, 1, 2);
    ListInsert_Sq(&list, 1, 3);
    ListInsert_Sq(&list, 1, 4);
    int index = LocateElem_sq(list, 3, compareEqualSq);
    printf("查找元素:%d\n",index);
    
    DestroyList_Sq(&list);
}

//__attribute__((constructor))
static void beforemergeSqMain(void) {
    Sqlist list;
    InitList_Sq(&list);
    ListInsert_Sq(&list, 1, 11);
    ListInsert_Sq(&list, 1, 9);
    ListInsert_Sq(&list, 1, 7);
    ListInsert_Sq(&list, 1, 4);
    
    Sqlist listb;
    InitList_Sq(&listb);
    ListInsert_Sq(&listb, 1, 13);
    ListInsert_Sq(&listb, 1, 6);
    ListInsert_Sq(&listb, 1, 3);
    ListInsert_Sq(&listb, 1, 1);
    
    Sqlist listc;
    mergeList_sq(list, listb, &listc);
    for (int i=0; i<listc.length; i++) {
        int e;
        GetElem_sq(listc,i+1,&e);
        printf("%d\n",e);
    }
    
    DestroyList_Sq(&list);
    DestroyList_Sq(&listb);
    DestroyList_Sq(&listc);
}
