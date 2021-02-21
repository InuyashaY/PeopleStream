//
//  BDMapController.m
//  BDMap
//
//  Created by Inuyasha on 10/11/2019.
//  Copyright © 2019 Inuyasha. All rights reserved.
//

#import "BDMapController.h"

#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#define BMK_KEY @"kLspFEam7zjW1bScvgNtG0xRFsUdFImM"//百度地图的key
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BMKLocationKit/BMKLocationComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import "Manager/DataManager.h"
#import "XLActionViewController.h"
#import "AreaViewController.h"
#import "Factory.h"

@interface BDMapController ()<BMKLocationManagerDelegate,BMKMapViewDelegate,BMKAnnotation,UIGestureRecognizerDelegate>
@property (strong , nonatomic) BMKMapManager *mapManager;
@property (nonatomic,strong) BMKMapView *mapView;//地图视图
@property (nonatomic,strong) BMKLocationManager *locationManager;//定位服务
@property (strong , nonatomic) BMKUserLocation *userLocation;       //自己的位置
@property (strong , nonatomic) BMKAnnotationView* seletedAnnotation;



@end

@implementation BDMapController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.seletedAnnotation = [BMKAnnotationView new];
    [self startBDMap];
    
    //初始化地图
    self.mapView = [[BMKMapView alloc] initWithFrame:self.view.frame];
    self.mapView.delegate =self;
    
    //添加到view上
    [self.view addSubview:self.mapView];
    
    //设置代理
    self.locationManager.delegate = self;
    
    //开启定位
    [self.locationManager startUpdatingLocation];
    //[self.locationManager startUpdatingHeading];
    _mapView.showsUserLocation = YES;//显示定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;//设置定位的状态为定位跟随模式
    
    [self initAnnotations];
    _mapView.zoomLevel = 19;
    
    [self addCustomGestures];
}

-(void)startBDMap{
    _mapManager = [BMKMapManager new];
    BOOL ret = [_mapManager start:BMK_KEY generalDelegate:nil];
    if (!ret)
    {
        NSLog(@"百度地图启动失败");
    }
    else
    {
        NSLog(@"百度地图启动成功");
    }
}


#pragma mark - BMKLocationManagerDelegate
/**
 @brief 当定位发生错误时，会调用代理的此方法
 @param manager 定位 BMKLocationManager 类
 @param error 返回的错误，参考 CLError
 */
- (void)BMKLocationManager:(BMKLocationManager * _Nonnull)manager didFailWithError:(NSError * _Nullable)error {
    NSLog(@"定位失败");
}


/**
 @brief 连续定位回调函数
 @param manager 定位 BMKLocationManager 类
 @param location 定位结果，参考BMKLocation
 @param error 错误信息。
 */
- (void)BMKLocationManager:(BMKLocationManager *)manager didUpdateLocation:(BMKLocation *)location orError:(NSError *)error {
    
    if (error) {
        NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
    }
    if (!location) {
        return;
    }
    //105.585047,29.401702
    //    CLLocation *locCQ = [[CLLocation alloc]initWithLatitude:105.585047 longitude:29.401702];
    //    [location setValue:locCQ forKey:@"location"];
    
    self.userLocation.location = location.location;
    NSLog(@"---%f %f",location.location.coordinate.latitude,location.location.coordinate.longitude);
    //实现该方法，否则定位图标不出现
    [_mapView updateLocationData:self.userLocation];
}


#pragma mark - Lazy loading
- (BMKLocationManager *)locationManager {
    if (!_locationManager) {
        //初始化BMKLocationManager类的实例
        _locationManager = [[BMKLocationManager alloc] init];
        //设置定位管理类实例的代理
        _locationManager.delegate = self;
        //设定定位坐标系类型，默认为 BMKLocationCoordinateTypeGCJ02
        _locationManager.coordinateType = BMKLocationCoordinateTypeBMK09LL;
        //设定定位精度，默认为 kCLLocationAccuracyBest
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        //设定定位类型，默认为 CLActivityTypeAutomotiveNavigation
        _locationManager.activityType = CLActivityTypeAutomotiveNavigation;
        //指定定位是否会被系统自动暂停，默认为NO
        _locationManager.pausesLocationUpdatesAutomatically = NO;
        /**
         是否允许后台定位，默认为NO。只在iOS 9.0及之后起作用。
         设置为YES的时候必须保证 Background Modes 中的 Location updates 处于选中状态，否则会抛出异常。
         由于iOS系统限制，需要在定位未开始之前或定位停止之后，修改该属性的值才会有效果。
         */
        _locationManager.allowsBackgroundLocationUpdates = NO;
        /**
         指定单次定位超时时间,默认为10s，最小值是2s。注意单次定位请求前设置。
         注意: 单次定位超时时间从确定了定位权限(非kCLAuthorizationStatusNotDetermined状态)
         后开始计算。
         */
        _locationManager.locationTimeout = 10;
    }
    return _locationManager;
}


- (BMKUserLocation *)userLocation {
    if (!_userLocation) {
        //初始化BMKUserLocation类的实例
        _userLocation = [[BMKUserLocation alloc] init];
    }
    return _userLocation;
}


//设置标注样式
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        BMKPinAnnotationView*annotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil) {
            annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.pinColor = BMKPinAnnotationColorRed;
        annotationView.canShowCallout= YES;      //设置气泡可以弹出，默认为NO
        annotationView.animatesDrop=YES;         //设置标注动画显示，默认为NO
        annotationView.draggable = YES;          //设置标注可以拖动，默认为NO
        return annotationView;
    }
    return nil;
}


- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{
    NSLog(@"----%@",view.annotation.title);
    self.seletedAnnotation = view;
}

- (void)addCustomGestures {
    /*
     *注意：
     *添加自定义手势时，必须设置UIGestureRecognizer的属性cancelsTouchesInView 和 delaysTouchesEnded 为NO,
     *否则影响地图内部的手势处理
     */
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTap.delegate = self;
    doubleTap.numberOfTapsRequired = 2;
    doubleTap.cancelsTouchesInView = NO;
    doubleTap.delaysTouchesEnded = NO;
    [self.view addGestureRecognizer:doubleTap];
    
}

//双击事件  添加地点
- (void)handleDoubleTap:(UITapGestureRecognizer *)theDoubleTap {
    
    
    NSString *title = self.seletedAnnotation.annotation.title;
    
    SiteModel *selectedModel = nil;
    for (SiteModel *model in [DataManager sharedManager].preparedModels) {
        if ([title isEqualToString:model.siteName]) {
            selectedModel = model;
            break;
        }
    }
    //判断地点是否可添加
    if (![[DataManager sharedManager].sitesArray containsObject:selectedModel] && selectedModel!=nil) {
        [[XLActionViewController showAlertControllerWithType:AlertTypeAddSite AndName:[NSString stringWithFormat:@"是否添加地点：%@",title]] setSureblock:^(NSString *text) {
            [[DataManager sharedManager].preparedModels removeObject:selectedModel];
            NSArray *temp = [DataManager sharedManager].sitesArray;
            [DataManager sharedManager].sitesArray = [NSMutableArray array];
            [[DataManager sharedManager].sitesArray addObject:selectedModel];
            [[DataManager sharedManager].sitesArray addObjectsFromArray:temp];
            NSLog(@"%@",[DataManager sharedManager].sitesArray);
            self.sureBlock();
            
            [Factory popToRootViewControllerFrom:self];
            
        }];
    }
}


-(void)initAnnotations{
    BMKPointAnnotation* annotation1 = [[BMKPointAnnotation alloc]init];
    annotation1.coordinate = CLLocationCoordinate2DMake(29.402702,105.585357);
    //设置标注的标题
    annotation1.title = @"食堂";
    [_mapView addAnnotation:annotation1];
    
    BMKPointAnnotation* annotation2 = [[BMKPointAnnotation alloc]init];
    annotation2.coordinate = CLLocationCoordinate2DMake(29.403512,105.586357);
    //设置标注的标题
    annotation2.title = @"二教";
    [_mapView addAnnotation:annotation2];
    
    
    BMKPointAnnotation* annotation3 = [[BMKPointAnnotation alloc]init];
    annotation3.coordinate = CLLocationCoordinate2DMake(29.402562,105.586057);
    //设置标注的标题
    annotation3.title = @"图书馆";
    [_mapView addAnnotation:annotation3];
}
@end
