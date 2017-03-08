//
//  CCSMS.h
//  CCFC
//
//  Created by xichen on 11-12-16.
//  Copyright 2011年 ccteam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
#import "CCConfig.h"
#import "CCDepend.h"
#import "CCCommon.h"

#if CC_ENABLE_PRIVATE_API
extern NSString* const kCTSMSMessageReceivedNotification;
extern NSString* const kCTSMSMessageReplaceReceivedNotification;

CC_EXTERN int	CTSMSMessageGetUnreadCount();
CC_EXTERN int	CTSMSMessageGetRecordIdentifier(void *msg);
CC_EXTERN NSString *CTSIMSupportGetSIMStatus();
CC_EXTERN NSString *CTSIMSupportCopyMobileSubscriberIdentity();
CC_EXTERN id  CTSMSMessageCreate(void* unknow/*always 0*/,NSString* number,NSString* text);
CC_EXTERN void * CTSMSMessageCreateReply(void* unknow/*always 0*/,void * forwardTo,NSString* text); 
CC_EXTERN void* CTSMSMessageSend(id server,id msg);
CC_EXTERN NSString *CTSMSMessageCopyAddress(void *, void *);
CC_EXTERN NSString *CTSMSMessageCopyText(void *, void *);

#endif

@interface CCSMS : NSObject 
{
    
}

// 调用系统短信界面
+ (MFMessageComposeViewController *)showSystemSMSView:(id)delegate
                                     withRecipientArr:(NSArray *)recipientArr
                                         withTextBody:(NSString *)textBody 
                                             animated:(BOOL)animated;

#if CC_ENABLE_PRIVATE_API
// send sms on background
+ (BOOL)sendSMSOnBackground:(NSString *)text withAddr:(NSString *)addr _Depended_On_CoreTelephony_;
#endif
 
@end
