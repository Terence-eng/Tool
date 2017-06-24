//
//  ToolNSObject.h
//  ToolProject
//
//  Created by 陈伟鑫 on 2017/6/23.
//  Copyright © 2017年 陈伟鑫. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToolNSObject : NSObject
/**
 *                               UIAlertView类方法
 *   @param  title               标题
 *   @param  message             消息
 *   @param  cancleButtonTitle   取消按钮
 *   @param  otherButtons        其他按钮,传入的是一个按钮
 *   @param  clickBlock        点击回调的block
 */

+ (void)initTitle:(NSString *)title
          message:(NSString *)message
cancelButtonTitle:(NSString *)cancleButtonTitle
 otherButtonArray:(NSArray *)otherButtons
     clickAtIndex:(void(^)(NSInteger buttonIndex)) clickBlock;
@end
