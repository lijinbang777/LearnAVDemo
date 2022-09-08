//
//  LLADT.hpp
//  AVDemo
//
//  Created by jinbang.li on 2022/9/8.
//

#ifndef LLADT_hpp
#define LLADT_hpp

#include <stdio.h>

typedef int ll_int;
class LLADT{
  
public:
    //默认构造函数
    LLADT();
    //指针修改
    void Swap1(int *a, int *b);
     //引用修改
    void Swap2(int &a, int &b);
    //默认析构函数
    ~LLADT();
};
#endif /* LLADT_hpp */
