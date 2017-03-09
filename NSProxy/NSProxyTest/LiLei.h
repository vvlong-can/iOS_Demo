//
//  LiLei.h
//  NSProxyTest
//
//  Created by vvlong on 2017/3/9.
//  Copyright © 2017年 vvlong. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LileiGetBaby <NSObject>

- (void)havingBaby: (NSString *)baby;
- (void)earnMonryForBaby:(NSString *)baby;

@end

@interface LiLei : NSObject<LileiGetBaby>

@end
