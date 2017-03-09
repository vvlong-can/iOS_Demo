//
//  LiLei.m
//  NSProxyTest
//
//  Created by vvlong on 2017/3/9.
//  Copyright © 2017年 vvlong. All rights reserved.
//

#import "LiLei.h"

@implementation LiLei 

- (void)havingBaby: (NSString *)baby {
    
    NSLog(@"%@ havingBaby: %@",[self class],baby);
}

- (void)earnMonryForBaby:(NSString *)baby {
    NSLog(@"%@ earnMonryForBaby: %@",[self class],baby);
}
@end
