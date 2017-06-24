//
//  UIActionSheet+Tool.h
//  ToolProject
//
//  Created by 陈伟鑫 on 2017/6/24.
//  Copyright © 2017年 陈伟鑫. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIActionSheet (Tool)
/**
 *                                     UIActionSheet类方法
 *   @param  title                     标题
 *   @param  cancleButtonTitle         取消按钮
 *   @param  destructiveButtonTitle    红色按钮
 *   @param  otherButtons              其他按钮
 *   @param  clickAtIndex              点击回调的block
    可以在block中使用self。不会发生循环引用。防止内存泄漏
 */
+ (void)initActionSheetTitle:(NSString *)title
           cancelButtonTitle:(NSString *)cancleButtonTitle
      destructiveButtonTitle:(NSString *)destructiveButtonTitle
           otherButtonTitles:(NSArray *)otherButtons
                clickAtIndex:(void(^)(NSInteger buttonIndex)) clickAtIndex;
@end
