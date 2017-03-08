//
//  CCUIDevice.h
//  CCFC
//
//  Created by xichen on 11-12-17.
//  Copyright 2011年 ccteam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCConfig.h"
#import <mach/mach.h>

// 判断设备是480*320还是960*640
#define IS_RETINA \
    ([UIScreen instancesRespondToSelector:@selector(currentMode)] ?     \
        CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : \
        NO)

#define	IS_MULTITASK_SUPPORT	\
	[[UIDevice currentDevice] isMultitaskingSupported]

@interface UIDevice(cc)
    
//获取OS版本
+ (NSString *)osVersion;
// 获取OS主版本号
+ (NSString *)osMajorVer;

// 获取OS子版本号
+ (NSString *)osMinorVer;

//振动设备
+ (void)vibrate;
 
// whether the device is retina
+ (BOOL)isRetina;

// whether the device supports multitask
+ (BOOL)isSupportsMultitask __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_4_0);

// not ok
// reboot the device
// if you don't have the permission, then "Operation not permitted" will be logged.
+ (int)reboot;

+ (void)disableAutoLock;
+ (void)enableAutoLock;

// create UUID
+ (NSString *)createUUID;

// get the WAN IP address of the device based on ios
+ (NSString *)getWANAddress;

// get the Wifi IP address of the device based on ios
+ (NSString *)getWifiAddress;

// get the IP address of the device based on ios by ifaName
+ (NSString *)getIPAddressBy:(NSString *)ifaName;

// get the host name
+ (NSString *)hostname;

// get the CPU info
+ (BOOL)cpuInfo:(vm_statistics_data_t *)cpuStats;

// get the boot time of the device
+ (NSDate *)bootTime;

// returns whether the device is jailbroken or not
+ (BOOL)isJailBroken;

// get the device version
+ (NSString *)deviceVersion;

#if CC_ENABLE_PRIVATE_API
+ (NSString *)buildVersion;	// eg, ios 4.3.3, returns @"8J2".

// get the imei string	// not ok
+ (NSString *)getImei;


#endif


@end
