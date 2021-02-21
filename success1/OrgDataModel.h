//
//  OrgDataModel.h
//  success1
//
//  Created by Inuyasha on 17/10/2019.
//  Copyright © 2019 Inuyasha. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OrgDataModel : NSObject
//人流数
@property (copy , nonatomic) NSString *f_count;
//时间
@property (copy , nonatomic) NSString *f_date;
//地点信息
@property (copy , nonatomic) NSString *f_location;

@end

NS_ASSUME_NONNULL_END
