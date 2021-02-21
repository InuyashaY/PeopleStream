//
//  OverViewController.m
//  success1
//
//  Created by Inuyasha on 19/10/2019.
//  Copyright © 2019 Inuyasha. All rights reserved.
//

#import "OverViewController.h"
#import "Manager/DataManager.h"
#import "SetOverCell.h"
#import "OverVideoModel.h"
#import "Factory.h"
#import "OverViewShowController.h"

@interface OverViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong , nonatomic) UICollectionView *collectionView;

@end

@implementation OverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = BACKBUTTON_COLOR;
    
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
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerNib:[UINib nibWithNibName:@"SetOverCell" bundle:nil] forCellWithReuseIdentifier:@"cellID"];
    [self.view addSubview:_collectionView];
}



#pragma mark --- delegate &&  dataSource---

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if ([DataManager sharedManager].sitesArray.count != 0) {
        NSLog(@"%lu",(unsigned long)[DataManager sharedManager].sitesArray.count);
        return [DataManager sharedManager].sitesArray.count;
    }
    return 0;
}

-(SetOverCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SetOverCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
    cell.model = [[DataManager sharedManager].sitesArray objectAtIndex:indexPath.row];
    
    return cell;
}


//获取被点击的地点
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //被点击的cell
    SetOverCell *cell = ((SetOverCell*)[collectionView cellForItemAtIndexPath:indexPath]);
    [[DataManager sharedManager] loadOverVideoDataWithLocation:cell.model.locateLink handle:^(NSArray * _Nonnull overModelArray) {
//        NSLog(@"----%@",overModelArray);
//        for (OverVideoModel *model in overModelArray) {
//            NSLog(@"---%@",model.v_url);
//            NSLog(@"%@",[Factory thumbnailImageForVideo:[NSURL URLWithString:model.v_url] atTime:0]);
//        }
        //1.通过窗口找到当前的界面
        UINavigationController *nav =  [((UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController).viewControllers objectAtIndex:((UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController).selectedIndex];
        
        OverViewShowController *ovsc = [OverViewShowController new];
        ovsc.model = cell.model;
        [nav pushViewController:ovsc animated:YES];
    }];
}

@end
