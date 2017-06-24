//
//  WXImagePickerVCTool.h
//  ToolProject
//
//  Created by 陈伟鑫 on 2017/6/24.
//  Copyright © 2017年 陈伟鑫. All rights reserved.
//

#import <UIKit/UIKit.h>



//相机选择方式，1是从照相机，2是从图库
typedef NS_ENUM(NSUInteger, WXImagePickerVCStyle){
    magePickerStyleCamera = 1,
    ImagePickerStylePhotoLibrary
};
@interface WXImagePickerVCTool : UIImagePickerController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>



/**
 自定义初始化方法

 @param style 相机选择方式
 @param editing 图片是否允许编辑
 @param block 图片回调
 @return self
 */
- (instancetype)initImagePickerStyle:(WXImagePickerVCStyle)style
                       allowsEditing:(BOOL)editing
                           imageSize:(CGSize)imageSize
                    SelectImageBlock:(void(^)(UIImage *image))block;


/**
 图片保存到沙盒
*/
@property (nonatomic, copy) NSString *fileName;



/**
 从沙盒中获取图片

 @param fileName 图片名称
 @param size 设置图片大小
 @param block 因为是异步的，所以用block回调
 */
- (void)loadImageFromSandBoxWithFileName:(NSString *)fileName
                               imageSize:(CGSize )size
                              imageBlock:(void(^)(UIImage *image))block;

@end
