//
//  LLADT.cpp
//  AVDemo
//
//  Created by jinbang.li on 2022/9/8.
//

#include "LLADT.hpp"
using namespace std;
//默认构造函数
LLADT::LLADT(){
    printf("构造函数");
}
/**
   交换两个不同的数
   可使用指针修改，引用修改，异或运算修改
 */
//指针修改
void LLADT::Swap1(int *a, int *b){
    int temp = *a;
    *a = *b;
    *b = temp;
}
 //引用修改  别名
void LLADT::Swap2(int &a, int &b){
    int temp = a;
    a = b;
    b = temp;
}
////默认析构函数
LLADT::~LLADT(){
    printf("析构函数");
}
