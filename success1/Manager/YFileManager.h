//
//  YFileManager.h
//  success1
//
//  Created by Inuyasha on 19/10/2019.
//  Copyright © 2019 Inuyasha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SiteModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YFileManager : NSObject

//单例模式
+(YFileManager *)sharedManager;

/** 下载视频 */
- (void)startDownLoadVideoWithURL:(NSURL *)url toFileName:(NSString *)fileName;

//读取数据
-(NSArray *)loadDatawithSiteModel:(SiteModel *)model;

@end

NS_ASSUME_NONNULL_END
