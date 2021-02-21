//
//  SportLineView.h
//  动态折线图
//
//  Created by 王方定 on 2019/11/6.
//  Copyright © 2019年 任璇璇. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SiteModel;
NS_ASSUME_NONNULL_BEGIN

@interface SportLineView : UIView

// x轴值
@property (nonatomic, copy) NSArray *xValues;
// y轴值
@property (nonatomic, copy) NSArray *yValues;
// 绘图数组
@property (strong, nonatomic) NSMutableArray *pointArray;
// 是否显示方格
@property (nonatomic, assign) bool isShowLine;
//点否可以点击弹出泡泡
@property (nonatomic,assign) BOOL isSelect;
//气泡是否根据折线位置可以浮动，默认不可以
@property (nonatomic,assign)BOOL isFloating;
//对应的地点
@property (strong , nonatomic) SiteModel *model;


// 初始化折线图所在视图
+ (instancetype)lineChartViewWithFrame:(CGRect)frame;
// 画图表
- (void)drawChartWithLineChart;
// 即时更新折线图
- (void)exchangeLineAnyTime;

@end

NS_ASSUME_NONNULL_END
