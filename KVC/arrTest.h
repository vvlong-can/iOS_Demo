//
//  arrTest.h
//  KVC
//
//  Created by vvlong on 2017/3/5.
//  Copyright © 2017年 vvlong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface arrTest : NSObject
@property (nonatomic,strong) NSMutableArray* arr;
- (void)addItemObserver;
- (void)addItem;
- (void)removeItemObserver;
@end
