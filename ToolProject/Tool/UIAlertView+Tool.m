//
//  UIAlertView+Tool.m
//  ToolProject
//
//  Created by 陈伟鑫 on 2017/6/23.
//  Copyright © 2017年 陈伟鑫. All rights reserved.
//

#import "UIAlertView+Tool.h"
#import <objc/runtime.h>
#import <objc/message.h>

typedef void (^ClickBlock)(NSInteger buttonIndex);

static const NSString *WX_AlertViewKey = @"WX_AlertViewKey";

@interface UIAlertView()<UIAlertViewDelegate>
@property (nonatomic, copy) ClickBlock clickBlock;

@end


@implementation UIAlertView (Tool)

- (void)setClickBlock:(void (^)(NSInteger))clickBlock {
    objc_setAssociatedObject(self, &WX_AlertViewKey, clickBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (ClickBlock)clickBlock {
    return objc_getAssociatedObject(self, &WX_AlertViewKey);
}

+ (void)initTitle:(NSString *)title
          message:(NSString *)message
        cancelBtn:(NSString *)cancelBtn
 otherButtonArray:(NSArray *)otherButtons
     clickAtIndex:(void(^)(NSInteger buttonIndex))clickBlock {
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:cancelBtn otherButtonTitles:nil, nil];
    for (NSString *otherTitle in otherButtons) {
        [alert addButtonWithTitle:otherTitle];
    }
    alert.clickBlock = clickBlock;
    [alert show];
}

+ (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.clickBlock) {
        alertView.clickBlock(buttonIndex);
    }
}
+ (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.clickBlock) {
        alertView.clickBlock = nil;
    }
}
@end
