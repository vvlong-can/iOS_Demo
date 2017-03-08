//
//  CCKeyboard.h
//  CCFC
//
//  Created by xichen on 11-12-23.
//  Copyright 2011 ccteam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCCommon.h"
#import "CCConfig.h"
#import "CCDepend.h"

#if CC_ENABLE_PRIVATE_API
// the extern func prototype which are defined in UIKit
CC_EXTERN NSString *UIKeyboardGetCurrentInputMode() _Depended_On_UIKit_;
CC_EXTERN NSString *UIKeyboardLocalizedInputModeName(NSString *name) _Depended_On_UIKit_;
CC_EXTERN NSBundle *UIKeyboardBundleForInputMode(NSString *name) _Depended_On_UIKit_;
CC_EXTERN NSArray  *UIKeyboardGetSupportedInputModes() _Depended_On_UIKit_;
CC_EXTERN Class	   UIKeyboardInputManagerClassForInputMode(NSString *name) _Depended_On_UIKit_;
CC_EXTERN BOOL	   UIKeyboardLayoutDefaultTypeForInputModeIsASCIICapable(NSString *name) _Depended_On_UIKit_;
CC_EXTERN BOOL	   UIKeyboardInputModeUsesKBStar(NSString *name) _Depended_On_UIKit_;
#endif

#define	NOTIFICATION_KEYBOARD_WILL_SHOW		UIKeyboardWillShowNotification
#define	NOTIFICATION_KEYBOARD_WILL_HIDE		UIKeyboardWillHideNotification

@interface CCKeyboard : NSObject 
{

}

+ (UITextInputMode *)currentInputMode __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_4_2);
+ (NSString *)primaryLanguage __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_4_2);

+ (CGRect)defaultPortraitKeyboardRect;

+ (UIWindow *)getKeyboardWindow;
 

// get the view of the keyboard
+ (UIView *)getKeyboardView;
// get the name of the keyboard
+ (NSString *)getKeyboardViewName;

#if	CC_ENABLE_PRIVATE_API
+ (NSString *)getCurrentInputMode;
+ (NSString *)getLocalizedInputModeName:(NSString *)inputInternalName;
+ (NSBundle *)getBundleForInputMode:(NSString *)inputInternalName;
+ (NSArray *)getSupportedInputModes;
+ (Class)getInputManagerClassForInputMode:(NSString *)inputInternalName;
+ (BOOL)isLayoutDefaultTypeForInputModeIsASCIICapable:(NSString *)inputInternalName;
+ (BOOL)isInputModeUsesKBStar:(NSString *)inputInternalName;
#endif

@end
