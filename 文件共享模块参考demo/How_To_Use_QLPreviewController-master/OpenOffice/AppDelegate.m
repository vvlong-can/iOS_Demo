//
//  AppDelegate.m
//  OpenOffice
//
//  Created by willonboy zhang on 12-6-20.
//  Copyright (c) 2012年 willonboy.tk. All rights reserved.
//

#import "AppDelegate.h"
#import "QLviewDemo.h"


@implementation AppDelegate

@synthesize window = _window;

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window.backgroundColor = [UIColor whiteColor];
    
    QLviewDemo *mainVC = [[QLviewDemo alloc] init];
    self.window.rootViewController = mainVC;
    [mainVC release];
    
    [self.window makeKeyAndVisible];
    return YES;
}


@end
