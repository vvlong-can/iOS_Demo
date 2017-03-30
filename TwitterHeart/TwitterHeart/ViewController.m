//
//  ViewController.m
//  TwitterHeart
//
//  Created by vvlong on 2017/3/28.
//  Copyright © 2017年 vvlong. All rights reserved.
//

#import "ViewController.h"
#import <Lottie/Lottie.h>
#import <MessageUI/MessageUI.h>
#import "ToAnimationViewController.h"
#import "BluetoothViewController.h"

@interface ViewController ()<UIGestureRecognizerDelegate,UIViewControllerTransitioningDelegate,MFMailComposeViewControllerDelegate,UITextFieldDelegate> {
    LOTAnimationView *animation;
    int clickTimes;
    UIView *subView;
}

@end

@implementation ViewController
NSString *input;

- (void)viewDidLoad {
    [super viewDidLoad];
    clickTimes = 0;
    animation = [LOTAnimationView animationNamed:@"TwitterHeart"];
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(like)];
    recognizer.delegate = self;
    [animation addGestureRecognizer:recognizer];
    
    
//    subView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 100)];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(50, 100, 300, 30)];
    [btn setBackgroundColor:[UIColor redColor]];
    [btn setTitle:@"获取当前GPS位置" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(_showTransitionA) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
//    [subView addSubview:animation];
    
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(50, 200, 90, 30)];
    [btn1 setBackgroundColor:[UIColor redColor]];
    [btn1 setTitle:@"send" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(sendEmailAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(50, 400, 90, 30)];
    [btn2 setBackgroundColor:[UIColor redColor]];
    [btn2 setTitle:@"蓝牙实验" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(_showTransitionB) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
    
    UITextField *emailInput = [[UITextField alloc] initWithFrame:CGRectMake(50, 150, 300, 30)];
    emailInput.placeholder = @"输入你要发送的邮件内容";
    emailInput.returnKeyType = UIReturnKeyDone;
    emailInput.delegate = self;
    [self.view addSubview:emailInput];
    [self.view addSubview:animation];
//    
//    if ([MFMailComposeViewController canSendMail]) { // 用户已设置邮件账户
//        [self sendEmailAction]; // 调用发送邮件的代码
//    }
}


#pragma mark - 蓝牙
- (void)_showTransitionB {
    BluetoothViewController *vc = [[BluetoothViewController alloc] init];
    vc.transitioningDelegate = self;
    [self presentViewController:vc animated:YES completion:NULL];
}

#pragma mark - 邮件保存

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];    //主要是[receiver resignFirstResponder]在哪调用就能把receiver对应的键盘往下收
    input = textField.text;
    NSLog(@"%@",input);
    return YES;
}

- (void)sendEmailAction
{
    // 邮件服务器
    MFMailComposeViewController *mailCompose = [[MFMailComposeViewController alloc] init];
    // 设置邮件代理
    [mailCompose setMailComposeDelegate:self];
    
    // 设置邮件主题
    [mailCompose setSubject:@"数据保存"];
    
    // 设置收件人
    [mailCompose setToRecipients:@[@"vvlong-can@qq.com"]];
    // 设置抄送人
    [mailCompose setCcRecipients:@[@"vvlong_able@icloud.com"]];
    // 设置密抄送
    [mailCompose setBccRecipients:@[@"vvlong_able@icloud.com"]];
    
    /**
     *  设置邮件的正文内容
     */
    NSString *emailContent = input;
    // 是否为HTML格式
    [mailCompose setMessageBody:emailContent isHTML:NO];
    // 如使用HTML格式，则为以下代码
    //    [mailCompose setMessageBody:@"<html><body><p>Hello</p><p>World！</p></body></html>" isHTML:YES];
    
    /**
     *  添加附件
     */
//    UIImage *image = [UIImage imageNamed:@"vvlong.jpg"];
//    NSData *imageData = UIImagePNGRepresentation(image);
//    [mailCompose addAttachmentData:imageData mimeType:@"" fileName:@"vvlong.jpg"];
    
//    NSString *file = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"pdf"];
//    NSData *pdf = [NSData dataWithContentsOfFile:file];
//    [mailCompose addAttachmentData:pdf mimeType:@"" fileName:@"7天精通IOS233333"];
    
    // 弹出邮件发送视图
    [self presentViewController:mailCompose animated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled: // 用户取消编辑
            NSLog(@"Mail send canceled...");
            break;
        case MFMailComposeResultSaved: // 用户保存邮件
            NSLog(@"Mail saved...");
            break;
        case MFMailComposeResultSent: // 用户点击发送
            NSLog(@"Mail sent...");
            break;
        case MFMailComposeResultFailed: // 用户尝试保存或发送邮件失败
            NSLog(@"Mail send errored: %@...", [error localizedDescription]);
            break;
    }
    
    // 关闭邮件发送视图
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 动画

- (void)like {
    
    if (clickTimes %2 ==0) {
        [animation setAnimationProgress:0.3];
        [animation playWithCompletion:^(BOOL animationFinished) {
            // Do Something
            NSLog(@"点赞");
        }];
    } else {
        [animation setAnimationProgress:0.0];
//        [animation pause];
        NSLog(@"取消点赞");
    }
    
    clickTimes++;

}


- (void)_showTransitionA {
    ToAnimationViewController *vc = [[ToAnimationViewController alloc] init];
    vc.transitioningDelegate = self;
    [self presentViewController:vc animated:YES completion:NULL];
}


- (void)_close {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - View Controller Transitioning

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source {
    LOTAnimationTransitionController *animationController = [[LOTAnimationTransitionController alloc] initWithAnimationNamed:@"vcTransition1"
                                                                                                              fromLayerNamed:@"outLayer"
                                                                                                                toLayerNamed:@"inLayer"];
    return animationController;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    LOTAnimationTransitionController *animationController = [[LOTAnimationTransitionController alloc] initWithAnimationNamed:@"vcTransition2"
                                                                                                              fromLayerNamed:@"outLayer"
                                                                                                                toLayerNamed:@"inLayer"];
    return animationController;
}

@end
