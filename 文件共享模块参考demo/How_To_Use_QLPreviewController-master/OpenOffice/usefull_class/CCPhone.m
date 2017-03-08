//
//  CCPhone.m
//  CCFC
//
//  Created by xichen on 11-12-16.
//  Copyright 2011年 ccteam. All rights reserved.
//

#import "CCPhone.h"
#import "CCNSString.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

@implementation CCPhone

// 拨打号码
+ (BOOL)call:(NSString *)phoneNo
{
	NSString *str = [NSString stringWithFormat:@"tel://%@", phoneNo];
	return [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

// get the carrier code  运营商编码
+ (NSString *)getCarrierCode __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_4_0)
{
	CTTelephonyNetworkInfo *info = [[[CTTelephonyNetworkInfo alloc] init] autorelease];
	CTCarrier *carrier = info.subscriberCellularProvider;
	
	return carrier.mobileNetworkCode;
}

// get the SIM type info, eg, ChinaMobile, ChinaTelecom, and so on 运营商名称
+ (NSString *)getSIMCarrierName:(NSString *)carrierCode __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_4_0)
{
	if([carrierCode stringInArr:[NSArray arrayWithObjects:@"00", @"02", @"07", nil]])
		return @"China Mobile";
	if([carrierCode stringInArr:[NSArray arrayWithObjects:@"01", @"06", nil]])
		return @"China Unicom";
	if([carrierCode stringInArr:[NSArray arrayWithObjects:@"03", @"05", nil]])
		return @"China Telecom";
	if([carrierCode stringInArr:[NSArray arrayWithObjects:@"20", nil]])
		return @"China Tietong";
	return nil;
}


#if CC_ENABLE_PRIVATE_API
+ (NSDictionary *)getPhoneNumberDict
{
	return CTSettingCopyMyPhoneNumberExtended();
}

+ (NSString *)getPhoneNumber	// maybe returs nil
{
	NSDictionary *dict = CTSettingCopyMyPhoneNumberExtended();
	return [[[dict objectForKey:@"kCTSettingMyPhoneNumber"] retain] autorelease];
}

+ (NSString *)getPhoneNumberByUserDefaults	// maybe returs nil
{
	return [[[[NSUserDefaults standardUserDefaults] valueForKey:@"SBFormattedPhoneNumber"] retain] autorelease];
}

#endif

@end
