#include <stdio.h>
#include "UtilsHeader.h"


void honoimove(int x,int n,int z) {
    printf("将编号为%d的圆盘从%d 移动到 %d 上\n",x,n,z);
}

void hanoi(int n,char x,char y,char z) {
    if (n==1) {
        honoimove(x,1,z);
    } else {
        hanoi(n-1, x, z, y);
        honoimove(x,n,z);
        hanoi(n-1, y, x, z);
    }
}


__attribute__((constructor))
static void beforeExpressMain(void) {
    hanoi(3,1,2,3);
}
