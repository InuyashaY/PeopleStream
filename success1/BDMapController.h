//
//  BDMapController.h
//  BDMap
//
//  Created by Inuyasha on 10/11/2019.
//  Copyright © 2019 Inuyasha. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^SureBlock) (void);
@interface BDMapController : UIViewController

@property (nonatomic,copy) SureBlock sureBlock;


@end

NS_ASSUME_NONNULL_END
