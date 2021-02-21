//
//  DownloadViewController.m
//  success1
//
//  Created by Inuyasha on 19/10/2019.
//  Copyright © 2019 Inuyasha. All rights reserved.
//

#import "DownloadViewController.h"
#import "Manager/YFileManager.h"
#import "DownloadVideoCell.h"
#import "Factory.h"
#import "Manager/DataManager.h"
#import "YHeaderReusableView.h"

@interface DownloadViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong , nonatomic) UICollectionView *collectionView;

@property (strong , nonatomic) NSMutableDictionary *videoModels;

@property (strong , nonatomic) NSMutableArray *sites;

@end

@implementation DownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = BACKBUTTON_COLOR;
    
    //创建布局对象
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake(VIDEO_ITEM_WIDTH,VIDEO_ITEM_HEIGHT);
    layout.minimumInteritemSpacing = 10;
    layout.minimumLineSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    layout.headerReferenceSize = CGSizeMake(DOWNLOAD_HEADER_WIDTH, DOWNLOAD_HEADER_HEIGHT);
    
    //创建collectionView
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.pagingEnabled = YES;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerNib:[UINib nibWithNibName:@"DownloadVideoCell" bundle:nil] forCellWithReuseIdentifier:@"cellID"];
    
    //注册头视图
    [_collectionView registerNib:[UINib nibWithNibName:@"YHeaderReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
    self.videoModels = [NSMutableDictionary dictionary];
    
    [self.view addSubview:_collectionView];
}

-(NSMutableDictionary *)videoModels{
    for (int i = 0; i < self.sites.count; i++) {
        NSArray *array = [[YFileManager sharedManager] loadDatawithSiteModel:[self.sites objectAtIndex:i]];
        if (array.count != 0) {
            [_videoModels setObject:array forKey:[NSString stringWithFormat:@"%d",i]];
        }
    }
    return _videoModels;
}


#pragma mark --- delegate && dataSource ---
//几个section
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.videoModels.count;
}

//加载header
- (YHeaderReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    YHeaderReusableView *reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
   
    [reusableview setTitle:((SiteModel*)[self.sites objectAtIndex:[[[_videoModels allKeys] objectAtIndex:indexPath.section] intValue]]).siteName];
    
    return reusableview;
}

//配置几个item
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    
    if (self.videoModels.count != 0) {
        return ((NSArray*)[_videoModels valueForKey:[[_videoModels allKeys] objectAtIndex:section]]).count;
    }
    return 0;
}

//加载cell
- (DownloadVideoCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DownloadVideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
//    cell.model = [[self.videoModels objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.model = [[_videoModels objectForKey:[[_videoModels allKeys] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    return cell;
}

// 点击 播放
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    DownloadVideoCell *currentCell = (DownloadVideoCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    NSLog(@"--------%@",currentCell.model.url);
    [Factory playVideoWithURL:[NSURL fileURLWithPath:currentCell.model.url] onController:self];
}

@end
