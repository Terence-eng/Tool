//
//  WXImagePickerVCTool.m
//  ToolProject
//
//  Created by 陈伟鑫 on 2017/6/24.
//  Copyright © 2017年 陈伟鑫. All rights reserved.
//

#import "WXImagePickerVCTool.h"
#import "UIImage+Tool.h"
@interface WXImagePickerVCTool ()
{
    void (^_SelectImageBlock)(UIImage *image);
    NSString *_fileName;
}
@end

@implementation WXImagePickerVCTool

- (instancetype)initImagePickerStyle:(WXImagePickerVCStyle)style
                       allowsEditing:(BOOL)editing
                    SelectImageBlock:(void(^)(UIImage *image))block {
    self = [super init];
    if (self) {
        _SelectImageBlock = block;
        if (style == ImagePickerStylePhotoLibrary) {
            self.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        else if (style == magePickerStyleCamera) {
            self.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
        
        self.allowsEditing = editing;
        self.delegate = self;
    }
    return self;
}

- (void)setFileName:(NSString *)fileName {
    _fileName = [fileName copy];
}

#pragma mark -- UIImagePickerControllerDelegate,选取照片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image;
    if (self.allowsEditing) {
        image = [info objectForKey:UIImagePickerControllerEditedImage];
    }
    else {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    if (_fileName) {
        // 存储到沙盒中
        [self saveImageToSandbox:image PathName:_fileName];
    }
    _SelectImageBlock(image);
//    
//    BOOL success = [self saveImageToSandbox:image PathName:self.fileName];
//    
//    UIImage * editImage = [self scaledToSizeWithImage:image];
//    
//    if (success) {
//        _selectImageBlock(editImage);
//    }
//    else {
//        _selectImageBlock(nil);
//    }
//    
}

#pragma mark -- 将图片存储到沙盒中
- (BOOL)saveImageToSandbox:(UIImage *)image PathName:(NSString *)fileName {
    NSData *data;
    if (UIImagePNGRepresentation(image) == nil) {
        data = UIImageJPEGRepresentation(image, 1.0);
    }
    else {
        data = UIImagePNGRepresentation(image);
    }
    BOOL result = [self SaveData:data PathName:fileName];
    return result;
}
- (BOOL)SaveData:(NSData *)data PathName:(NSString *)fileName {
    //将图片写入文件
    NSString *filePath = [self filePath:fileName];
    //是否保存成功
    BOOL result = [data writeToFile:filePath atomically:YES];
    return result;
}

#pragma mark----获取沙盒路径
- (NSString *)filePath:(NSString *)fileName
{
        //获取沙盒目录
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //在Documents目录下创建WEIXIN目录
    NSString *directryPath = [paths[0] stringByAppendingPathComponent:@"WEIXIN"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:directryPath]) {
         [fileManager createDirectoryAtPath:directryPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    // 在WEIXIN目录下的filename中写入文件
    directryPath = [directryPath stringByAppendingPathComponent:fileName];
    return directryPath;
}

#pragma mark -- 从沙盒中获取图片
- (void)loadImageFromSandBoxWithFileName:(NSString *)fileName
                               imageSize:(CGSize )size
                              imageBlock:(void(^)(UIImage *image))block {
    NSString *filePath = [self filePath:fileName];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage *image = [UIImage imageWithContentsOfFile:filePath];
        if (image) {
            image = [image scaleToSize:size usingMode:CWXResizeModeAspectFit];
            dispatch_async(dispatch_get_main_queue(), ^{
                block(image);
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                block(nil);
            });
        }
    });
}
@end

