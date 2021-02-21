//
//  Factory.m
//  success1
//
//  Created by Inuyasha on 15/10/2019.
//  Copyright © 2019 Inuyasha. All rights reserved.
//

#import "Factory.h"
#import <MJExtension/MJExtension.h>
#import "SiteModel.h"
#import "YAlertController.h"
#import "Manager/DataManager.h"
#import "RankView.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import "XLActionViewController.h"


@implementation Factory

+ (void)addChild:(NSString *)vc withTitle:(NSString *)title normal:(NSString *)normal selected:(NSString *)selected to:(UITabBarController *)tabCtrl withBGColor:(UIColor *)color{
    //将字符串转化为对应的类
    UIViewController *hvc = [NSClassFromString(vc) new];
    hvc.view.backgroundColor = color;
    // 在tabbar上添加子视图 关联主页
    hvc.tabBarItem.title = title;
    
    hvc.tabBarItem.image = [[UIImage imageNamed:normal] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];//正常状态的图片
    hvc.tabBarItem.selectedImage = [[UIImage imageNamed:selected] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];//选中状态的图片
    //[hvc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:TABBAR_SELECTED_COLOR,NSFontAttributeName:TABBAR_TITLE_SIZE} forState:UIControlStateSelected];
    [hvc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:TABBAR_NORMAL_COLOR, NSFontAttributeName:TABBAR_TITLE_SIZE} forState:UIControlStateNormal];

    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:hvc];
    nav.navigationBar.topItem.title = title;
    //[nav.navigationBar setTitleTextAttributes:@{NSFontAttributeName:NAVIGATION_TITLE_FONT}];
    nav.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
    //[nav.navigationBar setTitleTextAttributes:@{UIFontDescriptorNameAttribute: NAVIGATION_TITLE_FONT}];
    [[UINavigationBar appearance] setBarTintColor:NAVIGATIONBAR_COLOR];
    [UINavigationBar appearance].translucent = NO;
    
    NSDictionary *dict = [NSDictionary dictionaryWithObject:NAVIGATION_TITLE_FONT forKey:NSFontAttributeName];
    nav.navigationBar.titleTextAttributes = dict;
    
    // 将主页添加到tabBar上
    [tabCtrl addChildViewController:nav];
}



//刷新数据
+(void)loadDataToCollectionView:(UICollectionView *)collectionView{
    
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
        //每隔五秒执行一次
        // GCD定时器
        static dispatch_source_t _timer;
        //设置时间间隔
        NSTimeInterval period = 5.0f;
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0);
        // 事件回调
        dispatch_source_set_event_handler(_timer, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                //加载数据
                [[DataManager sharedManager] loadData];
                //排行榜重载数据 
                if ([collectionView.superview isKindOfClass:[RankView class]]) {
                    ((RankView*)collectionView.superview).sitesArray = [DataManager sharedManager].sitesArray;
                }
                
            });
        });
        // 开启定时器
        dispatch_resume(_timer);
//    });
    
}



//创建区域地点模型
+(void)createAreaModelWithBlock:(SuccessModelBlock)success{
    //创建新地点
    SiteModel *model = [SiteModel new];
    
    
//    [YAlertController showAlertControllerWithType:AlertTypeAddSite alert:@"请输入地点名" sure:^(NSString *input) {
//        //地点
//        model.siteName = input;
//        [YAlertController showAlertControllerWithType:AlertTypeAddSite alert:@"请输入链接地址" sure:^(NSString *input) {
//            //链接
//            model.locateLink = input;
//            success(model);
//        }];
//    }];
//    [[XLActionViewController showAlertControllerWithType:AlertTypeAddSite AndName:@"请输入名字"] setSureblock:^(NSString *albumName) {
//        NSLog(@"sjlvhjbjsr");
//    }];
    
    [[XLActionViewController showAlertControllerWithType:AlertTypeAddSite AndName:@"请输入地点名"] setSureblock:^(NSString *text) {
        //地点名
        model.siteName = text;
        [[XLActionViewController showAlertControllerWithType:AlertTypeAddSite AndName:@"请输入链接地址"] setSureblock:^(NSString *text) {
            //链接
            model.locateLink = text;
            success(model);
        }];
    }];
}


//获取视频第一帧
+(UIImage*) thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time {
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator =[[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 10)actualTime:NULL error:&thumbnailImageGenerationError];
    
    if(!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@",thumbnailImageGenerationError);
    
    UIImage*thumbnailImage = thumbnailImageRef ? [[UIImage alloc]initWithCGImage: thumbnailImageRef] : nil;
    
    return thumbnailImage;
}


//播放视频。可本地 可在线
+(void)playVideoWithURL:(NSURL *)url onController:(UIViewController *)vc{
    
    //创建视频播放控制器
    AVPlayerViewController *playerViewController = [[AVPlayerViewController alloc] init];
    
    //设置视频播放器 (这里为了简便,使用了URL方式,同样支持playerWithPlayerItem:的方式)
    playerViewController.player = [AVPlayer playerWithURL:url];
    
    
    
    //modal展示
    [vc presentViewController:playerViewController animated:YES completion:nil];
    
    
    //播放
    [playerViewController.player play];
}


//计算视频时长
+ (NSString *)getVideoTimeByUrl:(NSURL*) url{
    
    AVURLAsset *avUrl = [AVURLAsset assetWithURL:url];
    
    CMTime time = [avUrl duration];
    
    int total = ceil(time.value/time.timescale);
    
    int hour = total/3600;
    int minute = (total - hour*3600)/60;
    int second = total % 60;
    
    if (hour != 0) {
        return [NSString stringWithFormat:@"%02d:%02d:%02d",hour,minute,second];
    }else{
        NSLog(@"-------%d",second);
        return [NSString stringWithFormat:@"%02d:%02d",minute,second];
    }

}

//推送界面
+(void)pushToViewController:(UIViewController *)controller{
    //通过窗口找到当前的界面
    UINavigationController *nav =  [((UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController).viewControllers objectAtIndex:((UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController).selectedIndex];
    
    //推送界面
    [nav pushViewController:controller animated:YES];
}

//回退到主界面
+(void)popToRootViewControllerFrom:(UIViewController *)controller {
    [controller.navigationController popToViewController:[controller.navigationController.viewControllers objectAtIndex:0] animated:YES];
}
@end
