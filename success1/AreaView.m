//
//  AreaView.m
//  success1
//
//  Created by Inuyasha on 08/10/2019.
//  Copyright © 2019 Inuyasha. All rights reserved.
//

#import "AreaView.h"
#import "Constants.h"
#import "AreaViewCell.h"
#import "View/YTabBar.h"
#import "Manager/DataManager.h"
//#import "YAlertController.h"
#import "Factory.h"
#import "SiteModel.h"

#import "XLActionViewController.h"


@interface AreaView()<UICollectionViewDelegate,UICollectionViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (strong , nonatomic) UICollectionView *collectionView;
@property (strong , nonatomic) UIButton *btn;
@property (strong , nonatomic) UIViewController *mainVC;
@property (strong , nonatomic) SiteModel *siteNew;



@end

@implementation AreaView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.itemSize = CGSizeMake(AREA_ITEM_WIDTH,AREA_ITEM_HEIGHT);
        layout.minimumInteritemSpacing = 20;
        layout.minimumLineSpacing = 20;
        layout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerNib:[UINib nibWithNibName:@"AreaViewCell" bundle:nil] forCellWithReuseIdentifier:@"cellID"];
        _collectionView.backgroundColor = [UIColor clearColor];
        [self addSubview:_collectionView];
        
        
        //添加按钮 配置
        self.btn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-80, 20, ADD_BUTTON_WIDTH, ADD_BUTTON_HEIGHT)];
        [self.btn setBackgroundImage:[UIImage imageNamed:@"Main_ToolBar_Icon_AddFolder"] forState:UIControlStateNormal];
        //self.btn.backgroundColor = ADD_BUTTON_BGCOLOR;
        self.btn.layer.cornerRadius = ADD_BUTTON_WIDTH/2.0;
        
        //点击事件
        [self.btn addTarget:self action:@selector(addBtnDidClicked) forControlEvents:UIControlEventTouchUpInside];
         
        
    }
    return self;
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



//添加图片
-(void)addBtnDidClicked{
    NSLog(@"hre");
    //创建新的地点
    [Factory createAreaModelWithBlock:^(SiteModel * _Nonnull model) {
        self.siteNew = model;
        [self chooseImage];
        NSLog(@"%@ --- %@",model.siteName,model.locateLink);
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
