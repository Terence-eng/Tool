//
//  ToolNSObject.m
//  ToolProject
//
//  Created by 陈伟鑫 on 2017/6/23.
//  Copyright © 2017年 陈伟鑫. All rights reserved.
//

#import "ToolNSObject.h"
#import <UIKit/UIKit.h>
typedef void (^ClickAtIndexBlock)(NSInteger buttonIndex);
static ClickAtIndexBlock _ClickAtIndexBlock;
@implementation ToolNSObject
+ (void)initTitle:(NSString *)title
          message:(NSString *)message
cancelButtonTitle:(NSString *)cancleButtonTitle
 otherButtonArray:(NSArray *)otherButtons
     clickAtIndex:(void(^)(NSInteger buttonIndex)) clickBlock{
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:cancleButtonTitle otherButtonTitles:nil, nil];
    for (NSString *otherTitle in otherButtons) {
        [alert addButtonWithTitle:otherTitle];
    }
    _ClickAtIndexBlock = clickBlock;
    [alert show];
}

#pragma mark -- UIAlertViewDelegate
+ (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (_ClickAtIndexBlock) {
        _ClickAtIndexBlock(buttonIndex);
    }
}
@end
