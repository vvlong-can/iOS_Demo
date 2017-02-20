//
//  OriginClass.m
//  CategoryTest
//
//  Created by vvlong on 2017/2/7.
//  Copyright © 2017年 vvlong. All rights reserved.
//

#import "OriginClass.h"

@implementation OriginClass
- (void) methodInHeader {
    NSLog(@"methodInHeader");
}

+ (void) classMethodInHeader {
    NSLog(@"classMethodInHeader");
}

- (void) methodInImplementation {
    NSLog(@"methodInImplementation");
}

@end
