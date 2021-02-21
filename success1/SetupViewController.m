//
//  SetupControllerViewController.m
//  success1
//
//  Created by Inuyasha on 18/10/2019.
//  Copyright © 2019 Inuyasha. All rights reserved.
//

#import "SetupViewController.h"
#import "Manager/DataManager.h"
#import "SetupCell.h"
#import "XLActionViewController.h"

@interface SetupViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong , nonatomic) UICollectionView *collectionView;
@property (strong , nonatomic) NSMutableArray *sites;


@end

@implementation SetupViewController

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
    [_collectionView registerNib:[UINib nibWithNibName:@"SetupCell" bundle:nil] forCellWithReuseIdentifier:@"cellID"];
    [self.view addSubview:_collectionView];
}



#pragma mark --- delegate &&  dataSource---

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.sites != 0) {
        return self.sites.count;
    }
    return 0;
}

-(SetupCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SetupCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
    cell.model = [self.sites objectAtIndex:indexPath.row];
    
    return cell;
}


//获取被点击的地点 设置阈值
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [[XLActionViewController showAlertControllerWithType:AlertTypeAddSite AndName:@"请输入阈值"] setSureblock:^(NSString *text){
        // 接收输入并设置为阈值
        ((SetupCell*)[collectionView cellForItemAtIndexPath:indexPath]).model.threshold = text;
        [self.collectionView reloadData];
        
        for (SiteModel *model in [DataManager sharedManager].sitesArray) {
            NSLog(@"-------%@",model.threshold);
        }
        [[NSNotificationCenter     defaultCenter]postNotificationName:@"notification" object:nil];
    }];
}

-(void)setSites:(NSMutableArray *)sites{
    if (sites != nil) {
        _sites = sites;
    }
    [self.collectionView reloadData];
}


@end
