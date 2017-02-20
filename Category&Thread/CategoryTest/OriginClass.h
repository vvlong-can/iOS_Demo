//
//  OriginClass.h
//  CategoryTest
//
//  Created by vvlong on 2017/2/7.
//  Copyright © 2017年 vvlong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OriginClass : NSObject

@property (nonatomic, copy) NSString *name;
- (void) methodInHeader;
+ (void) classMethodInHeader;
@end
