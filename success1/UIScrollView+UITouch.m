//
//  UIScrollView+RXXUITouch.m
//  动态折线图
//
//  Created by 王方定 on 2019/11/8.
//  Copyright © 2019年 任璇璇. All rights reserved.
//

#import "UIScrollView+UITouch.h"

@implementation UIScrollView (UITouch)
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self nextResponder] touchesBegan:touches withEvent:event];
    [super touchesBegan:touches withEvent:event];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self nextResponder] touchesMoved:touches withEvent:event];
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self nextResponder] touchesEnded:touches withEvent:event];
    [super touchesEnded:touches withEvent:event];
}
@end
