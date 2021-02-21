//
//  MeViewController.m
//  success1
//
//  Created by Inuyasha on 07/10/2019.
//  Copyright © 2019 Inuyasha. All rights reserved.
//

#import "MeViewController.h"
#import "Constants.h"
#import "ToolViewCell.h"
#import "HeadViewCell.h"
#import "SetupViewController.h"
#import "OverViewController.h"
#import "DownloadViewController.h"
#import "Manager/DataManager.h"

@interface MeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong , nonatomic) UICollectionView *collectionView;

@property (strong , nonatomic) NSArray *toolTitleArray;
@property (nonatomic, strong) NSArray *iconImageArray;

@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建布局对象
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake(SCREEN_WIDTH, 60);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 10;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    //创建collectionView
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.pagingEnabled = YES;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerNib:[UINib nibWithNibName:@"ToolViewCell" bundle:nil] forCellWithReuseIdentifier:@"cellID"];
    [_collectionView registerNib:[UINib nibWithNibName:@"HeadViewCell" bundle:nil] forCellWithReuseIdentifier:@"cellHead"];
    [self.view addSubview:_collectionView];
    
    self.toolTitleArray = [NSArray arrayWithObjects:@"设置阈值",@"超额人流",@"缓存视频", nil];
    self.iconImageArray = [NSArray arrayWithObjects:@"shezhi",@"chaoe",@"download",nil];
}


#pragma mark --- delegate &dataSource ---
//设置两行
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _toolTitleArray.count+1;
}

// 配置item
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell;
        if (indexPath.row != 0) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
        cell.frame = CGRectMake(0, 100+60*(indexPath.row-1), SCREEN_WIDTH, 60);
        ((ToolViewCell*)cell).title = [_toolTitleArray objectAtIndex:indexPath.row-1];
        ((ToolViewCell*)cell).iconName = [_iconImageArray objectAtIndex:indexPath.row-1];
    }else{
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellHead" forIndexPath:indexPath];
        cell.frame = CGRectMake(0, 0, SCREEN_WIDTH, 100);
    }
    
    return cell;
}


//item点击事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if([[collectionView cellForItemAtIndexPath:indexPath] isKindOfClass:[ToolViewCell class]]){
        
        //被点击的cell
        ToolViewCell *cell = (ToolViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        
        //通过窗口找到当前的界面
        UINavigationController *nav =  [((UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController).viewControllers objectAtIndex:((UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController).selectedIndex];
        
        if ([cell.title isEqualToString:[_toolTitleArray objectAtIndex:0]]) {
            //设置阈值界面
            SetupViewController *svc = [SetupViewController new];
            [svc setSites:[DataManager sharedManager].sitesArray];
            [nav pushViewController:svc animated:YES];
        }else if ([cell.title isEqualToString:[_toolTitleArray objectAtIndex:1]]){
            //超额人流界面
            OverViewController *ovc = [OverViewController new];
            [nav pushViewController:ovc animated:YES];
        }else{
            //缓存视频界面
            DownloadViewController *dvc = [DownloadViewController new];
            [dvc setSites:[DataManager sharedManager].sitesArray];
            [nav pushViewController:dvc animated:YES];
        }
    }
}

@end
