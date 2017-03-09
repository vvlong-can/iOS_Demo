//
//  Son.h
//  NSProxyTest
//
//  Created by vvlong on 2017/3/9.
//  Copyright © 2017年 vvlong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LiLei.h"
#import "HanMeimei.h"

@protocol FakeProxy <NSObject>

- (void)injectDependencyObject:(id)object forProtocol:(Protocol *)protocol;

@end

@interface Son : NSProxy<LileiGetBaby,HanMeimeiGetBaby,FakeProxy>
+ (instancetype)initProxy;
@end
