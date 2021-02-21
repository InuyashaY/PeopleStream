//
//  RankView.m
//  success1
//
//  Created by Inuyasha on 07/10/2019.
//  Copyright © 2019 Inuyasha. All rights reserved.
//

#import "RankView.h"
#import "RankViewCell.h"
#import "HeaderReusableView.h"
#import "DataManager.h"
#import "Constants.h"
#import "Factory.h"
#import "LineViewController.h"

@interface RankView()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong , nonatomic) UICollectionView *collectionView;

@property (copy , nonatomic) NSMutableArray *sitesArray;

@end

@implementation RankView
@synthesize sitesArray = _sitesArray;

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        //创建布局对象
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.itemSize = CGSizeMake(RANK_ITEM_WIDTH, RANK_ITEM_HEIGHT);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) collectionViewLayout:layout];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        
        [_collectionView registerNib:[UINib nibWithNibName:@"RankViewCell" bundle:nil] forCellWithReuseIdentifier:@"cellID"];
        _collectionView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.collectionView];
        
    }
    return self;
}

-(void)setSitesArray:(NSMutableArray *)sitesArray{
    _sitesArray = [NSMutableArray arrayWithArray:sitesArray];
    NSLog(@"----------reload");
    //排序
    [_sitesArray sortUsingComparator:^NSComparisonResult(SiteModel *obj1, SiteModel *obj2) {
        return -[[NSNumber numberWithInteger:[obj1.peopleCountArray.lastObject integerValue]] compare:
                 [NSNumber numberWithInteger:[obj2.peopleCountArray.lastObject integerValue]]];
    }];
//    for (SiteModel *model in self.sitesArray) {
//        NSLog(@"----%@",model.siteName);
//    }
    
    // 刷新页面
    [_collectionView reloadData];
}

- (NSArray *)sitesArray{
    if (!_sitesArray) {
        //地点数
        _sitesArray = [DataManager sharedManager].sitesArray;
        
        //自动刷新数据
        [Factory loadDataToCollectionView:self.collectionView];

    }
    return _sitesArray;
}


#pragma mark --- dataSource ---
//几个地点信息
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//    return 17;
    return [DataManager sharedManager].sitesArray.count;
}

//header
// 要先设置表头大小
- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    CGSize size = CGSizeMake([UIScreen mainScreen].bounds.size.width, 60);
    return size;
}

//cell被点击
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    LineViewController *lvc = [LineViewController new];
    [lvc indexWithArea:indexPath.row];
    [Factory pushToViewController:lvc];
}

// 创建一个继承collectionReusableView的类,用法类比tableViewcell
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableView = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        // 头部视图
        // 代码初始化表头
        // [collectionView registerClass:[HeaderReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderReusableView"];
        // xib初始化表头
        [collectionView registerNib:[UINib nibWithNibName:@"HeaderReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderReusableView"];
        HeaderReusableView *tempHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderReusableView" forIndexPath:indexPath];
        reusableView = tempHeaderView;
    } else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        // 底部视图
    }
    return reusableView;
}

//加载的cell
- (RankViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    RankViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
    cell.model = self.sitesArray[indexPath.row];
    
    return cell;
}

@end
