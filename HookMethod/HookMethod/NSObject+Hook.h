//
//  NSObject+Hook.h
//  HookMethod
//
//  Created by vvlong on 2017/3/26.
//  Copyright © 2017年 vvlong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Hook)

+ (void)hookWithInstance:(NSObject *)instance method:(SEL)selector;

@end
