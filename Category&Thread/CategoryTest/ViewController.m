//
//  ViewController.m
//  CategoryTest
//
//  Created by vvlong on 2017/2/7.
//  Copyright © 2017年 vvlong. All rights reserved.
//

#import "ViewController.h"
#import <Aspects.h>
#import "OriginClass.h"
#import <pthread.h>
#import "TicketManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
///    方法hook：
//    [UIViewController aspect_hookSelector:@selector(viewWillAppear:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo, BOOL animated) {
//        NSLog(@"View Controller %@ will appear animated: %tu", aspectInfo.instance, animated);
//    } error:NULL];
//    
//    OriginClass *originClass = [OriginClass new];
//    [originClass methodInHeader];
//    [OriginClass classMethodInHeader];
    
///    NSThread测试
//    TicketManager *manager = [[TicketManager alloc] init];
//    [manager startToSale];
    
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(50, 300, 50, 50)];
    [btn setBackgroundColor:[UIColor blueColor]];
    [btn setTitle:@"test" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickNSThread) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
    UIButton *gcdBtn = [[UIButton alloc] initWithFrame:CGRectMake(150, 300, 50, 50)];
    [gcdBtn setBackgroundColor:[UIColor greenColor]];
    [gcdBtn setTitle:@"GCD" forState:UIControlStateNormal];
    [gcdBtn addTarget:self action:@selector(clickGCD) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:gcdBtn];
}
#pragma mark - GCD Test
-(void)clickGCD {
//    NSLog(@"执行GCD");
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
////        执行耗时任务
//        NSLog(@"网络请求");
//        [NSThread sleepForTimeInterval:3.0];
//        dispatch_async(dispatch_get_main_queue(), ^{
////            回到主线程刷新UI
//            NSLog(@"刷新UI");
//        });
//    });
    
/*
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        NSLog(@"start 1");
        [NSThread sleepForTimeInterval:2];
        NSLog(@"end 1");
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"start 2");
        [NSThread sleepForTimeInterval:2];
        NSLog(@"end 2");
    });

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSLog(@"start 3");
        [NSThread sleepForTimeInterval:2];
        NSLog(@"end 3");
    });
 */
    
//    参数为空值，则为串行队列(单线程)  DISPATCH_QUEUE_CONCURRENT为并行(多线程)
    dispatch_queue_t queue = dispatch_queue_create("testGCD", NULL);
    dispatch_async(queue, ^{
        NSLog(@"start 1");
        [NSThread sleepForTimeInterval:2];
        NSLog(@"end 1");
    });

    dispatch_async(queue, ^{
        NSLog(@"start 2");
        [NSThread sleepForTimeInterval:2];
        NSLog(@"end 2");
    });
    
    dispatch_async(queue, ^{
        NSLog(@"start 3");
        [NSThread sleepForTimeInterval:2];
        NSLog(@"end 3");
    });
}


#pragma mark - NSThread Test
-(void)clickNSThread {
    NSLog(@"Main Thread -- NSThread");
//    三种创建线程的方式
//    方式1
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(runThread1) object:nil];
    [thread start];
    [thread setName:@"thread1"];   //通过[NSThread currentThread].name
    [thread setThreadPriority:0.5];
//    方式2
    [NSThread detachNewThreadSelector:@selector(runThread1) toTarget:self withObject:nil];
//    方式3
    [self performSelectorInBackground:@selector(runThread1) withObject:nil];
    
    
}

-(void)runThread1 {
    NSLog(@"Child Thread");
    for (int i = 0; i <= 10; i++) {
        NSLog(@"Child Thread:%d",i);
        sleep(1);
        if (i == 10) {
            [self performSelectorOnMainThread:@selector(runMainThread) withObject:nil waitUntilDone:YES];
        }
    }
}

-(void)runMainThread {
    NSLog(@"Back to Main Thread");
}

#pragma mark - pthread Test
-(void)clickThread {
    NSLog(@"Main Thread");
    pthread_t pthread;
    pthread_create(&pthread, NULL, run, NULL);
}

void *run(void* data) {
    for (int i = 0; i < 10; i++) {
        NSLog(@"Child Thread:%d",i);
        sleep(1);
    }
    return NULL;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
