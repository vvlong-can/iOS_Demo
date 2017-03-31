//
//  main.c
//  SortAlgorithm
//
//  Created by vvlong on 2017/3/31.
//  Copyright © 2017年 vvlong. All rights reserved.
//

#include <stdio.h>
#include <stdlib.h>

void selectSort(int array[], int count) {
    
    for (int i = 0; i < count; i++) {
        int index = i;
        for (int j = i+1; j < count; j++) {
            if (array[j] < array[index]) {
                index = j;
            }
        }
        if (i != index) {
            int temp = array[index];
            array[index] = array[i];
            array[i] = temp;
        }
    }
}

void bubblingSort(int array[], int count) {
    for (int i = 0; i < count-1; i++) {
        for (int j = 1; j < count - i; j++) {
            if (array[j] < array[j-1]) {
                int temp = array[j-1];
                array[j-1] = array[j];
                array[j] = temp;
            }
        }
    }
}


#define TRUE 1
#define FALSE 0
#define OK 1
#define ERROR 0
#define OVERFLOW -1




#pragma mark - Stack

typedef int ElemType;
typedef int Status;
typedef struct {
    ElemType *elem;
    int top;
    int size;
    int increment;
} SqStack;

Status InitStack_Sq(SqStack s,int size, int inc) {
    s.elem = (ElemType *)malloc(size * sizeof(ElemType));
    if (NULL == s.elem) {
        return OVERFLOW;
    }
    s.top = 0;
    s.size = size;
    s.increment = inc;
    return OK;
}

Status StackEmpty_Sq(SqStack S){
    if(S.top == 0)
        return TRUE;
    else
        return FALSE;
}

Status Push_Sq(SqStack s, ElemType e) {
    ElemType *newbase;
    if (s.top >= s.size) {
        newbase = (ElemType *)realloc(s.elem, (s.size+s.increment)*sizeof(ElemType));
        if (NULL == newbase) {
            return OVERFLOW;
        }
        s.elem = newbase;
        s.size += s.increment;
    }
    s.elem[s.top++] = e;
    return OK;
}


Status Pop_Sq(SqStack s, ElemType e) {
    if (0 == s.top) {
        return ERROR;
    }
    e = s.elem[--s.top];
    return OK;
}

void Converstion(int N){
    SqStack *S;
    ElemType *e;
    InitStack_Sq(*S, 10, 5);    //栈S的初始容量置为10，每次扩容容量为5
    
    while(N != 0){
        Push_Sq(*S, N%8);   //将N除以8的余数入栈
        N /= 8;            //N取值为其除以8的商
    }                          //理论基础为除8取余法
    
    while(StackEmpty_Sq(*S) == FALSE){
        Pop_Sq(*S, *e);    //依次输出栈中的余数，并赋给元素e
        printf("%d", *e); //打印元素
    }
}

typedef struct LNode{
    ElemType data;
    struct LNode *next;
} LNode, *LinkList;
///顺序表
typedef struct {
    struct LNode *List;
    int length;
    int size;
} RcdSqList;

RcdSqList * init(int arr[], int count){
    if (count < 1) {
        return NULL;
    }
    RcdSqList *rcdSqList = (RcdSqList *)malloc(sizeof(RcdSqList));
    LNode *p;
    p = (LNode *)malloc(sizeof(LNode));
    p->data = arr[0];
    rcdSqList->List = p;
    rcdSqList->length = count;
    rcdSqList->size = count * sizeof(RcdSqList);
    for (int i = 1; i < count; i++) {
        LNode *q = (LNode *)malloc(sizeof(LNode));
        q->data = arr[i];
        p->next = q;
        p = q;
    }
    return rcdSqList;
}

void printSqList(RcdSqList L) {
    LNode *p;
    p = L.List;
    while (p != NULL) {
        printf("%d",p->data);
        p = p->next;
    }
}

void InsertSort(RcdSqList L1) {
    RcdSqList *L = &L1;
    int i, j = 0;
    for (i = 1; i < L->length; ++i)
        if (L->List[i+1].data < L->List[i].data) {
            L->List[0] = L->List[i+1];
            j = i+1;
            do {
                j--;
                L->List[j+1] = L->List[j];
            } while (L->List[0].data < L->List[j-1].data);
            L->List[j] = L->List[0];
        }
//    }
}


int main(int argc, const char * argv[]) {
    int arr[] = {1,2,5,4,3,6};
    
    int num;
    printf("Enter a number:");
    scanf("%d",&num);
    Converstion(1348);
    printf("\n");
    
    
//    SqStack *s;
//    ElemType v[10] = {0,1,2,3,4,5,6,7,8,9};
//    printf("%d\n",InitStack_Sq(*s, 10, 5));
//    RcdSqList *L;
//    L = init(arr, 6);
//
//    InsertSort(*L);
//    printSqList(*L);
    
    
    
//    selectSort(arr, 5);
//    bubblingSort(arr, 5);
//    for (int i = 0; i < 5; i++) {
//        printf("%d ",arr[i]);
//    }
    return 0;
}
