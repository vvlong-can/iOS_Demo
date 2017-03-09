//
//  HanMeimei.m
//  NSProxyTest
//
//  Created by vvlong on 2017/3/9.
//  Copyright © 2017年 vvlong. All rights reserved.
//

#import "HanMeimei.h"

@interface HanMeimei()
@end

@implementation HanMeimei

- (void)havingBaby: (NSString *)baby {
    
    NSLog(@"%@ havingBaby: %@",[self class],baby);
}

- (void)deliveredBaby:(NSString *)baby {
    
    NSLog(@"%@ deliveredBaby: %@",[self class],baby);
}

@end
