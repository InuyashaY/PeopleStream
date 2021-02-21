//
//  YHeaderReusableView.m
//  success1
//
//  Created by Inuyasha on 26/10/2019.
//  Copyright © 2019 Inuyasha. All rights reserved.
//

#import "YHeaderReusableView.h"

@interface YHeaderReusableView()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation YHeaderReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.titleLabel.font = DOWNLOAD_HEADER_FONT;
}


-(void)setTitle:(NSString *)title{
    _title = title;
    self.titleLabel.text = title;
}



@end
