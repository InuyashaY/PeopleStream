//
//  SetOverCell.m
//  success1
//
//  Created by Inuyasha on 19/10/2019.
//  Copyright © 2019 Inuyasha. All rights reserved.
//

#import "SetOverCell.h"
@interface SetOverCell()
@property (weak, nonatomic) IBOutlet UILabel *title;

@end

@implementation SetOverCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.title.font = OVER_TITLE_FONT;
}

-(void)setModel:(SiteModel *)model{
    _model = model;
    self.title.text = _model.siteName;
}

@end
