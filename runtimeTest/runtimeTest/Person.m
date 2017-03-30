//
//  Person.m
//  runtimeTest
//
//  Created by vvlong on 2017/3/29.
//  Copyright © 2017年 vvlong. All rights reserved.
//

#import "Person.h"
#import <objc/message.h>

@implementation Person

- (void)eat {
    NSLog(@"调用对象方法");
}


+ (void)eat {
    NSLog(@"调用类方法");
}


void run() {
    NSLog(@"I'm running");
}


void sing(id sel, SEL _cmd, id obj) {
    NSLog(@"I'm singing %@",obj);
}


bool eat(id sel, SEL _cmd, id someFood, id someone) {
    NSLog(@"I'm eating %@ with my fri %@",someFood,someone);
    return YES;
}

- (BOOL)eat:(NSString *)food withFri:(NSString *)someone {
    NSLog(@"I'm eating %@ with my fri %@",food,someone);
    return YES;
}


///当一个类被调用了一个没有实现的（类/实例）方法时，会调用此方法
+ (BOOL)resolveClassMethod:(SEL)sel {
    return [super resolveClassMethod:sel];
}

/**
 class_addMethod(__unsafe_unretained Class cls, SEL name, IMP imp, const char *types)
 cls 类
 name 方法名
 IMP 实现方法的函数指针
 type 返回值类型  v和v@: 都可以 因为有隐式参数 id self, SEL _cmd
 **/
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    if (sel == @selector(run)) {
       
        class_addMethod([self class], sel, (IMP)run, "v@:");
    } else if (sel == @selector(sing:)) {
        
        class_addMethod([self class], sel, (IMP)sing, "v@:@");
    } else if (sel == @selector(eat:withFri:)) {
        //        用OC实现方法
        IMP imp = [self methodForSelector:sel];
        class_addMethod([self class], sel, imp, "B@:");
    } else if (sel == @selector(eat::)) {
        //        用C实现方法
        class_addMethod([self class], sel, (IMP)eat, "B@:");
    }
    
    return [super resolveInstanceMethod:sel];
}

//实现归档协议
- (void)encodeWithCoder:(NSCoder *)aCoder {
//    [aCoder encodeObject:_name forKey:@"name"];
//    [aCoder encodeInt:_age forKey:@"age"]; //原始写法
    
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([self class], &count);
    for (int i = 0; i < count; i++) {
        const char *name = ivar_getName(ivars[i]);

        NSString *key = [NSString stringWithUTF8String:name];
        //归档
        [aCoder encodeObject:[self valueForKey:key] forKey:key];
    }
    
    free(ivars);
}

//反序列化，归档
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
//        _name = [aDecoder decodeObjectForKey:@"name"];
//        _age = [aDecoder decodeIntForKey:@"age"];
        unsigned int count = 0;
        Ivar *ivars = class_copyIvarList([self class], &count);
        for (int i = 0; i < count; i++) {
            const char *name = ivar_getName(ivars[i]);
            NSString *key = [NSString stringWithUTF8String:name];
            //解档
            id value = [aDecoder decodeObjectForKey:key];
            //KVC设置
            [self setValue:value forKey:key];
        }
        free(ivars);
    }
    return self;
}

-(void)createFile {
    NSString *documentsPath =[self getDocumentsPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *iOSPath = [documentsPath stringByAppendingPathComponent:@"iOS.txt"];
    BOOL isSuccess = [fileManager createFileAtPath:iOSPath contents:nil attributes:nil];
    if (isSuccess) {
        NSLog(@"success");
    } else {
        NSLog(@"fail");
    }
}
//写文件
-(void)writeFileWithContent:(NSString *)content {
    NSString *documentsPath =[self getDocumentsPath];
    NSString *iOSPath = [documentsPath stringByAppendingPathComponent:@"iOS.txt"];
    //    NSString *content = @"我要写数据啦";
    content = [NSString stringWithFormat:@"%@\n%@",content,[self readFileContent]];
    BOOL isSuccess = [content writeToFile:iOSPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    if (isSuccess) {
        NSLog(@"write success");
    } else {
        NSLog(@"write fail");
    }
}
//读文件
-(NSString *)readFileContent {
    NSString *documentsPath =[self getDocumentsPath];
    NSString *iOSPath = [documentsPath stringByAppendingPathComponent:@"iOS.txt"];
    NSString *content = [NSString stringWithContentsOfFile:iOSPath encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"read success: %@",content);
    return content;
}

//沙盒文件处理
#pragma mark - SandBoxOperation
- (NSString *)getDocumentsPath {
    //获取Documents路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSLog(@"path:%@", path);
    return path;
}

- (BOOL)isSxistAtPath:(NSString *)filePath {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExist = [fileManager fileExistsAtPath:filePath];
    return isExist;
}

@end
