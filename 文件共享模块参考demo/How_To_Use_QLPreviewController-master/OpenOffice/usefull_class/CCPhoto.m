//
//  CCPhoto.m
//  CCFC
//
//  Created by xichen on 11-12-16.
//  Copyright 2011年 ccteam. All rights reserved.
//

#import "CCPhoto.h"
#import <QuartzCore/QuartzCore.h>

@implementation CCPhoto


// 调用系统照片库
+ (UIImagePickerController *)showImagePickerView:(id)delegate
                                         imgType:(UIImagePickerControllerSourceType)imgType
                                        animated:(BOOL)animated
{
	UIImagePickerController *imgPickerView = [UIImagePickerController new];
	if(!imgPickerView)
	{
		return nil;
	}
	imgPickerView.delegate = delegate;
	imgPickerView.sourceType = imgType;
	
	[delegate presentModalViewController:imgPickerView animated:animated];
	[imgPickerView release];
	
	return imgPickerView;
}

// 将view视图保存到照片库中
+ (void)saveViewToPhotosAlbum:(UIView *)view
{
	UIGraphicsBeginImageContext(view.layer.bounds.size);
	[view.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *viewImg = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	UIImageWriteToSavedPhotosAlbum(viewImg, nil, nil, nil);
} 

@end
