//
//  LinkList.c
//  DataStructure
//
//  Created by glodon on 2021/12/31.
//

#include <stdio.h>
#include "UtilsHeader.h"

typedef struct LNode{
    int *data;
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
    e = p->data;
    return OK;
}
