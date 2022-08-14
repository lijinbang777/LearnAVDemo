//
//  ViewController.m
//  AVDemo
//
//  Created by jinbang.li on 2022/8/14.
//

#import "ViewController.h"

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
    
}

@end
