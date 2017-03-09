//
//  Son.m
//  NSProxyTest
//
//  Created by vvlong on 2017/3/9.
//  Copyright © 2017年 vvlong. All rights reserved.
//

#import "Son.h"
#import <objc/runtime.h>
@import ObjectiveC; ///内含protocol_isEqual等判读该类遵守的协议的方法

@interface Son() {
    
    NSMutableDictionary *implementations;
    Protocol *fakeParentClass;
    LiLei *lilei;
    HanMeimei *hanmeimei;
}

@end

@implementation Son

///因为NSProxy并没有init方法 所以需要先自己写一个初始化方法 才可以重写其init
+ (instancetype)initProxy {
    return [[Son alloc] init];
}

- (instancetype)init {
    implementations = [NSMutableDictionary dictionary];
    lilei = [[LiLei alloc] init];
    hanmeimei = [[HanMeimei alloc] init];
    [self registerMethodsWithTarget:lilei];
    [self registerMethodsWithTarget:hanmeimei];
    return self;
}


#pragma mark - private method
- (void)registerMethodsWithTarget:(id )target{
    
    unsigned int numberOfMethods = 0;
    
    //获取target方法列表
    Method *method_list = class_copyMethodList([target class], &numberOfMethods);
    
    for (int i = 0; i < numberOfMethods; i ++) {
        //获取方法名并存入字典
        Method temp_method = method_list[i];
        SEL temp_sel = method_getName(temp_method);
        const char *temp_method_name = sel_getName(temp_sel);
        [implementations setObject:target forKey:[NSString stringWithUTF8String:temp_method_name]];
    }
    
    free(method_list);
}
/*
- (void)injectDependencyObject:(id)object forProtocol:(Protocol *)protocol {
//    断言  这个做法就相当于确保了当前调用的假父类是自己想要的了(因为有多个假父类)
    NSParameterAssert(object && protocol);
    NSAssert([object conformsToProtocol:protocol], @"object %@ does not conform to protocol: %@", object, protocol);
    implementations[NSStringFromProtocol(protocol)] = object;
}

- (BOOL)conformsToProtocol:(Protocol *)aProtocol {
    for (NSString *protocolName in implementations.allKeys) {
        if (protocol_isEqual(aProtocol, NSProtocolFromString(protocolName))) {
            fakeParentClass = aProtocol;
            return YES;
        }
    }
    return [super conformsToProtocol:aProtocol];
}
 */

- (id)isKindOfClass: (id)class {
    
    NSLog(@"fake class%@? NO,It's %@",[self.superclass class],fakeParentClass);
    return self;
}

#pragma mark - NSProxy override methods

- (void)forwardInvocation:(NSInvocation *)invocation{
    //获取当前选择子
    SEL sel = invocation.selector;
    
    //获取选择子方法名
    NSString *methodName = NSStringFromSelector(sel);
    
    //在字典中查找对应的target
//    id target = implementations[methodName];
    id target = implementations[NSStringFromSelector(invocation.selector)];
    //检查target
    if (target && [target respondsToSelector:sel]) {
        [invocation invokeWithTarget:target];
    } else {
        [super forwardInvocation:invocation];
    }
    
    
    
//    //获取当前选择子
//    SEL sel = invocation.selector;
//    
////    遍历实现的protocol 
//    for (id object in implementations.allKeys) {
//        
//        if ([ implementations[object] respondsToSelector:sel]) {
//            [invocation forwardingTargetForSelector:sel];
//            return;
//        }
//    }
//    return [super forwardInvocation:invocation];
}


- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel{

    //获取选择子方法名
    NSString *methodName = NSStringFromSelector(sel);
    
    //在字典中查找对应的target
    id target = implementations[methodName];
    
    //检查target
    if (target && [target respondsToSelector:sel]) {
        return [target methodSignatureForSelector:sel];
    } else {
        return [super methodSignatureForSelector:sel];
    }
//    for (id object in implementations.allValues) {
//        if ([object respondsToSelector:sel]) {
//            return [object methodSignatureForSelector:sel];
//        }
//    }
//    return [super methodSignatureForSelector:sel];
    
}

@end

///全局的初始化
id FakeProxyCreate() {
    
    return [[Son alloc] init];
}

