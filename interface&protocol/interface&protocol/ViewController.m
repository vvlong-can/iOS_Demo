//
//  ViewController.m
//  interface&protocol
//
//  Created by vvlong on 2017/2/26.
//  Copyright © 2017年 vvlong. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Class sarkClass = NSClassFromString(@"Sark");
    Class darkClass = NSClassFromString(@"Dark");
    
    if (sarkClass) {
        NSLog(@"sarkClass exist");
        id obj = [sarkClass performSelector:NSSelectorFromString(@"new")];
        [obj performSelector:NSSelectorFromString(@"speak")];
    } else if (darkClass) {
        NSLog(@"darkClass exist");
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
