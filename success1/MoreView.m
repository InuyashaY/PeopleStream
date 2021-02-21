//
//  MoreView.m
//  success1
//
//  Created by 王方定 on 2019/11/9.
//  Copyright © 2019年 Inuyasha. All rights reserved.
//

#import "MoreView.h"
#import "MoreViewCell.h"
#import "DownloadViewController.h"
#import "SetupViewController.h"
#import "SiteModel.h"
#import "OverViewShowController.h"

@interface MoreView ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *contentArray;
@property (nonatomic, strong) NSArray *imgNameArray;
@property (strong , nonatomic) SiteModel *model;

@end

@implementation MoreView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentArray = @[@"缓存视频",@"修改阈值"];
        self.imgNameArray = @[@"download",@"shezhi"];
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _tableView.layer.borderWidth = 1;
        _tableView.layer.cornerRadius = 10;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_tableView];
        
        [_tableView registerNib:[UINib nibWithNibName:@"MoreViewCell" bundle:nil] forCellReuseIdentifier:@"cellID"];
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MoreViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    cell.content = _contentArray[indexPath.row];
    cell.imageName = _imgNameArray[indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //通过窗口找到当前的界面
    UINavigationController *nav =  [((UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController).viewControllers objectAtIndex:((UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController).selectedIndex];
   
    //进入对应点击的页面
    if (indexPath.row == 0) {
        //进入缓存视频
        DownloadViewController *dvc = [DownloadViewController new];
        [nav pushViewController:dvc animated:YES];
        [self removeFromSuperview];
    }else{
        //进入修改阈值
        SetupViewController *svc = [SetupViewController new];
        [svc setSites:[NSMutableArray arrayWithObject:self.model]];
        [nav pushViewController:svc animated:YES];
        
        [self removeFromSuperview];
    }
    //超额界面如下
    //        OverViewShowController *osc = [OverViewShowController new];
    //        [osc setModel:self.model];

}

- (void)setModel:(SiteModel *)model{
    if(model != nil){
        _model = model;
    }
}
@end
