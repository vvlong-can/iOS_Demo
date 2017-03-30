//
//  Person.m
//  KVO
//
//  Created by vvlong on 2017/3/31.
//  Copyright © 2017年 vvlong. All rights reserved.
//

#import "Person.h"

@implementation Person

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    NSLog(@"监听到%@的%@属性变化为%@",object,keyPath,change);
}

@end
