//
//  TwoTimesArray.m
//  KVC
//
//  Created by vvlong on 2017/3/4.
//  Copyright © 2017年 vvlong. All rights reserved.
//

#import "TwoTimesArray.h"
@interface TwoTimesArray()
@property (nonatomic,readwrite,assign) NSUInteger count;
@property (nonatomic,copy) NSString* arrName;
@end
@implementation TwoTimesArray
- (void)incrementCount {
    
    self.count ++;
}

- (NSUInteger)countOfNumbers {
    return self.count;
}

- (id)objectInNumbersAtIndex: (NSUInteger)index {     //当key使用numbers时，KVC会找到这两个方法。
    return @(index * 2);
}

- (NSInteger)getNum {                 //第一个,自己一个一个注释试
    return 10;
}

- (NSInteger)num {                        //第二个
    return 11;
}

- (NSInteger)isNum {                    //第三个
    return 12;
}
@end
