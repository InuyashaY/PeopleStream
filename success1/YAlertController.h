//
//  PXDAlertController.h
//  0414-PrivateAlbum
//
//  Created by 彭孝东 on 2019/4/22.
//  Copyright © 2019 彭孝东. All rights reserved.
//

#import <UIKit/UIKit.h>


//响应确认按钮被点击的block
typedef void(^SureBlock)(NSString *input);
typedef void(^ActionBlock)(ActionType type);



NS_ASSUME_NONNULL_BEGIN

@interface YAlertController : UIAlertController

//提示框 输入相册名
+ (void)showAlertControllerWithType:(AlertType)type alert:(NSString *)alert sure:(SureBlock)block;

//显示表单
+ (void)showActionSheet:(ActionBlock)actionBlock;
@end

NS_ASSUME_NONNULL_END
