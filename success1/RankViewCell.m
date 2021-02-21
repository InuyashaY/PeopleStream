//
//  RankViewCell.m
//  success1
//
//  Created by Inuyasha on 07/10/2019.
//  Copyright © 2019 Inuyasha. All rights reserved.
//

#import "RankViewCell.h"
#import "Manager/DataManager.h"
#import "RankView.h"
@interface RankViewCell()
@property (weak, nonatomic) IBOutlet UILabel *rank;
@property (weak, nonatomic) IBOutlet UILabel *siteName;
@property (weak, nonatomic) IBOutlet UILabel *peopleCount;
@property (weak, nonatomic) IBOutlet UILabel *crowdStardard;
@property (weak, nonatomic) IBOutlet UIButton *icon;


@end

@implementation RankViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    //设置排名为黑体
    self.rank.font = [UIFont fontWithName:@"Helvetica-Bold" size:24];
    self.siteName.font = RANK_ITEM_FONT;
    self.peopleCount.font = RANK_ITEM_FONT;
    self.crowdStardard.font = RANK_ITEM_FONT;
    
    // 设置按钮图片
    self.icon.frame = CGRectMake(self.icon.frame.origin.x, self.icon.frame.origin.y, 15, 15);
    [self.icon setBackgroundImage:[UIImage imageNamed:@"上升(1)"] forState:UIControlStateNormal];
    [self.icon setBackgroundImage:[UIImage imageNamed:@"上升"] forState:UIControlStateSelected];
}

- (void)setModel:(SiteModel *)model{
    //找到rankView
    RankView *rankView = (RankView*)self.superview.superview;
    
    _model = model;
    //计算排名
    self.rank.text = [NSString stringWithFormat:@"%lu",[rankView.sitesArray indexOfObject:_model]+1];
    self.siteName.text = model.siteName;
    //拥挤指数。没有就默认为80
    if (_model.threshold == nil) {
        _model.threshold = @"80";
    }
    // 计算拥挤指数
    self.crowdStardard.text = [NSString stringWithFormat:@"%.2f",[_model.peopleCountArray.lastObject floatValue]/[_model.threshold floatValue]];
    self.peopleCount.text = model.peopleCountArray.lastObject;
    //拥挤指数图片
    if ([self.crowdStardard.text floatValue] > 1.0) {
        self.icon.selected = YES;
        self.crowdStardard.textColor = [UIColor redColor];
    }else{
        self.icon.selected = NO;
        self.crowdStardard.textColor = [UIColor greenColor];
    }
}

@end
