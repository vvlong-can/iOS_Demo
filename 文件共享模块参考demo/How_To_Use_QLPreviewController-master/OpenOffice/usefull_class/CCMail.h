//
//  CCMail.h
//  CCFC
//
//  Created by xichen on 11-12-16.
//  Copyright 2011年 ccteam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface CCMail : NSObject 
{
    
}

// 调用系统mail界面
+ (MFMailComposeViewController *)showMailView:(id)delegate
                               withRecipients:(NSArray *)recipients 
                             withCcRecipients:(NSArray *)ccRecipients
                                  withsubject:(NSString *)subject
                                 withtextBody:(NSString *)textBody 
                                       isHTML:(BOOL)isHTML 
                                     animated:(BOOL)animated;

// returns whether the email is valid format
+ (BOOL)isValidEmailFormat:(NSString *)email;

 
@end
