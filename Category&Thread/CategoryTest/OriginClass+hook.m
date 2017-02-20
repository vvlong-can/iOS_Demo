//
//  OriginClass+hook.m
//  CategoryTest
//
//  Created by vvlong on 2017/2/7.
//  Copyright © 2017年 vvlong. All rights reserved.
//


#import "OriginClass+hook.h"

@implementation OriginClass (hook)

- (void) methodInHeader {
    NSLog(@"methodInHeader  hook");
}

+ (void) classMethodInHeader {
    NSLog(@"classMethodInHeader hook");
}

- (void) methodInImplementation {
    NSLog(@"methodInImplementation   hook");
}

@end
