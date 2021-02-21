//
//  SetupCell.m
//  success1
//
//  Created by Inuyasha on 18/10/2019.
//  Copyright © 2019 Inuyasha. All rights reserved.
//

#import "SetupCell.h"
@interface SetupCell()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *threshold;

@end

@implementation SetupCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.title.font = SETUP_ITEM_TITLE_FONT;
    self.threshold.font = SETUP_ITEM_THRED_FONT;
}

-(void)setModel:(SiteModel *)model{
    _model = model;
    self.title.text = _model.siteName;
    NSLog(@"%@",_model.threshold);
    self.threshold.text = [@"当前阈值为：" stringByAppendingString:_model.threshold];
}

@end
