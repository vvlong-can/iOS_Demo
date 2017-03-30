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
    
    UIButton *lockBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, 400, 80, 50)];
    [lockBtn setBackgroundColor:[UIColor redColor]];
    [lockBtn setTitle:@"deadLock" forState:UIControlStateNormal];
    [lockBtn addTarget:self action:@selector(deadLock) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:lockBtn];
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
    
    
    ///GCD同步若干个异步调用
    ///使用Dispatch Group追加block到Global Group Queue,这些block如果全部执行完毕，就会执行Main Dispatch Queue中的结束处理的block。
    dispatch_queue_t queue1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, queue1, ^{
        /*加载图片1 */
        NSLog(@"load 1");
    });
    dispatch_group_async(group, queue1, ^{
        /*加载图片2 */
        NSLog(@"load 2");
    });
    dispatch_group_async(group, queue1, ^{
        /*加载图片3 */
        NSLog(@"load 3");
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        // 合并图片
        NSLog(@"end 4");
    });
    
    
    ///YXY旧的登录接口+新的获取tag的接口  ==> 两个请求成功后才返回一个登录成功给用户 以确保正常功能和推送功能
    dispatch_queue_t queue2 = dispatch_queue_create("testBarrier", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_group_async(group, queue2, ^{
        /*加载图片1 */
        NSLog(@"111");
    });
    dispatch_group_async(group, queue2, ^{
        /*加载图片1 */
        NSLog(@"111");
    });
    dispatch_group_async(group, queue2, ^{
        /*加载图片1 */
        NSLog(@"111");
    });
    dispatch_barrier_async(queue2, ^{
        // 写入操作会确保队列前面的操作执行完毕才开始,并会阻塞队列中后来的操作.
        NSLog(@"222");
    });

}

#pragma mark - DeadLock
- (void)deadLock {
    ///异步子线程与主线程中的串行队列互相等待产生死锁
    dispatch_queue_t queue3 = dispatch_queue_create("deadQueue", DISPATCH_QUEUE_SERIAL);
    
    NSLog(@"之前 - %@", [NSThread currentThread]);
    
    dispatch_async(queue3, ^{
        NSLog(@"sync之前 - %@", [NSThread currentThread]);
        dispatch_sync(queue3, ^{
            NSLog(@"sync - %@", [NSThread currentThread]);
        });
        NSLog(@"sync之后 - %@", [NSThread currentThread]);
    });
    
    NSLog(@"之后 - %@", [NSThread currentThread]);
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
