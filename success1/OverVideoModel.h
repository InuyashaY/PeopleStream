//
//  OverVideoModel.h
//  success1
//
//  Created by Inuyasha on 19/10/2019.
//  Copyright © 2019 Inuyasha. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OverVideoModel : NSObject

//保存的视频是哪个地点的
@property (copy , nonatomic) NSString *v_location;
//保存的视频名称
@property (copy , nonatomic) NSString *v_name;
//保存的视频大小
@property (copy , nonatomic) NSString *v_size;
//视频在服务端的位置
@property (copy , nonatomic) NSString *v_url;


@end

NS_ASSUME_NONNULL_END
