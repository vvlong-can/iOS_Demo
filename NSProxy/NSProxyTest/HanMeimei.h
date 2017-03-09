//
//  HanMeimei.h
//  NSProxyTest
//
//  Created by vvlong on 2017/3/9.
//  Copyright © 2017年 vvlong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LiLei.h"
@protocol HanMeimeiGetBaby <NSObject>

- (void)havingBaby: (NSString *)baby;
- (void)deliveredBaby:(NSString *)baby;

@end
@interface HanMeimei : NSObject<HanMeimeiGetBaby>

@end
