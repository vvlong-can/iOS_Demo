//
//  Person.h
//  runtimeTest
//
//  Created by vvlong on 2017/3/29.
//  Copyright © 2017年 vvlong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject<NSCoding>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) int age;

- (void)eat;
+ (void)eat;

-(void)createFile;
-(void)writeFileWithContent:(NSString *)content;
-(NSString *)readFileContent;
@end
