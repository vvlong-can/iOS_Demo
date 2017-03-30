//
//  ViewController.h
//  runtimeTest
//
//  Created by vvlong on 2017/3/29.
//  Copyright © 2017年 vvlong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *info;
@property (weak, nonatomic) IBOutlet UITextView *output;
@property (weak, nonatomic) IBOutlet UILabel *IDTestResult;

@end

