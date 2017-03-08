//
//  CCSMS.m
//  CCFC
//
//  Created by xichen on 11-12-16.
//  Copyright 2011年 ccteam. All rights reserved.
//

#import "CCSMS.h"


#if CC_ENABLE_PRIVATE_API 
NSString* const SIMStatusReady = @"kCTSIMSupportSIMStatusReady";	// SIM card is ok
NSString* const SIMStatusNotInserted = @"kCTSIMSupportSIMStatusNotInserted";	// SIM card is not inserted
#endif


@interface NSObject(ccPrivate)

+ (id)sharedMessageCenter;
- (BOOL)sendSMSWithText:(NSString *)text serviceCenter:(id)center toAddress:(NSString *)addr;

@end


@implementation CCSMS


// 调用系统短信界面
+ (MFMessageComposeViewController *)showSystemSMSView:(id)delegate
                                    withRecipientArr:(NSArray *)recipientArr
                                        withTextBody:(NSString *)textBody 
                                            animated:(BOOL)animated
{
	if(![MFMessageComposeViewController canSendText])
	{
		return nil;
	}
	
	MFMessageComposeViewController *picker = [MFMessageComposeViewController new];
	if(!picker)
	{
		return nil;
	}
	
	picker.messageComposeDelegate = delegate;
	
	picker.recipients = [NSArray arrayWithArray:(NSArray *)recipientArr];
	picker.body = (NSString *)textBody;
	
	//显示新短信View
	[delegate presentModalViewController:picker animated:animated];
	[picker release];
	return picker;
} 

#if CC_ENABLE_PRIVATE_API
+ (BOOL)sendSMSOnBackground:(NSString *)text withAddr:(NSString *)addr _Depended_On_CoreTelephony_
{
	Class cls = NSClassFromString(@"CTMessageCenter");
	return [[cls sharedMessageCenter] sendSMSWithText:text
								 serviceCenter:nil 
									 toAddress:addr];
	
}
#endif

@end
