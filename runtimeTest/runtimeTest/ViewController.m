//
//  ViewController.m
//  runtimeTest
//
//  Created by vvlong on 2017/3/29.
//  Copyright © 2017年 vvlong. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import <objc/message.h>
#import <LocalAuthentication/LocalAuthentication.h>

@interface ViewController ()<UITextFieldDelegate>

@end

@implementation ViewController
NSString *text;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.info.delegate = self;
    
    Person *p = [Person new];
//    本地存储
    [p createFile];
    [p performSelector:@selector(eat)];
    
    ///消息转发机制
    objc_msgSend(p,@selector(eat));
    objc_msgSend([Person class] ,@selector(eat));
    
    
    NSLog(@"%@",NSTemporaryDirectory());
    ///runtime可以拿到类的所有属性 -- (包括私有属性)
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([Person class], &count);
    NSLog(@"%d",count);
    for (int i = 0; i < count; i++) {
        NSLog(@"%s",ivar_getName(ivars[i]));
    }
    
    ///Important
    ///The session object keeps a strong reference to the delegate until your app exits or explicitly invalidates the session. If you do not invalidate the session by calling the invalidateAndCancel or finishTasksAndInvalidate method, your app leaks memory until it exits.
    ///    保持所以网络请求都在一个单例中监听 保持不被释放
    ///[NSURLSession sessionWithConfiguration:(nonnull NSURLSessionConfiguration *) delegate:(nullable id<NSURLSessionDelegate>) delegateQueue:(nullable NSOperationQueue *)]
    
    ///懒加载 -- 是为了避免用户不使用的内存直接加载到内存去 UIButton等控件也应该weak 重写set方法
    ///有一个子空间数组 remove掉后 引用不会消失    PS 方法的懒加载 runtime
    
    
    
    ///与web页面交互   UIWebView内部有代理方法 可以拦截URL  -- oc://Method:XXX
    
    /// http://stackoverflow.com/questions/7017281/performselector-may-cause-a-leak-because-its-selector-is-unknown
    
    
    ///方法一
//    [p performSelector:sel_registerName("run")];
//    避免这个方法的警告
    ///方法二
    if (!p) { return; }
    SEL selector = NSSelectorFromString(@"run");
    IMP imp = [p methodForSelector:selector];
    void (*func)(id, SEL) = (void *)imp;
    func(p, selector);
    ///方法三
    SEL selector1 = NSSelectorFromString(@"run");
    ((void (*)(id, SEL))[p methodForSelector:selector1] )(p, selector);
    
    
    ///带参数的转换
//    [p performSelector:sel_registerName("sing:") withObject:@"song"];
    id str = @"song";
    SEL selector2 = NSSelectorFromString(@"sing:");
    IMP imp1 = [p methodForSelector:selector2];
    void (*func1)(id, SEL, id) = (void *)imp1;
    func1(p, selector2,str);
    
    

    ///还有一个带参数 + 返回值的   两个selector3还是分别用OC和C写的方法实现
    NSString *someFood = @"Hamburger";
    NSString *someone = @"Joker";
//    SEL selector3 = NSSelectorFromString(@"eat::");
    SEL selector3 = NSSelectorFromString(@"eat:withFri:");
    IMP imp3 = [p methodForSelector:selector3];
    BOOL (*func3)(id, SEL, id, id) = (void *)imp3;
    BOOL result = p ?
    func3(p, selector3, someFood, someone) : YES;
    
    if (result) {
        NSLog(@"success");
    } else {
        NSLog(@"fail");
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];    //主要是[receiver resignFirstResponder]在哪调用就能把receiver对应的键盘往下收
    text = textField.text;
    NSLog(@"%@",text);
    return YES;
}


- (IBAction)save:(id)sender {
    Person *p = [Person new];
//    p.name = @"vvlong";
//    p.age = 18;
    p.name = text;
    
//    路径
    NSString *tmpPath = NSTemporaryDirectory();
    NSString *filePath = [tmpPath stringByAppendingPathComponent:@"vvlong.xml"];
    
//    存放
    [NSKeyedArchiver archiveRootObject:p toFile:filePath];
    
    
    [p writeFileWithContent:text];
}
- (IBAction)read:(id)sender {
    //    路径
    NSString *tmpPath = NSTemporaryDirectory();
    NSString *filePath = [tmpPath stringByAppendingPathComponent:@"vvlong.xml"];

    Person *p = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    NSLog(@"%@",p.name);
    self.output.text = [p readFileContent];
    
}


- (IBAction)touchTest:(UIButton *)sender {
    //初始化
    LAContext *context = [LAContext new];
    /** 这个属性用来设置指纹错误后的弹出框的按钮文字
     *  不设置默认文字为“输入密码”
     *  设置@""将不会显示指纹错误后的弹出框
     */
    context.localizedFallbackTitle = @"忘记密码";
    NSError *error;
    //判断设备支不支持Touch ID
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        NSLog(@"设备支持Touch ID");
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [self.view addSubview:view];
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                localizedReason:@"指纹验证"
                          reply:^(BOOL success, NSError * _Nullable error) {
                              if (success) {
                                  //验证成功执行
                                  NSLog(@"指纹识别成功");
                                  //在主线程刷新view，不然会有卡顿
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      [view removeFromSuperview];
                                      self.IDTestResult.text = @"指纹识别（成功）";
                                      //保存设置状态
                                      //                                      [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%d", sender.isOn] forKey:@"touchOn"];
                                  });
                              } else {
                                  if (error.code == kLAErrorUserFallback) {
                                      //Fallback按钮被点击执行
                                      NSLog(@"Fallback按钮被点击");
                                  } else if (error.code == kLAErrorUserCancel) {
                                      //取消按钮被点击执行
                                      NSLog(@"取消按钮被点击");
                                  } else {
                                      //指纹识别失败执行
                                      NSLog(@"指纹识别失败");
                                  }
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      [view removeFromSuperview];
                                      self.IDTestResult.text = @"指纹识别（失败）";
                                      //                                      [sender setOn:!sender.isOn animated:YES];
                                      //                                      [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%d", sender.isOn] forKey:@"touchOn"];
                                  });
                              }
                          }];
    } else {
        NSLog(@"设备不支持Touch ID: %@", error);
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"设备不支持Touch ID" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alert animated:YES completion:nil];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            //            [sender setOn:0 animated:YES];
            //            [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%d", sender.isOn] forKey:@"touchOn"];
        }];
        [alert addAction:action];
        
    }
}


@end
