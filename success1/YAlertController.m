//
//  PXDAlertController.m
//  0414-PrivateAlbum
//
//  Created by 彭孝东 on 2019/4/22.
//  Copyright © 2019 彭孝东. All rights reserved.
//

#import "YAlertController.h"

@interface YAlertController ()
/** 确认按钮被点击 回调的block */
@property (nonatomic, copy) SureBlock block;
/** 表单上的相册和相机被点击 回调的block */
@property (nonatomic, copy) ActionBlock actionBlock;
@end

@implementation YAlertController

+ (void)showAlertControllerWithType:(AlertType)type alert:(NSString *)alert sure:(SureBlock)block{
    NSString *message = alert;
    if (type == AlertTypeAlert) {
        message = alert;
    }
    //弹出一个提示框 提示用户输入相册名
    YAlertController *alertCtrl = [YAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    //保存block
    alertCtrl.block = block;
    
    //添加相册的时候才需要输入框
    if (type == AlertTypeAddSite) {
        [alertCtrl addTextFieldWithConfigurationHandler:nil];
        
        //添加取消
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"操作取消");
        }];
        [alertCtrl addAction:cancel];
    }
    
    //添加确认
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (alertCtrl.block){
            alertCtrl.block(alertCtrl.textFields.firstObject.text);
        }
    }];
    [alertCtrl addAction:sure];
    
    //显示
    //找到当前界面的视图
    //1.通过窗口找到当前的界面
    UINavigationController *nav =  [((UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController).viewControllers objectAtIndex:((UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController).selectedIndex];
    //找到导航栏控制器当前显示的界面
    UIViewController *mainVC = nav.visibleViewController;
    
    [mainVC presentViewController:alertCtrl animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

//显示表单
+ (void)showActionSheet:(ActionBlock)actionBlock{
    YAlertController *alertCtrl = [YAlertController alertControllerWithTitle:@"选择图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    alertCtrl.actionBlock = actionBlock;
    
    //系统相册
    UIAlertAction *library = [UIAlertAction actionWithTitle:@"系统相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (alertCtrl.actionBlock) {
            alertCtrl.actionBlock(ActionTypeLibrary);
        }
    }];
    //相机
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (alertCtrl.actionBlock) {
            alertCtrl.actionBlock(ActionTypeCamera);
        }
    }];
    //取消
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertCtrl addAction:library];
    [alertCtrl addAction:camera];
    [alertCtrl addAction:cancel];
    
    //1.通过窗口找到当前的界面
    UINavigationController *nav =  [((UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController).viewControllers objectAtIndex:((UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController).selectedIndex];
    //找到导航栏控制器当前显示的界面
    UIViewController *mainVC = nav.visibleViewController;
    
    [mainVC presentViewController:alertCtrl animated:YES completion:nil];
}
@end
