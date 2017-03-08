//
//  QLviewDemo.m
//  OpenOffice
//
//  Created by willonboy zhang on 12-6-20.
//  Copyright (c) 2012年 willonboy.tk. All rights reserved.
//

#import "QLviewDemo.h"

@implementation QLviewDemo
@synthesize btn;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        _stringEncoding = 0;
    }
    return self;
}

- (void)dealloc 
{
    [webView release];
    [super dealloc];
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"box.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20]];
    imgView.frame = CGRectMake(10, 10, 300, 440);
    [self.view insertSubview:imgView atIndex:0];
    [imgView release];
    
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(40, 185, 240, 245)];
    [self.view addSubview:webView];
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"note" ofType:@"doc"]]]];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}


- (IBAction)handleBtnClicked:(id)sender
{
    QLViewController *ql = [[QLViewController alloc] init];
    if (((int)rand()) % 2)
    {
        NSLog(@"rand() mod 2 == 1");
        ql.qlFileUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"note" ofType:@"doc"]];
    }
    else
    {
        NSLog(@"rand() mod 2 == 0");
        ql.qlViewControllerDelegate = self;
        ql.dataSource = self;
    }
        //如果已经存在正在浏览的外部文件
    if (self.modalViewController)
    {
        [self dismissModalViewControllerAnimated:NO];
    }
    [self presentModalViewController:ql animated:YES];
    [ql release];
}



- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller;
{
    return 1;
}

- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index;
{
    NSURL   *originalFileUrl    = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"note" ofType:@"doc"]];
    NSString    *fileExt        = [originalFileUrl pathExtension];
    
        //如果txt文件
    if (fileExt && [[fileExt lowercaseString] isEqualToString:@"txt"]) 
    {
        NSError *err        = nil;
        NSData  *fileData   = nil;
        NSFileManager *fm   = [NSFileManager defaultManager];
        NSString    *tmpFilePath    = [NSString stringWithFormat:@"%@/tmp/%@", NSHomeDirectory(), [originalFileUrl lastPathComponent]];
        NSLog(@"tmpFilePath--------%@",tmpFilePath);
        NSURL       *tmpFileUrl     = [NSURL fileURLWithPath:tmpFilePath];
        NSString    *originalFilePath  = [originalFileUrl path];
        ((QLViewController *)controller).isTextFile = YES;
        NSStringEncoding encode;
        NSString *contentStr = nil;
        
        if (!_stringEncoding) 
        {
                //如果有文件副本则直接返回副本文件(因为可能已经正确转码过了)
            if([fm fileExistsAtPath:tmpFilePath]) 
            {
                return tmpFileUrl;
            }
                //下面方法获取指定文件的字符编码集  如果返回值为nil 那么err就会带回返回值, 可能的错误是文件系统错误或是字符编码错误
            contentStr = [NSString stringWithContentsOfFile:originalFilePath usedEncoding:&encode error:&err];
            NSLog(@"原文件编码:  %d", encode);
            NSLog(@"原文件内容:  %@", contentStr);
        }
        else
        {
            contentStr = [NSString stringWithContentsOfFile:originalFilePath encoding:_stringEncoding error:&err];
            
            if (contentStr) 
            {
                    //转码为UTF-16编码
                fileData = [contentStr dataUsingEncoding:NSUTF16StringEncoding];
                    //删除旧的副本文件
                if([fm fileExistsAtPath:tmpFilePath]) 
                {
                    [fm removeItemAtPath:tmpFilePath error:nil];
                }
                    //创建原文件副本
                [fileData writeToFile:tmpFilePath atomically:YES];
                    //txt文件返回原文件副本文件URL
                return tmpFileUrl;
            }
            else
            {
                return nil;
            }
        }
    }
        //非txt文件直接返回原文件URL
    return originalFileUrl;
}

- (void)choiceCFStringEncoding:(QLPreviewController *)controller stringEncoding:(CFStringEncodings) encoding;
{
    _stringEncoding = CFStringConvertEncodingToNSStringEncoding(encoding);
        //重新读取原文件副本文件(即tmp文件)
    [controller reloadData];
}


@end












