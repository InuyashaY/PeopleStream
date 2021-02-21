//
//  ToolViewCell.m
//  success1
//
//  Created by Inuyasha on 08/10/2019.
//  Copyright © 2019 Inuyasha. All rights reserved.
//

#import "ToolViewCell.h"

@interface ToolViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;



@end

@implementation ToolViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.titleLabel.font = ME_ITEM_FONT;
}

-(void)setTitle:(NSString *)title{
    _title = title;
    self.titleLabel.text = title;
    
}
- (void)setIconName:(NSString *)iconName{
    _iconName = iconName;
    self.iconImageView.image = [UIImage imageNamed:iconName];
}
@end
