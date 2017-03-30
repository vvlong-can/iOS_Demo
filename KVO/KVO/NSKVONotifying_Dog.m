//
//  NSKVONotifying_Dog.m
//  KVO
//
//  Created by vvlong on 2017/3/31.
//  Copyright © 2017年 vvlong. All rights reserved.
//

#import "NSKVONotifying_Dog.h"

@implementation NSKVONotifying_Dog

- (void)setAge:(int)age {
    [super setAge:age];
    [self willChangeValueForKey:@"age"];
    [self didChangeValueForKey:@"age"];
}
@end
