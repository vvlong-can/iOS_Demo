//
//  QLviewDemo.h
//  OpenOffice
//
//  Created by willonboy zhang on 12-6-20.
//  Copyright (c) 2012年 willonboy.tk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuickLook/QuickLook.h>
#import "QLViewController.h"


@interface QLviewDemo : UIViewController<QLPreviewControllerDataSource, QLPreviewControllerDelegate, QLViewControllerDelegate>
{
    UIWebView *webView;
    
    NSStringEncoding    _stringEncoding;
}
@property(nonatomic, retain) IBOutlet UIButton *btn;

- (IBAction)handleBtnClicked:(id) sender;


@end
