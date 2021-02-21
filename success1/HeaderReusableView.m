//
//  HeaderReusableView.m
//  success1
//
//  Created by Inuyasha on 07/10/2019.
//  Copyright © 2019 Inuyasha. All rights reserved.
//

#import "HeaderReusableView.h"

@interface HeaderReusableView()
@property (weak, nonatomic) IBOutlet UILabel *rank;
@property (weak, nonatomic) IBOutlet UILabel *siteName;
@property (weak, nonatomic) IBOutlet UILabel *peopleCount;
@property (weak, nonatomic) IBOutlet UILabel *crowd;

@end

@implementation HeaderReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    //设置字体
    self.rank.font = RANK_HEADER_FONT;
    self.siteName.font = RANK_HEADER_FONT;
    self.peopleCount.font = RANK_HEADER_FONT;
    self.crowd.font = RANK_HEADER_FONT;
}

@end
