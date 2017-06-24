//
//  UIActionSheet+Tool.m
//  ToolProject
//
//  Created by 陈伟鑫 on 2017/6/24.
//  Copyright © 2017年 陈伟鑫. All rights reserved.
//

#import "UIActionSheet+Tool.h"
#import <objc/runtime.h>
#import <objc/message.h>
typedef void (^ClickBlock)(NSInteger buttonIndex);

static const NSString *WX_AlertSheetKey = @"WX_AlertSheetKey";

@interface UIActionSheet ()<UIActionSheetDelegate>
@property (nonatomic, copy) ClickBlock clickBlock;
@end
@implementation UIActionSheet (Tool)

- (void)setClickBlock:(void (^)(NSInteger))clickBlock {
    objc_setAssociatedObject(self, &WX_AlertSheetKey, clickBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (ClickBlock)clickBlock {
    return objc_getAssociatedObject(self, &WX_AlertSheetKey);
}

+ (void)initActionSheetTitle:(NSString *)title
           cancelButtonTitle:(NSString *)cancleButtonTitle
      destructiveButtonTitle:(NSString *)destructiveButtonTitle
           otherButtonTitles:(NSArray *)otherButtons
                clickAtIndex:(void(^)(NSInteger buttonIndex))clickAtIndex {
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:title delegate:(id<UIActionSheetDelegate>)self cancelButtonTitle:cancleButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitles: nil];
    for (NSString *otherTitle in otherButtons) {
        [sheet addButtonWithTitle:otherTitle];
    }
    sheet.clickBlock = clickAtIndex;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [sheet showInView:window];
}

#pragma mark -- UIActionViewDelegate
+ (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.clickBlock) {
        actionSheet.clickBlock(buttonIndex);
    }
}

+ (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonInde{
    if (actionSheet.clickBlock) {
        actionSheet.clickBlock = nil;
    }
}
@end
