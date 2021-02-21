//
//  FXWR_DataCenter.h
//  TestData
//
//  Created by 许磊 on 2019/10/15.
//  Copyright © 2019年 许磊. All rights reserved.
//

#import <Foundation/Foundation.h>

/**回调数据的block*/
typedef void(^HandleDataBlock)(NSMutableArray *info);

/**回调数据的block*/
typedef void(^CouldHandleDataBlock)(BOOL flag,NSMutableArray *info);

@interface FCWR_DataCenter : NSObject

/**单例模式*/
+(FCWR_DataCenter *)defaultDataCenter;

/**设置阈值*/
- (void)setThreshold:(NSString *)threshold;

/**获得对应地点人流所有数据*/
- (void)getPersonNumberDataWith:(NSString *)location handle:(HandleDataBlock)block;

/**获得对应地点人流瞬时数据
 **注意：回调的数组与上一个函数不同点是这个数组只有一个字典，即只有一个数据*/
- (void)getLatestPersonNumberDataWith:(NSString *)location handle:(HandleDataBlock)block;

/**获得对应地点超过阈值被保存的视频信息*/
- (void)getVideoDataWith:(NSString *)location handle:(CouldHandleDataBlock)block;

@end
