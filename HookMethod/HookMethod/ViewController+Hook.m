//
//  ViewController+Hook.m
//  HookMethod
//
//  Created by vvlong on 2017/3/26.
//  Copyright © 2017年 vvlong. All rights reserved.
//

#import "ViewController+Hook.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation ViewController (Hook)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        ///实例方法交换
//        Class class = [self class];
        
//        SEL originalSelector = @selector(viewWillAppear:);
//        SEL swizzledSelector = @selector(xxx_viewWillAppear:);
        
//        Method originalMethod = class_getInstanceMethod(class, originalSelector);
//        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        ///类方法交换
        // When swizzling a class method, use the following:
        Class class = object_getClass((id)self);
        
        SEL originalSelector = @selector(oringinalClassMethod);
        SEL swizzledSelector = @selector(hookOringinalClassMethod);
        
        Method originalMethod = class_getClassMethod(class, originalSelector);
        Method swizzledMethod = class_getClassMethod(class, swizzledSelector);
        
        BOOL didAddMethod =
        ///避免本来的类没有实现这个方法的情况
        class_addMethod(class,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {
            ///该类本身并没有实现这个originalMethod 而是这个类的父类实现了 所以要拿到父类的来替换
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

#pragma mark - Method Swizzling

- (void)xxx_viewWillAppear:(BOOL)animated {
    [self xxx_viewWillAppear:animated];
    NSLog(@"method swizzling!");
    NSLog(@"viewWillAppear: %@", self);
}

+ (BOOL)hookOringinalClassMethod {
    NSLog(@"class method swizzling!");
    NSLog(@"hookOringinalClassMethod");
    return true;
}


@end
