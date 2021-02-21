//
//  SiteModel.h
//  success1
//
//  Created by Inuyasha on 07/10/2019.
//  Copyright © 2019 Inuyasha. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SiteModel : NSObject

//地点名称
@property (copy , nonatomic) NSString *siteName;
//人数数组
@property (strong , nonatomic) NSMutableArray *peopleCountArray;
//时间
@property (strong , nonatomic) NSMutableArray *timeArray;
//获取地点信息的链接
@property (copy , nonatomic) NSString *locateLink;
//阈值
@property (copy , nonatomic) NSString *threshold;
//区域设置的图片
@property (strong , nonatomic) UIImage *siteImage;
//超额人流数据模型数组
@property (strong , nonatomic) NSMutableArray *overVideoArray;

@end

NS_ASSUME_NONNULL_END
