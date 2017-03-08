//
//  CCKeyboard.m
//  CCFC
//
//  Created by xichen on 11-12-23.
//  Copyright 2011 ccteam. All rights reserved.
//

#import "CCKeyboard.h"

@implementation CCKeyboard

+ (UITextInputMode *)currentInputMode
{
	return [UITextInputMode currentInputMode];
}

+ (NSString *)primaryLanguage
{
	return [[UITextInputMode currentInputMode] primaryLanguage];
}

// default rect in portrait mode
+ (CGRect)defaultPortraitKeyboardRect
{
	return CGRectMake(0, 264, 320, 216);
}

// get the window of keyboard
+ (UIWindow *)getKeyboardWindow
{
	NSArray *arr = [[UIApplication sharedApplication] windows];
	for(UIWindow *temp in arr)
	{
		if([temp isMemberOfClass:NSClassFromString(@"UITextEffectsWindow")])
			return temp;
	}
	return nil;
}


// get the view of the keyboard
+ (UIView *)getKeyboardView
{
	UIWindow *window = [self getKeyboardWindow];
	if(window != nil)
	{
		NSMutableArray *arr = [NSMutableArray array];
		NSString *keyboardName = [self getKeyboardViewName];
		[window getSubViewIsMemberOf:keyboardName array:arr maxSize:1];
		if([arr count])
			return [arr objectAtIndex:0];
		return nil;
	}
	return nil;
}

// get the name of the keyboard
+ (NSString *)getKeyboardViewName
{
	float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
	if(sysVer < 3.2)
		return @"UIKeyboard";
	return @"UIPeripheralHostView";
}

#if	CC_ENABLE_PRIVATE_API
+ (NSString *)getCurrentInputMode
{
	return (NSString *)UIKeyboardGetCurrentInputMode();
}

+ (NSString *)getLocalizedInputModeName:(NSString *)inputInternalName
{
	return (NSString *)UIKeyboardLocalizedInputModeName(inputInternalName);
}

+ (NSBundle *)getBundleForInputMode:(NSString *)inputInternalName
{
	return (NSBundle *)UIKeyboardBundleForInputMode(inputInternalName);
}

+ (NSArray *)getSupportedInputModes
{
	return (NSArray *)UIKeyboardGetSupportedInputModes();
}

+ (Class)getInputManagerClassForInputMode:(NSString *)inputInternalName
{
	return (Class)UIKeyboardInputManagerClassForInputMode(inputInternalName);
}

+ (BOOL)isLayoutDefaultTypeForInputModeIsASCIICapable:(NSString *)inputInternalName
{
	return UIKeyboardLayoutDefaultTypeForInputModeIsASCIICapable(inputInternalName);
}

+ (BOOL)isInputModeUsesKBStar:(NSString *)inputInternalName
{
	return UIKeyboardInputModeUsesKBStar(inputInternalName);
}

#endif

@end
