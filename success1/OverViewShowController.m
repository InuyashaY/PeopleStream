//
//  OverViewShowController.m
//  success1
//
//  Created by Inuyasha on 19/10/2019.
//  Copyright © 2019 Inuyasha. All rights reserved.
//

#import "OverViewShowController.h"
#import "OverShowCell.h"
#import "Manager/YFileManager.h"
#import "Factory.h"

@interface OverViewShowController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong , nonatomic) UICollectionView *collectionView;

@end

@implementation OverViewShowController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //创建布局对象
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake(VIDEO_ITEM_WIDTH,VIDEO_ITEM_HEIGHT);
    layout.minimumInteritemSpacing = 10;
    layout.minimumLineSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    //创建collectionView
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.pagingEnabled = YES;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerNib:[UINib nibWithNibName:@"OverShowCell" bundle:nil] forCellWithReuseIdentifier:@"cellID"];
    
    [self.view addSubview:_collectionView];
}


#pragma mark --- delegate && dataSource ---
//个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _model.overVideoArray.count;
}

//初始化
- (OverShowCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    OverShowCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
    cell.model = _model.overVideoArray[indexPath.row];
    return cell;
}


//点击播放
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    OverShowCell *cell = (OverShowCell*)[collectionView cellForItemAtIndexPath:indexPath];
    
    //播放
    [Factory playVideoWithURL:[NSURL URLWithString:cell.model.v_url] onController:self];
    
    
}


@end
