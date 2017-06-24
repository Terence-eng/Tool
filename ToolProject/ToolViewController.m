//
//  ToolViewController.m
//  ToolProject
//
//  Created by 陈伟鑫 on 2017/6/23.
//  Copyright © 2017年 陈伟鑫. All rights reserved.
//

#import "ToolViewController.h"
#import "UIAlertView+Tool.h"
#import "ToolNSObject.h"
#import "UIActionSheet+Tool.h"
#import "WXImagePickerVCTool.h"
@interface ToolViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (nonatomic, strong) NSString *name;
@end

@implementation ToolViewController

- (void)viewDidLoad {
    self.name =  @"aha";
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)ActionSheetAction:(id)sender {
    [UIActionSheet initActionSheetTitle:@"UIActionSheet" cancelButtonTitle:@"取消" destructiveButtonTitle:@"红色" otherButtonTitles:@[@"1",@"2"] clickAtIndex:^(NSInteger buttonIndex) {
        NSLog(@"%@",@(buttonIndex));
        NSLog(@"%@",self.name);
       
    }];
}
- (IBAction)AlertViewAction:(id)sender {
    
    [UIAlertView initTitle:@"测试" message:@"测试" cancelBtn:nil otherButtonArray:@[@"左边",@"右边"] clickAtIndex:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            NSLog(@"左边");
        }
        else if (buttonIndex == 1) {
            NSLog(@"右边");
        }
        NSLog(@"%@",self.name);
    }];
}

// 选择头像
- (IBAction)selectIconAction:(id)sender {
    [UIActionSheet initActionSheetTitle:@"选择头像" cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"从相册选择",@"拍照"] clickAtIndex:^(NSInteger buttonIndex) {
        WXImagePickerVCStyle style = 0;
        BOOL editing = NO;
        if (buttonIndex == 1) {
            //相册
            style = ImagePickerStylePhotoLibrary;
            editing = YES;
        }
        else if (buttonIndex == 2) {
            //拍照
            style = magePickerStyleCamera;
            editing = NO;
        }
        else {
            return ;
        }
        WXImagePickerVCTool *imageTool = [[WXImagePickerVCTool alloc]initImagePickerStyle:style allowsEditing:editing SelectImageBlock:^(UIImage *image) {
            self.userIcon.image = image;
        }];
        imageTool.fileName = @"weixin";
        [self presentViewController:imageTool animated:YES completion:^{
            
        }];
    }];
}

- (IBAction)dismissAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


- (void)dealloc {
    NSLog(@"%@",self);
}
@end
