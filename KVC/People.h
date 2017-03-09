//
//  People.h
//  KVC
//
//  Created by vvlong on 2017/3/4.
//  Copyright © 2017年 vvlong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Address;
@interface People : NSObject
@property (nonatomic,copy) NSString* name;
@property (nonatomic,strong) Address* address;
@property (nonatomic,assign) NSInteger age;
@end
