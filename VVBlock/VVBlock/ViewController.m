//
//  ViewController.m
//  VVBlock
//
//  Created by vvlong on 2017/3/21.
//  Copyright © 2017年 vvlong. All rights reserved.
//

#import "ViewController.h"
#import "NextViewController.h"

@interface ViewController ()

@end

@implementation ViewController {
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *image = [UIImage imageNamed:@"vvlong.jpg"];
}


//当视图控制器对象销毁时,移除观察者
- (void)dealloc {
    
    NSLog(@"%@ dealloc",[self class]);

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
