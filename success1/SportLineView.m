//
//  SportLineView.m
//  动态折线图
//
//  Created by 王方定 on 2019/11/6.
//  Copyright © 2019年 任璇璇. All rights reserved.
//

#import "SportLineView.h"
#import <AudioToolbox/AudioToolbox.h>
#import "PaoPaoView.h"
#import "SiteModel.h"

static CGRect myFrame;
static int count;   // 点个数，x轴格子数
static int yCount;  // y轴格子数
static CGFloat everyX;  // x轴每个格子宽度
static CGFloat everyY;  // y轴每个格子高度
static CGFloat maxY;    // 最大的y值
static CGFloat allH;    // 整个图表高度
static CGFloat allW;    // 整个图表宽度
static NSInteger flag = 1;
#define kMargin 30

@interface SportLineView ()
@property (strong, nonatomic) NSMutableArray *xLabels;
@property (nonatomic, strong) UIBezierPath *path;
@property (nonatomic, strong) UIScrollView *layerScrollView;
@property (nonatomic, assign) CGFloat limtNumber;//阈值


@end

@implementation SportLineView

+ (instancetype)lineChartViewWithFrame:(CGRect)frame{
    //SportLineView *lineChartView = [[NSBundle mainBundle] loadNibNamed:@"SportLineView" owner:self options:nil].lastObject;
    SportLineView *lineChartView = [[SportLineView alloc] initWithFrame:frame];
    lineChartView.frame = frame;
    myFrame = frame;
    
    return lineChartView;
}

#pragma mark - 计算

- (void)doWithCalculate{
    if (!self.xValues || !self.xValues.count || !self.yValues || !self.yValues.count) {
        return;
    }
    // 移除多余的值，计算点个数
    if (self.xValues.count > self.yValues.count) {
        NSMutableArray * xArr = [self.xValues mutableCopy];
        for (int i = 0; i < self.xValues.count - self.yValues.count; i++){
            [xArr removeLastObject];
        }
        self.xValues = [xArr mutableCopy];
    }else if (self.xValues.count < self.yValues.count){
        NSMutableArray * yArr = [self.yValues mutableCopy];
        for (int i = 0; i < self.yValues.count - self.xValues.count; i++){
            [yArr removeLastObject];
        }
        self.yValues = [yArr mutableCopy];
    }
    
    count = (int)self.xValues.count;
    
    everyX = (CGFloat)(CGRectGetWidth(myFrame) - kMargin * 2) / count;
    
    // y轴最多分5部分
    yCount = count <= 10 ? count : 10;
    
    everyY =  (CGRectGetHeight(myFrame) - kMargin * 2) / yCount;
    
    maxY = CGFLOAT_MIN;
    for (int i = 0; i < count; i ++) {
        if ([self.yValues[i] floatValue] > maxY) {
            maxY = [self.yValues[i] floatValue];
        }
    }
    
    allH = CGRectGetHeight(myFrame) - kMargin * 2;
    allW = CGRectGetWidth(myFrame) - kMargin * 2;
}

#pragma mark - 添加折线图的背景滚动图
- (void)addBGScorllView{
    self.layerScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(kMargin, kMargin, allW, allH)];
    _layerScrollView.backgroundColor = [UIColor clearColor];
    _layerScrollView.contentSize = CGSizeMake(10000, allH);
    _layerScrollView.bounces = NO;
    _layerScrollView.delaysContentTouches = NO;
    _layerScrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_layerScrollView];
    
    /*
    UIBezierPath *path = [UIBezierPath bezierPath];

    [path moveToPoint:CGPointMake(kMargin, kMargin / 2.0 - 5)];

    [path addLineToPoint:CGPointMake(kMargin, CGRectGetHeight(myFrame) - kMargin)];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(myFrame) - kMargin / 2.0 + 5, CGRectGetHeight(myFrame) - kMargin)];
    
    // 加箭头
    [path moveToPoint:CGPointMake(kMargin - 5, kMargin/ 2.0 + 4)];
    [path addLineToPoint:CGPointMake(kMargin, kMargin / 2.0 - 4)];
    [path addLineToPoint:CGPointMake(kMargin + 5, kMargin/ 2.0 + 4)];

    [path moveToPoint:CGPointMake(CGRectGetWidth(myFrame) - kMargin / 2.0 - 4, CGRectGetHeight(myFrame) - kMargin - 5)];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(myFrame) - kMargin / 2.0 + 5, CGRectGetHeight(myFrame) - kMargin)];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(myFrame) - kMargin / 2.0 - 4, CGRectGetHeight(myFrame) - kMargin + 5)];
    
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.path = path.CGPath;
    layer.strokeColor = [UIColor lightGrayColor].CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.lineWidth = 1.0;
    
    [self.layer addSublayer:layer];
    */
}

#pragma mark - 添加label
- (void)drawLabels{
    //Y轴
    for(int i = 0; i <= yCount; i ++){
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, kMargin  + everyY * i - everyY / 2, kMargin - 1, everyY)];
        lbl.textColor = [UIColor grayColor];
        lbl.font = [UIFont systemFontOfSize:10];
        lbl.textAlignment = NSTextAlignmentCenter;
        
        lbl.text = [NSString stringWithFormat:@"%d", (int)(maxY / yCount * (yCount - i)) ];
        
        [self addSubview:lbl];
    }
    
    /*
    // X轴
    for(int i = 1; i <= count; i ++){
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(kMargin + everyX * i - everyX / 2, CGRectGetHeight(myFrame) - kMargin, everyX, kMargin)];

        lbl.textColor = [UIColor grayColor];
        lbl.font = [UIFont systemFontOfSize:12];
        lbl.textAlignment = NSTextAlignmentCenter;

        [self.xLabels addObject:lbl];
        // 如果起点不是0,计算横轴的坐标值
        NSValue *pointObj = [self.pointArray lastObject];
        CGPoint pointRestored = [pointObj CGPointValue];

        CGFloat maxX = pointRestored.x;
        int maxValueX = (int)maxX;
        CGFloat xfloat = maxX - maxValueX;
        if (xfloat > 0) {
            maxValueX += 1;
        }

        //        NSValue *firstPointObj = [self.pointArray firstObject];
        //        CGPoint firstPointRestored = [firstPointObj CGPointValue];

        if (maxValueX <= count) {
            lbl.text = [NSString stringWithFormat:@"%@", self.xValues[i - 1]];
        }else{
            lbl.text = [NSString stringWithFormat:@"%d", maxValueX - count + i];
        }

        [self addSubview:lbl];
    }
    */
}

#pragma mark - 画网格
- (void)drawLines{
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    // 横线
    for (int i = 0; i < yCount+1; i ++) {
        [path moveToPoint:CGPointMake(0 , everyY * i)];
        [path addLineToPoint:CGPointMake(_layerScrollView.contentSize.width , everyY * i)];
    }
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.path = path.CGPath;
    layer.strokeColor = [UIColor lightGrayColor].CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.lineWidth = 0.5;
    [self.layerScrollView.layer addSublayer:layer];
    
    //限制线
    UIBezierPath *bpath = [UIBezierPath bezierPath];
    [bpath moveToPoint:CGPointMake(0 , everyY * (maxY-[self.model.threshold floatValue])/yCount)];
    [bpath addLineToPoint:CGPointMake(_layerScrollView.contentSize.width , everyY * 2)];
    
    CAShapeLayer *limlayer = [[CAShapeLayer alloc] init];
    limlayer.path = bpath.CGPath;
    limlayer.strokeColor = [UIColor redColor].CGColor;
    limlayer.fillColor = [UIColor clearColor].CGColor;
    limlayer.lineDashPattern = @[@(5),@(5)];
    [self.layerScrollView.layer addSublayer:limlayer];
}

#pragma mark - 整合 画图表
- (void)drawChartWithLineChart{
    // 计算赋值
    [self doWithCalculate];
    
    // 添加折线图背景滚动视图
    [self addBGScorllView];
    
    // 画网格线
    if (self.isShowLine) {
        [self drawLines];
    }
    
    // 添加坐标轴label
    [self drawLabels];
    
    //NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(drawFoldLineWithLineChart) object:nil];
    //[thread start];
}

#pragma mark - 画折线\曲线 画填充颜色
- (void)drawFoldLineWithLineChart{
    //初始化一条path
    self.path = [UIBezierPath bezierPath];
    //x轴宽度
    CGFloat Xwidth = (CGFloat)(CGRectGetWidth(myFrame) - kMargin * 2);
    //数组中点的个数
    NSInteger number = self.pointArray.count;
    //当数组中的点数>=2时才能开始画线
    if (self.pointArray.count >= 2) {
        
        //从数组中取出起点
        NSValue *startPoint = self.pointArray[number-2];
        CGPoint point1 = [startPoint CGPointValue];
        CGFloat x1 = point1.x;
        CGFloat y1 = point1.y;
        
        //从数组中取出第二个点
        NSValue *endPoint = self.pointArray[number-1];
        CGPoint point2 = [endPoint CGPointValue];
        CGFloat x2 = point2.x;
        CGFloat y2 = point2.y;
        //NSLog(@"%@ %@",startPoint,endPoint);
        
        //判断后一个点是否超出限制线
        if (y2>[self.model.threshold floatValue]) {
            //报警
            [self overLimit];
        }
        
        if (x1 >= count) {
            _layerScrollView.contentOffset = CGPointMake(flag*Xwidth/count, 0);
            flag++;
        }
        
        //线路径
        [_path moveToPoint:CGPointMake(x1*Xwidth/count, (1 - y1 / maxY) * allH)];
        [_path addLineToPoint:CGPointMake(x2*Xwidth/count, (1 - y2 / maxY) * allH)];
    
        //填充图形路径
        UIBezierPath *bpath = [UIBezierPath bezierPath];
        [bpath moveToPoint:CGPointMake(x1*Xwidth/count, allH)];
        [bpath moveToPoint:CGPointMake(x1*Xwidth/count, (1 - y1 / maxY) * allH)];
        [bpath addLineToPoint:CGPointMake(x2*Xwidth/count, (1 - y2 / maxY) * allH)];
        [bpath addLineToPoint:CGPointMake(x2*Xwidth/count, allH)];
        [bpath addLineToPoint:CGPointMake(x1*Xwidth/count, allH)];
        
        //线图层
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        layer.path = _path.CGPath;
        layer.strokeColor = NAVIGATIONBAR_COLOR.CGColor;
        layer.fillColor = [UIColor clearColor].CGColor;
        layer.lineWidth = 3;
        [self.layerScrollView.layer addSublayer:layer];
        
        //填充图形图层
        CAShapeLayer *filllayer = [[CAShapeLayer alloc] init];
        filllayer.path = bpath.CGPath;
        filllayer.strokeColor = [UIColor clearColor].CGColor;
        filllayer.fillColor = [UIColor colorWithRed:255/255.0 green:246/255.0 blue:143/255.0 alpha:0.5].CGColor;
        [self.layerScrollView.layer addSublayer:filllayer];
        
        //给图层添加动画
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        
        animation.duration = 1.;// 持续时间
        animation.fromValue = @(0); // 从 0 开始
        animation.toValue = @(1);   // 到 1 结束
        // 保持动画结束时的状态
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        // 动画匀速
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        [layer addAnimation:animation forKey:@"strokeEnd"];
        
        CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"opacity"];
        
        animation1.duration = 1;// 持续时间
        animation1.fromValue = @(0); // 从 0 开始
        animation1.toValue = @(1);   // 到 1 结束
        // 保持动画结束时的状态
        animation1.removedOnCompletion = NO;
        animation1.fillMode = kCAFillModeForwards;
        // 动画匀速
        animation1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        [filllayer addAnimation:animation1 forKey:@"opacity"];
    }
}

//报警
- (void)overLimit{
    //1.获取音频文件的路径
    NSString *path = [[NSBundle mainBundle] pathForResource:@"belling.mp3" ofType:nil];
    
    //2.将字符串的路劲转化为NSURL的格式
    NSURL *url = [NSURL fileURLWithPath:path];
    //NSLog(@"%@", url);
    
    //3.获取系统为这个音效分配的id
    SystemSoundID soundID;
    
    AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(url), &soundID);
    
    //播放SystemSoundID对应的音频文件
    AudioServicesPlaySystemSound(soundID);
}

// 更新折线图, X轴坐标
- (void)exchangeLineAnyTime{
    // 计算赋值
    //[self doWithCalculate];
    
    //NSLog(@"exchangeLineAnyTime");
    //NSLog(@"*****%@",self.pointArray);
    
//    NSArray *layers = [self.layer.sublayers mutableCopy];
//    
//    for (CAShapeLayer *layer in layers) {
//        [layer removeFromSuperlayer];
//    }
    //NSLog(@"%@",layers);
    //[self drawChartWithLineChart];
    // 画折线
    [self drawFoldLineWithLineChart];
    
    //[self exchangeXlabels];
}

#pragma mark -- 懒加载
- (NSMutableArray *)pointArray{
    if (!_pointArray) {
        _pointArray = [NSMutableArray array];
    }
    return _pointArray;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"1111");
    UITouch *t = [touches anyObject];
    CGPoint location = [t locationInView:self.layerScrollView];
    CGPoint relativePoint = CGPointMake((int)((int)location.x*count/allW), (int)((1 -location.y/allH)*maxY));
    NSValue *pointValue = [NSValue valueWithCGPoint:relativePoint];
    NSLog(@"%@",pointValue);
    //判断位置
    BOOL isContain = [self.pointArray containsObject:pointValue];
    if (isContain) {
        //包含 显示泡泡
        NSLog(@"1121");
        PaoPaoView *pView = [[PaoPaoView alloc] initWithFrame:CGRectMake(location.x, location.y-15, 50, 30)];
        NSString *title = [NSString stringWithFormat:@"%g",relativePoint.y];
        NSLog(@"------%@",title);
        pView.title = title;
        [self.layerScrollView addSubview:pView];
        
//        //画竖线
//        UIBezierPath *path = [UIBezierPath bezierPath];
//        [path moveToPoint:CGPointMake(location.x, 0)];
//        [path moveToPoint:CGPointMake(location.x, allH)];
//        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
//        layer.path = path.CGPath;
//        layer.strokeColor = [UIColor orangeColor].CGColor;
//        layer.fillColor = [UIColor clearColor].CGColor;
//        [self.layerScrollView.layer addSublayer:layer];
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    
}
@end
