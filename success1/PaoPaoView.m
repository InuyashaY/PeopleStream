//
//  PaoPaoView.m
//  动态折线图
//
//  Created by 王方定 on 2019/11/8.
//  Copyright © 2019年 任璇璇. All rights reserved.
//

#import "PaoPaoView.h"

@interface PaoPaoView ()
@property (nonatomic, strong) UIButton *paopaoBtn;

@end
@implementation PaoPaoView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //self.backgroundColor = [UIColor redColor];
        self.paopaoBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) ];
        [_paopaoBtn setImage:[UIImage imageNamed:@"paopao"] forState:UIControlStateNormal];
        //_paopaoBtn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"paopao.png"]];
        //[paopaoBtn setTitle:self.title forState:UIControlStateNormal];
        //paopaoBtn.titleLabel.text = self.title;
        //NSLog(@"%@",self.title);
        
        //_paopaoBtn.enabled = NO;
        [self addSubview:_paopaoBtn];
    }
    return self;
}

- (void)setTitle:(NSString *)title{
    _title = title;
    [_paopaoBtn setTitle:self.title forState:UIControlStateNormal];
    [_paopaoBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //NSLog(@"%@",self.title);
}

@end
