//
//  YTabBar.m
//  success1
//
//  Created by Inuyasha on 07/10/2019.
//  Copyright © 2019 Inuyasha. All rights reserved.
//

#import "YTabBar.h"

@implementation YTabBar

//对子视图重新布局
- (void)layoutSubviews{
    [super layoutSubviews];
    
    //计算宽度
    CGFloat width = self.frame.size.width/3;
    
    //UITabBarButton 苹果自己封装的类型
    int i = 0;
    for (UIView *btn in self.subviews) {
        //判断btn对应的真实类型
        if([btn isKindOfClass:NSClassFromString(@"UITabBarButton")]){
            
            //更改每一个item对应的坐标
            btn.frame = CGRectMake(i*width, btn.frame.origin.y, width, btn.frame.size.height);
            
            i++;
        }
        
    }
}

@end
