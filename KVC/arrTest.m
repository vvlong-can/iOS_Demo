//
//  arrTest.m
//  KVC
//
//  Created by vvlong on 2017/3/5.
//  Copyright © 2017年 vvlong. All rights reserved.
//

#import "arrTest.h"

@implementation arrTest
- (id)init {
    if (self == [super init]){
        _arr = [NSMutableArray new];
        [self addObserver:self forKeyPath:@"arr" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    NSLog(@"%@",change);
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"arr"]; //一定要在dealloc里面移除观察
}

- (void)addItem {
    [_arr addObject:@"1"];
}

- (void)addItemObserver {
    [[self mutableArrayValueForKey:@"arr"] addObject:@"1"];
}

- (void)removeItemObserver {
    [[self mutableArrayValueForKey:@"arr"] removeLastObject];
}
@end
