//
//  MoreViewCell.m
//  success1
//
//  Created by 王方定 on 2019/11/9.
//  Copyright © 2019年 Inuyasha. All rights reserved.
//

#import "MoreViewCell.h"


@interface MoreViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@end
@implementation MoreViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setContent:(NSString *)content{
    _content = content;
    _contentLabel.text = self.content;
    _contentLabel.font = AREA_MOREBUTTON_FONT;
}

- (void)setImageName:(NSString *)imageName{
    _imageName = imageName;
    _iconImageView.image = [UIImage imageNamed:imageName];
}
@end
