//
//  VVSubclass.m
//  HookMethod
//
//  Created by vvlong on 2017/3/26.
//  Copyright © 2017年 vvlong. All rights reserved.
//

#import "VVSubclass.h"
//#import <objc/runtime.h>
#import <objc/message.h>

@implementation VVSubclass

- (void)originalMethod {
    NSLog(@"newSubclass method");
    
    struct objc_super superClazz = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    
//    调用原方法
    void (*objc_msgSendSuperCasted)(void *, SEL) = (void *)objc_msgSendSuper;
    objc_msgSendSuperCasted(&superClazz,_cmd);
    
}

@end
