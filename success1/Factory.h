//
//  Factory.h
//  success1
//
//  Created by Inuyasha on 15/10/2019.
//  Copyright © 2019 Inuyasha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SiteModel.h"

NS_ASSUME_NONNULL_BEGIN


typedef void(^SuccessModelBlock)(SiteModel *model);
/**回调数据的block*/
typedef void(^HandleIndexBlock)(NSInteger *index);

@interface Factory : NSObject

// 为tabBar添加子视图
+(void)addChild:(NSString *)vc withTitle:(NSString *)title normal:(NSString *)normal selected:(NSString *)selected to:(UITabBarController *)tabCtrl withBGColor:(UIColor *)color;


//刷新数据
+(void)loadDataToCollectionView:(UICollectionView *)collectionView;

//创建区域地点模型
+(void)createAreaModelWithBlock:(SuccessModelBlock)success;

//获取视频第一帧
+(UIImage *)thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time;

//播放视频。可本地 可在线
+(void)playVideoWithURL:(NSURL *)url onController:(UIViewController *)vc;

//计算视频时长
+ (NSString *)getVideoTimeByUrl:(NSURL*) url;

//推送界面
+(void)pushToViewController:(UIViewController *)controller;

//回退界面
+(void)popToRootViewControllerFrom:(UIViewController*)controller ;

@end

NS_ASSUME_NONNULL_END
