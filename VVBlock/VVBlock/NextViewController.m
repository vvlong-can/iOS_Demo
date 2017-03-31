//
//  NextViewController.m
//  VVBlock
//
//  Created by vvlong on 2017/3/21.
//  Copyright © 2017年 vvlong. All rights reserved.
//

#import "NextViewController.h"
#import "PushNextViewController.h"

@interface NextViewController ()

@end

@implementation NextViewController {
     id observer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    //添加观察者,观察主题修改消息通知,并且在收到消息通知后,打印视图控制器对象
    observer = [[NSNotificationCenter defaultCenter] addObserverForName:@"SomethingChangeNotification" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        NSLog(@"%@",self);
    }];
}

- (IBAction)Push:(id)sender {
    PushNextViewController *nextVC = [PushNextViewController new];
    [self.navigationController pushViewController:nextVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    NSLog(@"%@ dealloc",[self class]);
    if (observer) {
        [[NSNotificationCenter defaultCenter] removeObserver:observer];
    }
}

@end
