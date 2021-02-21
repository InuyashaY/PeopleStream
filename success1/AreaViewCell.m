//
//  AreaViewCell.m
//  success1
//
//  Created by Inuyasha on 08/10/2019.
//  Copyright © 2019 Inuyasha. All rights reserved.
//

#import "AreaViewCell.h"
@interface AreaViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *siteLabel;

@end

@implementation AreaViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    // 背景颜色和圆角
    //self.backgroundColor = AREA_ITEM_BACKGROUND_COLOR;
    //self.icon.layer.cornerRadius = AREA_ITEM_CORNER_RADIOS;
    
    
    // label的字体
    self.siteLabel.font = AREA_ITEM_FONT;
}


-(void)setModel:(SiteModel *)model{
    _model = model;
    [self.icon setImage:model.siteImage ];
    self.siteLabel.text = model.siteName;
}

@end
