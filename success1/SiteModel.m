//
//  SiteModel.m
//  success1
//
//  Created by Inuyasha on 07/10/2019.
//  Copyright © 2019 Inuyasha. All rights reserved.
//

#import "SiteModel.h"
#import "Manager/FCWR_DataCenter.h"
#import "Manager/DataManager.h"

@implementation SiteModel
@synthesize threshold = _threshold;

-(NSMutableArray *)peopleCountArray{
    if (_peopleCountArray == nil) {
        self.peopleCountArray = [NSMutableArray array];
    }
    return _peopleCountArray;
}

-(NSMutableArray *)timeArray{
    if (_timeArray == nil) {
        self.timeArray = [NSMutableArray array];
    }
    return _timeArray;
}

//设置阈值
-(void)setThreshold:(NSString *)threshold{
    _threshold = threshold;
    //设置阈值
    [[FCWR_DataCenter defaultDataCenter] setThreshold:_threshold];
    NSLog(@"%@的阈值设置为：%@",self.siteName,_threshold);
}

-(NSString *)threshold{
    // 访问阈值。若没有 默认设置为80
    if (_threshold == nil) {
        self.threshold = @"80";
    }
    return _threshold;
}

-(NSMutableArray *)overVideoArray{
    if (_overVideoArray == nil) {
        [[DataManager sharedManager] loadOverVideoDataWithLocation:self.locateLink handle:^(NSArray * _Nonnull overModelArray) {
            self.overVideoArray = [NSMutableArray arrayWithArray:overModelArray];
            NSLog(@"finish");
        }];
    }
    NSLog(@"return");
    return _overVideoArray;
}

@end
