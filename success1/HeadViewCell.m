//
//  HeadViewCell.m
//  success1
//
//  Created by Inuyasha on 08/10/2019.
//  Copyright © 2019 Inuyasha. All rights reserved.
//

#import "HeadViewCell.h"

@interface HeadViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation HeadViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.nameLabel.font = ME_HEADER_FONT;
}

-(void)layoutSubviews{
    [super layoutSubviews];
//    self.icon.layer.cornerRadius = 50;
//    self.icon.layer.maskedCorners = YES;
//    self.icon.clipsToBounds = YES;
}

@end
