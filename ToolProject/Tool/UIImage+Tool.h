//
//  UIImage+Tool.h
//  ToolProject
//
//  Created by 陈伟鑫 on 2017/6/24.
//  Copyright © 2017年 陈伟鑫. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum
{
    CWXResizeModeScaleToFill, // 改变内容的高宽比例，缩放内容,UIView中完整显示内容，填满UIView
    CWXResizeModeAspectFit,  // 保持内容的高宽比，缩放内容，完整显示内容，最大化填充UIview，没填充上的区域透明
    CWXResizeModeAspectFill  //保持内容高宽比，缩放内容，超出视图的部分内容会被裁减，填充UIView
} CWXResizeMode;

@interface UIImage (Tool)
-(UIImage*)scaleToSize:(CGSize)newSize
             usingMode:(CWXResizeMode)resizeMode;
@end
