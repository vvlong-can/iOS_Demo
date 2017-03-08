//
//  CCMail.m
//  CCFC
//
//  Created by xichen on 11-12-16.
//  Copyright 2011年 ccteam. All rights reserved.
//

#import "CCMail.h"
#import "CCNSPredicate.h"

@implementation CCMail


// 调用系统mail界面
+ (MFMailComposeViewController *)showMailView:(id)delegate
                               withRecipients:(NSArray *)recipients 
                             withCcRecipients:(NSArray *)ccRecipients
                                  withsubject:(NSString *)subject
                                 withtextBody:(NSString *)textBody 
                                       isHTML:(BOOL)isHTML 
                                     animated:(BOOL)animated
{
    if (![MFMailComposeViewController canSendMail]) 
	{ 
		// 调用系统配置mail界面, 不传入收件人和抄送人信息
		NSString *email = [NSString stringWithFormat:
						   @"mailto:&subject=%@&body=%@", subject, textBody]; 
		email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]; 
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
		return nil;
	}
    
	MFMailComposeViewController *mailViewController = [MFMailComposeViewController new];
	mailViewController.mailComposeDelegate = delegate;
	[mailViewController setToRecipients:(NSArray *)recipients];
	[mailViewController setCcRecipients:(NSArray *)ccRecipients];
	[mailViewController setSubject:(NSString *)subject];
	[mailViewController setMessageBody:(NSString *)textBody isHTML:isHTML];
	
	[delegate presentModalViewController:mailViewController animated:animated];
	[mailViewController release];
	return mailViewController;
}

// returns whether the email is valid format
+ (BOOL)isValidEmailFormat:(NSString *)email 
{
	NSString *emailFormat = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";

	return [NSPredicate isValidFormat:email withFormat:emailFormat];
}
 
@end
