//
//  Dog.m
//  KVC
//
//  Created by vvlong on 2017/3/4.
//  Copyright © 2017年 vvlong. All rights reserved.
//

#import "Dog.h"

@implementation Dog {
    
    NSString* toSetName;
    NSString* isName;
    //NSString* name;
    NSString* _name;
    NSString* _isName;
}
-(void)setName:(NSString*)name{
    
    toSetName = name;
}

-(NSString*)getName{
    return toSetName;
}



/*这说明了重写+(BOOL)accessInstanceVariablesDirectly方法让其返回NO后,
    KVC找不到SetName：方法后，不再去找name系列成员变量，而是直接调用forUndefinedKey方法
    所以开发者如果不想让自己的类实现KVC，就可以这么做。
    下面那两个setter和gettr的注释取消掉*/
//+(BOOL)accessInstanceVariablesDirectly{
//    return NO;
//}
-(id)valueForUndefinedKey:(NSString *)key{
    NSLog(@"出现异常，该key不存在%@",key);
    return nil;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"出现异常，该key不存在%@",key);
}
@end
