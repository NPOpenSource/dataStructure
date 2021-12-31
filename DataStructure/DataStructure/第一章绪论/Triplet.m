//
//  Triplet.c
//  DataStructure
//
//  Created by glodon on 2021/12/30.
//

#include <stdio.h>
#include "UtilsHeader.h"


typedef int *Triplet;

Status InitTriplet(Triplet *T,int v1, int v2, int v3) {
    Triplet temp = (Triplet)malloc(3*sizeof(int));
    if (!temp) {
        exit(OVERFLOW);
    }
    temp[0]=v1;
    temp[1]=v2;
    temp[2]=v3;
    *T = temp;
    return OK;
}

Status destroyTriplet(Triplet *T) {
    free(*T);
    return OK;
}

Status Get(Triplet T,int i,int *e) {
    if (i<1 || i>3) {
        return ERROR;
    }
    *e = T[i-1];
    return OK;
}

Status Put(Triplet T, int i, int e) {
    if (i<1 || i>3) {
        return ERROR;
    }
    T[i-1] = e;
    return OK;
}

Status IsAccending(Triplet T) {
    return T[0]<=T[1] && T[1]<=T[2];
}

Status IsDescending(Triplet T) {
    return T[0]>=T[1] && T[1]>=T[2];
}

Status Max(Triplet T,int *e) {
    *e = (T[0]>=T[1])?((T[0]>=T[2])?T[0]:T[2]):(T[1]>T[2]?T[1]:T[2]);
    return OK;
}

Status Min(Triplet T,int *e) {
    *e = (T[0]<=T[1])?((T[0]<=T[2])?T[0]:T[2]):(T[1]<T[2]?T[1]:T[2]);
    return OK;
}


//__attribute__((constructor))
static void beforeMain(void) {
    Triplet a;
    InitTriplet(&a, 1, 3, 2);
    int e;
    Get(a, 1,&e);
    printf("%d\n",e);
    Put(a, 3,5);
    Get(a, 3,&e);
    printf("%d\n",e);
    printf("%d\n",IsAccending(a));
    printf("%d\n",IsDescending(a));
    Max(a,&e);
    printf("%d\n",e);
    Min(a,&e);
    printf("%d\n",e);
    destroyTriplet(&a);
}
