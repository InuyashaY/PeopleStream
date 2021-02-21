//
//  AreaViewController.m
//  success1
//
//  Created by Inuyasha on 07/10/2019.
//  Copyright © 2019 Inuyasha. All rights reserved.
//

#import "AreaViewController.h"
#import "Constants.h"
#import "AreaViewCell.h"
#import "View/YTabBar.h"
#import "Manager/DataManager.h"
#import "Factory.h"
#import "SiteModel.h"
#import "LineViewController.h"
#import "XLActionViewController.h"
#import "BDMapController.h"

@interface AreaViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

/** 添加按钮 */
@property (strong , nonatomic) UIButton *btn;
/** 新的地点 */
@property (strong , nonatomic) SiteModel *siteNew;
@property (strong , nonatomic) UIViewController *mainVC;
@end

@implementation AreaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    AreaView *areaView = [[AreaView alloc]initWithFrame:self.view.frame];
//    self.view = areaView;
//    NSLog(@"%f",self.view.frame.size.height);
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake(AREA_ITEM_WIDTH,AREA_ITEM_HEIGHT);
    layout.minimumInteritemSpacing = 10;
    layout.minimumLineSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-200) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerNib:[UINib nibWithNibName:@"AreaViewCell" bundle:nil] forCellWithReuseIdentifier:@"cellID"];
    _collectionView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_collectionView];
    
    
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"add"] style:UIBarButtonItemStylePlain target:self action:@selector(addBtnDidClicked)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"add"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(addBtnDidClicked)];
    //self.navigationItem.rightBarButtonItem.tintColor = [UIColor clearColor];
}

#pragma mark --- delegate & datasource ---
//item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [DataManager sharedManager].sitesArray.count;
}


//初始化item
- (AreaViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    AreaViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
    cell.model = [[DataManager sharedManager].sitesArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    LineViewController *lvc = [[LineViewController alloc] init];
    [lvc indexWithArea:indexPath.row];
    [Factory pushToViewController:lvc];
}

//添加图片
-(void)addBtnDidClicked{
    //创建新的地点
//    [Factory createAreaModelWithBlock:^(SiteModel * _Nonnull model) {
//        self.siteNew = model;
//        [self chooseImage];
//        NSLog(@"%@ --- %@",model.siteName,model.locateLink);
//    }];
    BDMapController *bdc = [BDMapController new];
    [Factory pushToViewController:bdc];
    [bdc setSureBlock:^{
        [self.collectionView reloadData];
    }];
}


//选择系统图片
-(void)chooseImage{
    //    [YAlertController showActionSheet:^(ActionType type) {
    //
    //    }];
    //    [[XLActionViewController showActionSheet] setActionBlock:^(ActionType type) {
    //        if (type == ActionTypeCamera) {
    //            //相机
    //        }else{
    //            //相册
    //            //从系统相册里选取图片
    //            UIImagePickerController *imgPicker = [[UIImagePickerController alloc]init];
    //            //配置读取图片还是视频
    //            imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //            //1.通过窗口找到当前的界面
    //            UINavigationController *nav =  [((UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController).viewControllers objectAtIndex:((UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController).selectedIndex];
    //            //找到导航栏控制器当前显示的界面
    //            self.mainVC = nav.visibleViewController;
    //            //显示控制器
    //            [self.mainVC presentViewController:imgPicker animated:YES completion:nil];
    //            //设置代理
    //            imgPicker.delegate = self;
    //        }
    //    }];
    
//    UIImage *img = [[DataManager sharedManager].defaultImages objectAtIndex:[DataManager sharedManager].sitesArray.count];
//    
//    //设置为item的图片
//    _siteNew.siteImage = img;
//    
//    // 将新site添加入DataManager
//    [[DataManager sharedManager].sitesArray addObject:self.siteNew];
//    // 重载界面
//    [self.collectionView reloadData];
}




#pragma mark ---ImagePickerDelegate---
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    //移除imagePickerController对象
    [_mainVC dismissViewControllerAnimated:picker completion:nil];
}

//选中图片
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSLog(@"%@",info);
    //获取选中的图片
    UIImage *img = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    //设置为item的图片
    _siteNew.siteImage = img;
    
    [_mainVC dismissViewControllerAnimated:picker completion:nil];
    
    // 将新site添加入DataManager
    [[DataManager sharedManager].sitesArray addObject:self.siteNew];
    // 重载界面
    [self.collectionView reloadData];
}
@end
