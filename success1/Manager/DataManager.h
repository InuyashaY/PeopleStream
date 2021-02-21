//
//  DataManager.h
//  success1
//
//  Created by Inuyasha on 07/10/2019.
//  Copyright © 2019 Inuyasha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SiteModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^OverDataHandle)(NSArray *overModelArray);

@interface DataManager : NSObject
//所有地点
@property (strong , nonatomic) NSMutableArray<SiteModel *> *sitesArray;

//单例模式
+(DataManager *)sharedManager;

//加载数据
-(void)loadData;

//加载视频数据
-(void)loadOverVideoDataWithLocation:(NSString *)location handle:(OverDataHandle)handleOver;

-(NSMutableArray *)preparedModels;
@end

NS_ASSUME_NONNULL_END
