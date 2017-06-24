//
//  UIAlertView+Tool.h
//  ToolProject
//
//  Created by 陈伟鑫 on 2017/6/23.
//  Copyright © 2017年 陈伟鑫. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (Tool)

/**
 UIAlertView 自定义初始化方法,block回调

 @param title 标题
 @param message 消息
 @param cancelBtn 取消按钮
 @param otherButtons 其他按钮，传入数组
 @param clickBlock 点击回调的block
 
 可以在block中使用self。不会发生循环引用。防止内存泄漏
 */
+ (void)initTitle:(NSString *)title
          message:(NSString *)message
        cancelBtn:(NSString *)cancelBtn
 otherButtonArray:(NSArray *)otherButtons
     clickAtIndex:(void(^)(NSInteger buttonIndex))clickBlock;
@end
