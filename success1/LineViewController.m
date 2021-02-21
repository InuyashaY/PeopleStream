//
//  LineViewController.m
//  success1
//
//  Created by 王方定 on 2019/11/9.
//  Copyright © 2019年 Inuyasha. All rights reserved.
//

#import "LineViewController.h"
#import "SportLineView.h"
#import "SiteModel.h"
#import "DataManager.h"
#import "MoreView.h"
#import "FCWR_DataCenter.h"


@interface LineViewController ()
@property (nonatomic, strong) SportLineView *LCView;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) SiteModel *indexModel;
@property (nonatomic, strong) MoreView *moreView;

@end

@implementation LineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = BACKBUTTON_COLOR;
    self.view.backgroundColor = [UIColor whiteColor];
    self.indexModel = [DataManager sharedManager].sitesArray[_index];
    //NSLog(@"%@",_indexModel.siteName);
    NSString *siteName = _indexModel.siteName;
    
    //设置导航栏标题为地点
    self.navigationItem.title = [siteName stringByAppendingString:@"人流数"];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:NAVIGATION_TITLE_FONT forKey:NSFontAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    //设置导航栏b=右边按钮为更多 查看视频 更改阈值
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"more"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(moreBtnDidClicked)];
    
    self.LCView = [SportLineView lineChartViewWithFrame:CGRectMake(0, 150, self.view.frame.size.width, 400)];
    [self.LCView setModel:self.indexModel];
    _LCView.xValues = @[@1, @2, @3, @4, @5, @6, @7,@8, @9, @10];
    _LCView.yValues = @[@10, @20, @30, @40, @50,@60, @70, @80,@90, @100];
    _LCView.isShowLine = YES;
    [_LCView drawChartWithLineChart];
    [self.view addSubview:_LCView];
    
    static CGFloat x = 0.0;
    static CGFloat y = 0.0;
    static int i = 0;
    static int j = 0;
    dispatch_queue_t scheduleQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
    dispatch_async(scheduleQueue, ^{
        while (TRUE) {
            
            // 每隔5秒执行一次（当前线程阻塞5秒）
            [NSThread sleepForTimeInterval:1];
            //测试数据
            [[FCWR_DataCenter defaultDataCenter] getLatestPersonNumberDataWith:@"loc_4" handle:^(NSMutableArray *info) {
                NSLog(@"---------------当前的数据是：%@",[info.firstObject objectForKey:@"f_count"]);
                y = [[info.firstObject objectForKey:@"f_count"] floatValue];
            }];
            x = i;
            //y = arc4random_uniform(101);
            i++;
            CGPoint point = CGPointMake(x, y);
            NSValue *pointObj = [NSValue valueWithCGPoint:point];
            [self.LCView.pointArray addObject:pointObj];
            //NSLog(@"%@",self.LCView.pointArray);
            
            //更新UI转到主线程
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self.LCView exchangeLineAnyTime];
            }];
            j++;
//            if (j == 5) {
//                //终止进程
//                dispatch_group_notify(scheduleQueue, <#dispatch_queue_t  _Nonnull queue#>, <#^(void)block#>)
//            }
            
        };
    });
}

//更多按钮被点 添加查看视频和更改阈值视图
- (void)moreBtnDidClicked{
    self.moreView = [[MoreView alloc] initWithFrame:CGRectMake(230, 10, 120, 90)];
    [self.moreView setModel:self.indexModel];
    [self.view addSubview:_moreView];
    //self.moreView.center = CGPointMake(_moreView.frame.origin.x+_moreView.frame.size.width, _moreView.frame.origin.y);
    self.moreView.transform = CGAffineTransformMakeScale(0, 0.1f);
    [UIView animateWithDuration:0.2f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.moreView.transform = CGAffineTransformMakeScale(1.09f, 1.05f);
        self.moreView.alpha = 1.f;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.08f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.moreView.transform = CGAffineTransformIdentity;
        } completion:nil];
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(valueChanged:) name:@"notification" object:nil];
}

- (void)valueChanged:(NSNotification *)notification{
    // object 就是传过来的参数
    NSLog(@"%@",self.LCView.model.threshold);
    
    [self.LCView layoutSubviews];
}

- (void)indexWithArea:(NSInteger)index{
    //保存d传过来的model是第几个
    self.index = index;
}

@end
