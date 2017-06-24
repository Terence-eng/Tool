//
//  UIImage+Tool.m
//  ToolProject
//
//  Created by 陈伟鑫 on 2017/6/24.
//  Copyright © 2017年 陈伟鑫. All rights reserved.
//

#import "UIImage+Tool.h"

@implementation UIImage (Tool)
static CGColorSpaceRef __rgbColorSpace = NULL;
CGColorSpaceRef CWXGetRGBColorSpace(void)
{
    if (!__rgbColorSpace)
    {
        __rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    }
    return __rgbColorSpace;
}
BOOL CWXImageHasAlpha(CGImageRef imageRef)
{
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(imageRef);
    BOOL hasAlpha = (alpha == kCGImageAlphaFirst || alpha == kCGImageAlphaLast || alpha == kCGImageAlphaPremultipliedFirst || alpha == kCGImageAlphaPremultipliedLast);
    
    return hasAlpha;
}
CGContextRef NYXCreateARGBBitmapContext(const size_t width, const size_t height, const size_t bytesPerRow, BOOL withAlpha)
{
    /// Use the generic RGB color space
    /// We avoid the NULL check because CGColorSpaceRelease() NULL check the value anyway, and worst case scenario = fail to create context
    /// Create the bitmap context, we want pre-multiplied ARGB, 8-bits per component
    /// 当图片不包含 alpha 的时候使用 kCGImageAlphaNoneSkipFirst ，否则使用 kCGImageAlphaPremultipliedFirst
    CGImageAlphaInfo alphaInfo = (withAlpha ? kCGImageAlphaPremultipliedFirst : kCGImageAlphaNoneSkipFirst);
    /// NULL由bitmap分配内存
    CGContextRef bmContext = CGBitmapContextCreate(NULL, width, height, 8/*Bits per component*/, bytesPerRow, CWXGetRGBColorSpace(), kCGBitmapByteOrderDefault | alphaInfo);
    
    return bmContext;
}
- (UIImage*)scaleToSize:(CGSize)newSize
             usingMode:(CWXResizeMode)resizeMode {
    switch (resizeMode)
    {
        case CWXResizeModeAspectFit:
            return [self scaleToFitSize:newSize];
        case CWXResizeModeAspectFill:
            return [self scaleToCoverSize:newSize];
        default:
            return [self scaleToFillSize:newSize];
    }
}

- (UIImage*)scaleToFitSize:(CGSize)newSize
{
    /// Keep aspect ratio
    size_t destWidth, destHeight;
    if (self.size.width > self.size.height)
    {
        destWidth = (size_t)newSize.width;
        destHeight = (size_t)(self.size.height * newSize.width / self.size.width);
    }
    else
    {
        destHeight = (size_t)newSize.height;
        destWidth = (size_t)(self.size.width * newSize.height / self.size.height);
    }
    if (destWidth > newSize.width)
    {
        destWidth = (size_t)newSize.width;
        destHeight = (size_t)(self.size.height * newSize.width / self.size.width);
    }
    if (destHeight > newSize.height)
    {
        destHeight = (size_t)newSize.height;
        destWidth = (size_t)(self.size.width * newSize.height / self.size.height);
    }
    return [self scaleToFillSize:CGSizeMake(destWidth, destHeight)];
}
- (UIImage*)scaleToFillSize:(CGSize)newSize
{
    size_t destWidth = (size_t)(newSize.width * self.scale);
    size_t destHeight = (size_t)(newSize.height * self.scale);
    if (self.imageOrientation == UIImageOrientationLeft
        || self.imageOrientation == UIImageOrientationLeftMirrored
        || self.imageOrientation == UIImageOrientationRight
        || self.imageOrientation == UIImageOrientationRightMirrored)
    {
        size_t temp = destWidth;
        destWidth = destHeight;
        destHeight = temp;
    }
    
    /// Create an ARGB bitmap context
    // NYXImageHasAlpha 返回一个bool值，判断图片是否包含alpha通道
    CGContextRef bmContext = NYXCreateARGBBitmapContext(destWidth, destHeight, destWidth * 4, CWXImageHasAlpha(self.CGImage));
    if (!bmContext)
        return nil;
    
    /// Image quality 图片质量
    /// CGContextSetShouldAntialias
    CGContextSetShouldAntialias(bmContext, true);
    CGContextSetAllowsAntialiasing(bmContext, true);
    CGContextSetInterpolationQuality(bmContext, kCGInterpolationHigh);
    
    /// Draw the image in the bitmap context
    /// 在位图上下文中绘制图像
    UIGraphicsPushContext(bmContext);
    CGContextDrawImage(bmContext, CGRectMake(0.0f, 0.0f, destWidth, destHeight), self.CGImage);
    UIGraphicsPopContext();
    
    /// Create an image object from the context
    CGImageRef scaledImageRef = CGBitmapContextCreateImage(bmContext);
    UIImage* scaled = [UIImage imageWithCGImage:scaledImageRef scale:self.scale orientation:self.imageOrientation];
    
    /// Cleanup
    CGImageRelease(scaledImageRef);
    CGContextRelease(bmContext);
    
    return scaled;
}
-(UIImage*)scaleToCoverSize:(CGSize)newSize
{
    size_t destWidth, destHeight;
    CGFloat widthRatio = newSize.width / self.size.width;
    CGFloat heightRatio = newSize.height / self.size.height;
    /// Keep aspect ratio
    if (heightRatio > widthRatio)
    {
        destHeight = (size_t)newSize.height;
        destWidth = (size_t)(self.size.width * newSize.height / self.size.height);
    }
    else
    {
        destWidth = (size_t)newSize.width;
        destHeight = (size_t)(self.size.height * newSize.width / self.size.width);
    }
    return [self scaleToFillSize:CGSizeMake(destWidth, destHeight)];
}

@end
