//
//  DownloadVideoCell.m
//  success1
//
//  Created by Inuyasha on 19/10/2019.
//  Copyright © 2019 Inuyasha. All rights reserved.
//

#import "DownloadVideoCell.h"
#import "Factory.h"

@interface DownloadVideoCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation DownloadVideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // 背景颜色和圆角
    self.backgroundColor = AREA_ITEM_BACKGROUND_COLOR;
    self.layer.cornerRadius = AREA_ITEM_CORNER_RADIOS;
}

-(void)setModel:(DownloadVideoModel *)model{
    _model = model;
    
    [self.iconImageView setImage:[Factory thumbnailImageForVideo:[NSURL fileURLWithPath:model.url] atTime:0]];
    
    self.timeLabel.text = model.time;
    
    self.nameLabel.text = model.name;
}

@end
