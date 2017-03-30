//
//  NSObject+Hook.m
//  HookMethod
//
//  Created by vvlong on 2017/3/26.
//  Copyright © 2017年 vvlong. All rights reserved.
//

#import "NSObject+Hook.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "VVSubclass.h"

@implementation NSObject (Hook)

+ (void)hookWithInstance:(id)instance method:(SEL)selector {
    
    Method originMethod = class_getInstanceMethod([instance class], selector);
    if (!originMethod) {
//        NSAssert(true, nil);
    }
    Class newClass = [VVSubclass class];
    
//    修改isa的指针指向
    object_setClass(instance, newClass);
}

@end
