//
//  People.m
//  KVC
//
//  Created by vvlong on 2017/3/4.
//  Copyright © 2017年 vvlong. All rights reserved.
//

#import "People.h"

@implementation People

-(void)setNilValueForKey:(NSString *)key{
    NSLog(@"不能将%@设成nil",key);
}

@end
