//
//  CCUIImage.h
//  CCFC_IPHONE
//
//  Created by  xuchen(陈旭)， xichen(陈曦)， qq：511272827 on 10-10-31.
//  Copyright 2010 cc_team. All rights reserved.
//

#ifndef	CC_UI_IMAGE_H
#define	CC_UI_IMAGE_H


#ifdef __OBJC__

#import "CCConfig.h"

#define	CREATE_UIIMAGE(imgPath)		[UIImage imageNamed:(imgPath)]
#define	CREATE_UIIMAGEVIEW(imgPath)	[[[UIImageView alloc] initWithImage:CREATE_UIIMAGE(imgPath)] autorelease]

#define	MACRO_DEFAULT_NAVIGATION_BARBUTTON_ITEM_ICON_WIDTH		20
#define	MACRO_DEFAULT_NAVIGATION_BARBUTTON_ITEM_ICON_HEIGHT		20
 
#if CC_ENABLE_PRIVATE_API && CC_COMPILE_PRIVATE_CLASS
#ifdef	__cplusplus
extern "C" {
#endif
	
 CGImageRef UIGetScreenImage();
	
#ifdef	__cplusplus
}
#endif
#endif

@interface UIImage(cc)

// returns the scaled image
- (UIImage *)scale:(float)scaleSize;

// resize the img to indicated newSize
- (UIImage *)resizeImage:(CGSize)newSize;

// save PNG file to path
- (BOOL)savePNGToPath:(NSString *)fileFullPath;

// save the img to photos album
- (void)saveImgToPhotosAlbum;

// get part of the image
- (UIImage *)getPartOfImage:(CGRect)partRect;

// returns UIImage * from text
+ (UIImage *)imageFromText:(NSString *)text font:(UIFont *)font;


#if CC_ENABLE_PRIVATE_API && CC_COMPILE_PRIVATE_CLASS
+ (UIImage *)getFullScreenImg;
#endif

@end


#endif	// __OBJC__
#endif	// CC_UI_IMAGE_H
