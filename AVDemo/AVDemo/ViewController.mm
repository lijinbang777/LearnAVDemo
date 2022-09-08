//
//  ViewController.m
//  AVDemo
//
//  Created by jinbang.li on 2022/8/14.
//

#import "ViewController.h"
#import "LLADT.hpp"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addBtn];
}
- (void)addBtn{
    self.view.backgroundColor = UIColor.whiteColor;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(self.view.center.x-50, self.view.center.y-50, 100, 100);
    [btn setTitle:@"opengles" forState:UIControlStateNormal];
    btn.backgroundColor = UIColor.redColor;
    [btn addTarget:self action:@selector(btnAct:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}
- (void)btnAct:(UIButton *)sender{
    
    //引用与指针的应用
    LLADT adt;
    int a = 3;
    int b = 4;
    printf("栈区调用");
    printf("a===%d,b===%d\n",a,b);
    adt.Swap1(&a, &b);
    printf("a===%d,b===%d\n",a,b);
    adt.Swap2(a, b);
    printf("a===%d,b===%d\n",a,b);
    printf("\n\n\n");
    
    
    printf("椎区调用");
    LLADT *adt1 = new LLADT();
    adt1->Swap1(&a, &b);
    printf("a===%d,b===%d\n",a,b);
    adt1->Swap2(a, b);
    printf("a===%d,b===%d\n",a,b);
    delete adt1;
}

@end
