//
//  OverShowCell.m
//  success1
//
//  Created by Inuyasha on 19/10/2019.
//  Copyright © 2019 Inuyasha. All rights reserved.
//

#import "OverShowCell.h"
#import "Factory.h"
#import "Manager/YFileManager.h"
#import "DataManager.h"

@interface OverShowCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


@end

@implementation OverShowCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // 背景颜色和圆角
    self.backgroundColor = AREA_ITEM_BACKGROUND_COLOR;
    self.layer.cornerRadius = AREA_ITEM_CORNER_RADIOS;
    
    self.nameLabel.font = OVER_ITEM_FONT;
}


-(void)setModel:(OverVideoModel *)model{
    _model = model;
    [self.iconImageView setImage:[Factory thumbnailImageForVideo:[NSURL URLWithString:model.v_url] atTime:0]];
    float size = [_model.v_size floatValue];
    if (size > 1024.0) {
        //超过1M
        size = size/1024.0;
        self.sizeLabel.text = [NSString stringWithFormat:@"%.1fM",size];
    }else if(size > 1024*1024){
        //超过1GB
        size = size/1024.0/1024.0;
        self.sizeLabel.text = [NSString stringWithFormat:@"%.1GB",size];
    }else{
        self.sizeLabel.text = [NSString stringWithFormat:@"%.1fKB",size];
    }
    
    self.nameLabel.text = model.v_name;
}


- (IBAction)downloadButtonDidClicked:(UIButton *)sender {
    //下载的地点名
    NSString *fileName;
    for (SiteModel *model in [DataManager sharedManager].sitesArray) {
        if (model.locateLink == _model.v_location) {
            fileName = model.siteName;
        }
    }
    //下载
    [[YFileManager sharedManager] startDownLoadVideoWithURL:[NSURL URLWithString:self.model.v_url] toFileName:fileName];
    
}


@end
