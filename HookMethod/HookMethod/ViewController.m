//
//  ViewController.m
//  HookMethod
//
//  Created by vvlong on 2017/3/26.
//  Copyright © 2017年 vvlong. All rights reserved.
//

#import "ViewController.h"
#import "VVSubclass.h"
#import "NSObject+Hook.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor redColor];
    ViewController *vc = [[ViewController alloc] init];
    [vc originalMethod];
    
    NSLog(@"---------------");
    ViewController *hookedInstance = [[ViewController alloc] init];
    [ViewController hookWithInstance: hookedInstance method: @selector(originalMethod)];
    [hookedInstance originalMethod];
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"original viewWillAppear");
    if([ViewController oringinalClassMethod]) {
        self.view.backgroundColor = [UIColor whiteColor];
    }
}

- (void)originalMethod {
    NSLog(@"original method");
    NSLog(@"");
}

+ (BOOL)oringinalClassMethod {
    NSLog(@"oringinalClassMethod ");
    NSLog(@"");
    return false;
}



@end
