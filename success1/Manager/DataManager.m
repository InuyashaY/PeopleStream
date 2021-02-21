//
//  DataManager.m
//  success1
//
//  Created by Inuyasha on 07/10/2019.
//  Copyright © 2019 Inuyasha. All rights reserved.
//

#import "DataManager.h"
#import <MJExtension/MJExtension.h>
#import "FCWR_DataCenter.h"
#import "OrgDataModel.h"
#import "OverVideoModel.h"
//#import "YAlertController.h"
#import "XLActionViewController.h"


@interface DataManager()
@property (strong , nonatomic) NSMutableArray *preparedModels;


@end

static DataManager *instance = nil;
@implementation DataManager
//初始化单例
+(DataManager *)sharedManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [DataManager new];
        instance.sitesArray = [NSMutableArray array];
        instance.preparedModels = [NSMutableArray array];
        [instance initSites];
        [instance initPreparedModels];
        
    });
    return instance;
}


// 访问地点。如果没有 就加载数据
-(NSMutableArray<SiteModel *> *)sitesArray{
    if (_sitesArray == nil) {
        //        [self initSites];
        [self loadData];
        NSLog(@"DataManager----sitesArray");
    }
    return _sitesArray;
}


//加载并解析 网络传递来的json
-(void)loadData{
    if (_sitesArray != nil) {
        for (SiteModel *siteModel in _sitesArray) {
            //添加异步  数据得到后在执行下一步
            dispatch_semaphore_t sema = dispatch_semaphore_create(0);
            
            //获取当前人数信息
            [[FCWR_DataCenter defaultDataCenter] getPersonNumberDataWith:siteModel.locateLink handle:^(NSMutableArray *info) {
                //清空原数组
                [siteModel.peopleCountArray removeAllObjects];
                [siteModel.timeArray removeAllObjects];
                NSArray *dataArray = [OrgDataModel mj_objectArrayWithKeyValuesArray:info];
                for (OrgDataModel *data in dataArray) {
                    [siteModel.peopleCountArray addObject:data.f_count];
                    
                    [siteModel.timeArray addObject:data.f_date];
                    
                }
                NSLog(@"total:%lu",(unsigned long)siteModel.peopleCountArray.count);
                dispatch_semaphore_signal(sema);
            }];
            
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
            
        }
    }
}


//加载人数过多的视频数据
-(void)loadOverVideoDataWithLocation:(NSString *)location handle:(nonnull OverDataHandle)handleOver{
    if (_sitesArray != nil) {
        
        [[FCWR_DataCenter defaultDataCenter] getVideoDataWith:location handle:^(BOOL flag, NSMutableArray *info) {
            //判断该视频有没有超出阈值
            if (flag == YES) {
                NSArray *overVideoArray = [OverVideoModel mj_objectArrayWithKeyValuesArray:info];
                handleOver(overVideoArray);
            }
            
            
            //flag == NO
            //说明对应地点没有超过阈值的时刻
            if (flag == NO) {
                //                [YAlertController showAlertControllerWithType:AlertTypeAlert alert:@"无超额数据" sure:nil];
                [XLActionViewController showAlertControllerWithType:AlertTypeAlert AndName:@"无超额数据"];
            }
        }];
    }
}


//初始化三个地点
-(void)initSites{
    SiteModel *model1 = [SiteModel new];
    SiteModel *model2 = [SiteModel new];
    //    SiteModel *model3 = [SiteModel new];
    model1.siteName = @"二教";
    model2.siteName = @"图书馆";
    //    model3.siteName = @"图书馆";
    model1.locateLink = @"loc_2";
    model2.locateLink = @"loc_4";
    //    model3.locateLink = @"loc_3";
    model1.siteImage = [UIImage imageNamed:@"二教"];
    model2.siteImage = [UIImage imageNamed:@"图书馆"];
    //    model3.siteImage = [UIImage imageNamed:@"hexi"];
    
    [self.sitesArray addObject:model1];
    [self.sitesArray addObject:model2];
    //    [self.sitesArray addObject:model3];
    
    
    
}


-(void)initPreparedModels{
        SiteModel *model1 = [SiteModel new];
        SiteModel *model2 = [SiteModel new];
        SiteModel *model3 = [SiteModel new];
        model1.siteName = @"二教";
        model2.siteName = @"图书馆";
        model3.siteName = @"食堂";
        model1.locateLink = @"loc_2";
        model2.locateLink = @"loc_4";
        model3.locateLink = @"loc_3";
        model1.siteImage = [UIImage imageNamed:@"二教"];
        model2.siteImage = [UIImage imageNamed:@"图书馆"];
        model3.siteImage = [UIImage imageNamed:@"食堂"];
        
        [self.preparedModels addObject:model1];
        [self.preparedModels addObject:model2];
        [self.preparedModels addObject:model3];
}
@end
