//
//  RankViewController.m
//  success1
//
//  Created by Inuyasha on 07/10/2019.
//  Copyright © 2019 Inuyasha. All rights reserved.
//

#import "RankViewController.h"
#import "RankView.h"

@interface RankViewController ()

@end

@implementation RankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    RankView *rankView = [[RankView alloc]initWithFrame:self.view.frame];
    //直接将子视图设置为RankView
    //self.navigationController.navigationItem.title
    self.view = rankView;

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
