//
//  CCUIDevice.m
//  CCFC
//
//  Created by xichen on 11-12-17.
//  Copyright 2011年 ccteam. All rights reserved.
//

#import "CCUIDevice.h"
#import "CCIOS.h"
#import "CCFileUtil.h"
#import <AudioToolbox/AudioToolbox.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <sys/sysctl.h>
#import <sys/utsname.h>

#if CC_ENABLE_PRIVATE_API
@interface UIDevice(ccPrivate)

- (NSString *)buildVersion;

@end
#endif


@implementation UIDevice(cc)

//获取OS版本
+ (NSString *)osVersion
{
    return [CCIOS osVersion];
}

// 获取OS主版本号
+ (NSString *)osMajorVer
{
    return [CCIOS osMajorVer];
}

// 获取OS子版本号
+ (NSString *)osMinorVer
{
    return [CCIOS osMinorVer];
}

//振动设备
+ (void)vibrate
{
	AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

// whether the device is retina
+ (BOOL)isRetina
{
	if([UIScreen instancesRespondToSelector:@selector(currentMode)])
		return CGSizeEqualToSize(CGSizeMake(640,960), [[UIScreen mainScreen] currentMode].size); 
		
	return NO;
}

// whether the device supports multitask
+ (BOOL)isSupportsMultitask __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_4_0)
{
	return [[UIDevice currentDevice] isMultitaskingSupported];
}

// not ok
// reboot the device
// if you don't have the permission, then "Operation not permitted" will be logged.
+ (int)reboot
{
	system("echo alpine | su root");
	return system("reboot");
}

+ (void)disableAutoLock
{
	[[UIApplication sharedApplication] setIdleTimerDisabled:YES];
}
 
+ (void)enableAutoLock
{
	[[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}

// create UUID
+ (NSString *)createUUID
{
	CFUUIDRef uuidObj = CFUUIDCreate(kCFAllocatorDefault);
	NSString *uuidStr = (NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuidObj);
	CFRelease(uuidObj);
	
	return uuidStr;
}

// get the WAN IP address of the device based on ios
+ (NSString *)getWANAddress
{
    return [self getIPAddressBy:@"pdp_ip0"]; 
}

// get the Wifi IP address of the device based on ios
+ (NSString *)getWifiAddress
{
    return [self getIPAddressBy:@"en0"]; 
}

// get the IP address of the device based on ios by ifaName
+ (NSString *)getIPAddressBy:(NSString *)ifaName
{
    struct ifaddrs *addrs; 
    struct ifaddrs *cur; 
    
    if(!getifaddrs(&addrs))
	{
        cur = addrs; 
        while (cur != NULL) 
		{ 
			if(cur->ifa_addr->sa_family == AF_INET) 
            { 
                if (!strcmp(cur->ifa_name, [ifaName UTF8String]))    
                    return [NSString stringWithUTF8String:
							inet_ntoa(((struct sockaddr_in *)cur->ifa_addr)->sin_addr)]; 
                
			} 
            cur = cur->ifa_next; 
        } 
        freeifaddrs(addrs); 
    } 
    return nil; 
}

// get the host name
+ (NSString *)hostname
{
    char tempHostName[256]; 
    int success = gethostname(tempHostName, 255);
    if (success != 0) 
		return nil;
    tempHostName[255] = '\0';
    
#if TARGET_IPHONE_SIMULATOR
    return [NSString stringWithFormat:@"%s", tempHostName];
#else
    return [NSString stringWithFormat:@"%s.local", tempHostName];
#endif
}

// get the CPU info
+ (BOOL)cpuInfo:(vm_statistics_data_t *)cpuStats 
{ 
	mach_msg_type_number_t infoCount = HOST_CPU_LOAD_INFO_COUNT; 
	kern_return_t kernReturn = 
		host_statistics(mach_host_self(), 
						HOST_CPU_LOAD_INFO, 
						(host_info_t)cpuStats, 
						&infoCount); 
	
	return kernReturn == KERN_SUCCESS; 
} 

// get the boot time of the device
+ (NSDate *)bootTime
{
    size_t size = sizeof(struct timeval);
    struct timeval *time = malloc(sizeof(struct timeval));
    if(time == NULL)
		return nil;
    int mib[2] = {CTL_KERN, KERN_BOOTTIME};
    sysctl(mib, 2, time, &size, NULL, 0);
	
    NSDate *bootTm = [NSDate dateWithTimeIntervalSince1970:time->tv_sec];
    free(time);
    return  bootTm;
}

// returns whether the device is jailbroken or not
+ (BOOL)isJailBroken
{
	return [CCFileUtil isFileExist:@"/Applications/Cydia.app"];
}

// get the device version
+ (NSString *)deviceVersion
{
	struct utsname u;
	uname(&u);
	return [NSString stringWithUTF8String:u.machine];
}

#if CC_ENABLE_PRIVATE_API
+ (NSString *)buildVersion
{
	return [[UIDevice currentDevice] buildVersion];
}

// get the imei string	// not ok
+ (NSString *)getImei
{
	Class cls = NSClassFromString(@"NetworkController");
    return [[cls sharedInstance] IMEI];
}

#endif

@end
