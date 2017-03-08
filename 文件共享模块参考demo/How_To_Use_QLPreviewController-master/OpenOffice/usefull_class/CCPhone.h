//
//  CCPhone.h
//  CCFC
//
//  Created by xichen on 11-12-16.
//  Copyright 2011年 ccteam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CCConfig.h"
#import "CCDepend.h"
#import <CoreTelephony/CTCall.h>
#import "CCCommon.h"


#if CC_ENABLE_PRIVATE_API
CC_EXTERN NSDictionary *CTSettingCopyMyPhoneNumberExtended() _Depended_On_CoreTelephony_;

CC_EXTERN CFNotificationCenterRef CTTelephonyCenterGetDefault() _Depended_On_CoreTelephony_; 
CC_EXTERN void CTTelephonyCenterAddObserver(
										 CFNotificationCenterRef center, 
										 const void *observer, 
										 CFNotificationCallback callBack, 
										 CFStringRef name, 
										 const void *object, 
										 CFNotificationSuspensionBehavior suspensionBehavior) _Depended_On_CoreTelephony_;
CC_EXTERN void CTTelephonyCenterRemoveObserver(CFNotificationCenterRef center, 
											const void *observer, 
											CFStringRef name, 
											const void *object) _Depended_On_CoreTelephony_;
CC_EXTERN NSString *CTCallCopyAddress(void *, CTCall *call) _Depended_On_CoreTelephony_; //获得来电号码
CC_EXTERN void CTCallDisconnect(CTCall *call) _Depended_On_CoreTelephony_; // 挂断电话
CC_EXTERN void CTCallAnswer(CTCall *call) _Depended_On_CoreTelephony_;		// 接电话
CC_EXTERN int CTCallGetStatus(CTCall *call) _Depended_On_CoreTelephony_;	// get the status of the call

#endif

@interface CCPhone : NSObject 
{
    
}

// 拨打号码
+ (BOOL)call:(NSString *)phoneNo;

// get the carrier code
+ (NSString *)getCarrierCode __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_4_0);

// get the SIM type info, eg, China Mobile, China Telecom, and so on
+ (NSString *)getSIMCarrierName:(NSString *)carrierCode __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_4_0);



#if CC_ENABLE_PRIVATE_API
+ (NSDictionary *)getPhoneNumberDict;

+ (NSString *)getPhoneNumber;				// maybe returs nil
+ (NSString *)getPhoneNumberByUserDefaults;	// maybe returs nil
#endif

@end
