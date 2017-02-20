//
//  TicketManager.m
//  CategoryTest
//
//  Created by vvlong on 2017/2/19.
//  Copyright © 2017年 vvlong. All rights reserved.
//

#import "TicketManager.h"
#define Total 50
@interface TicketManager ()

@property int tickets; //剩余票数
@property int saleCount; //售出票数

@property (nonatomic, strong) NSThread  *threadBJ;
@property (nonatomic, strong) NSThread  *threadSH;

@property (nonatomic, strong) NSCondition *ticketCondition;
@property (nonatomic, strong) NSLock *ticketLock;

@end


@implementation TicketManager

-(instancetype) init {
    if (self = [super init]) {
        self.ticketCondition = [[NSCondition alloc] init];
        self.ticketLock = [[NSLock alloc] init];
        self.tickets = Total;
        self.threadBJ = [[NSThread alloc] initWithTarget:self selector:@selector(sale) object:nil];
        [self.threadBJ setName:@"BJ_Thread"];
        self.threadSH = [[NSThread alloc] initWithTarget:self selector:@selector(sale) object:nil];
        [self.threadSH setName:@"SH_Thread"];
    }
    return self;
}

-(void) sale {
        while (true) {
//            1.
//            @synchronized (self) {
//            2.
//            [self.ticketCondition lock];
//            3.
            [self.ticketLock lock];
                if (self.tickets > 0) {
                    [NSThread sleepForTimeInterval:0.5];
                    self.tickets--;
                    self.saleCount = Total - self.tickets;
                    NSLog(@"%@ 当前余票:%d   售出:%d",[NSThread currentThread].name,self.tickets,self.saleCount);
                }
//            1.
//            }
//            2.
//            [self.ticketCondition unlock];
//            3.
            [self.ticketLock unlock];
        }
}

-(void) startToSale {
    [self.threadBJ start];
    [self.threadSH start];
}

@end
