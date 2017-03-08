//
//  CCPhoto.h
//  CCFC
//
//  Created by xichen on 11-12-16.
//  Copyright 2011年 ccteam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIImagePickerController.h>


@interface CCPhoto : NSObject 
{
    
}

// 调用系统照片库
+ (UIImagePickerController *)showImagePickerView:(id)delegate
                                         imgType:(UIImagePickerControllerSourceType)imgType
                                        animated:(BOOL)animated;

// 将view视图保存到照片库中
+ (void)saveViewToPhotosAlbum:(UIView *)view;
 
@end
