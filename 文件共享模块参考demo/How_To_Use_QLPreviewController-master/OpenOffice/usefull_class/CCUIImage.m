//
//  CCUIImage.m
//  CCFC
//
//  Created by xichen on 11-12-24.
//  Copyright 2011 ccteam. All rights reserved.
//



@implementation UIImage(cc)

// returns the scaled image
- (UIImage *)scale:(float)scaleSize
{
	
	UIGraphicsBeginImageContext(
			CGSizeMake(self.size.width * scaleSize, self.size.height * scaleSize));
	[self drawInRect:CGRectMake(0, 0, self.size.width * scaleSize, self.size.height * scaleSize)];
	UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
								
	return scaledImage;
}

// resize the img to indicated newSize
- (UIImage *)resizeImage:(CGSize)newSize
{
	UIGraphicsBeginImageContext(CGSizeMake(newSize.width, newSize.height));
	[self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
	UIImage *resizeImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();

	return resizeImage;
	
}
 
// save PNG file to path
- (BOOL)savePNGToPath:(NSString *)fileFullPath
{
	return [UIImagePNGRepresentation(self) writeToFile:fileFullPath atomically:YES];
}

// save the img to photos album
- (void)saveImgToPhotosAlbum
{
	UIImageWriteToSavedPhotosAlbum(self, nil, nil, nil);
}

// get part of the image
- (UIImage *)getPartOfImage:(CGRect)partRect
{
	CGImageRef imageRef = self.CGImage;
	CGImageRef imagePartRef = CGImageCreateWithImageInRect(imageRef, partRect);
	return [UIImage imageWithCGImage:imagePartRef];
}

// returns UIImage * from text
+ (UIImage *)imageFromText:(NSString *)text font:(UIFont *)font
{            
	CGSize size  = [text sizeWithFont:font];     
	UIGraphicsBeginImageContext(size);  
	
	CGContextRef ctx = UIGraphicsGetCurrentContext();       
	[text drawAtPoint:CGPointMake(0, 0) withFont:font];      
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();          
	UIGraphicsEndImageContext(); 
	CGContextRelease(ctx);
	
	return image;  
} 

#if CC_ENABLE_PRIVATE_API && CC_COMPILE_PRIVATE_CLASS
+ (UIImage *)getFullScreenImg
{
	CGImageRef screenImg = UIGetScreenImage();
	return [UIImage imageWithCGImage:screenImg];
}
#endif

@end
