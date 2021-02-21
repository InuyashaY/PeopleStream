//
//  suspendedButton.m
//  suspendButton
//
//  Created by wf on 16/8/18.
//  Copyright © 2016年 YJ. All rights reserved.
//

#import "suspendedButton.h"
#define BUTTON_AVAILABLE @"BUTTONAVAILABLE"
#define listH 280
//3*(60+20)+10
#define listViewWidth 250

@interface suspendedButton ()<UITextViewDelegate>
{
    BOOL _isShowingButtonList;
    BOOL _isOnLeft;
    BOOL _isBackUp;
    BOOL _isTest;
    CGPoint _tempCenter;
    CGPoint _originalPosition;
    CGRect _windowSize;
    UIView *_buttonListView;//按钮和打分的View
    UILabel *defLabel;//按钮和打分的View的默认提示的lable
    UIView *_askQuestionListView;//点击提问弹出的View
    UILabel *askQuestionDefLabel;//点击提问弹出的View的默认提示的lable
    UIButton * addPicBtn;//添加图片按钮
    UIButton * addPicBtnDelete;//添加图片按钮右上角删除按钮
    UILabel * addPicLable;//提示添加图片的lable
    UIButton * goBackBtn;//返回按钮
    UIView * askQuestionBackView;//带边框的View
    UIButton * submitBtnButtonListView;//buttonListView中的提交按钮
    UIButton * submitBtnAskQuestionListView;//_askQuestionListView中的提交按钮
    UITextView *askQuestionInPut;//_askQuestionListView中的输入框
    
    UIImageView * dottedImageView;//虚线
    //按钮的个数
    NSUInteger numOfButton;

}

@property (nonatomic,strong) UIView *buttonListView;
//@property (nonatomic,strong) UIView *baseView;
//@property (nonatomic,strong) UIView * myBackView;
@property (nonatomic,strong) UIView *askQuestionListView;
@property (nonatomic,strong) YQFiveStarView *starView;
@end


@implementation suspendedButton

@synthesize buttonListView = _buttonListView;
@synthesize baseView = _baseView;
@synthesize myBackView = _myBackView;
@synthesize askQuestionListView = _askQuestionListView;

static suspendedButton *_instance = nil;

#pragma mark - 继承方法
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _isShowingButtonList = NO;
        //_isBackUp = NO;
        //self.hidden = YES;
        //_isTest = NO;
        //[self httpRequest];
        
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //NSLog(@"touchBegan");
    
    _originalPosition = [[touches anyObject] locationInView:self];
    _tempCenter = self.center;
    
//    self.backgroundColor = [UIColor greenColor];//移动过程中的颜色
    
    CGAffineTransform toBig = CGAffineTransformMakeScale(1.2, 1.2);//变大
    
    [UIView animateWithDuration:0.1 animations:^{
        // Translate bigger
        self.transform = toBig;
        
    } completion:^(BOOL finished)   {}];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    //NSLog(@"touchMove");
    
    CGPoint currentPosition = [[touches anyObject] locationInView:self];
    float detaX = currentPosition.x - _originalPosition.x;
    float detaY = currentPosition.y - _originalPosition.y;
    
    CGPoint targetPositionSelf = self.center;
    CGPoint targetPositionButtonList = _buttonListView.center;
    targetPositionSelf.x += detaX;
    targetPositionSelf.y += detaY;
    targetPositionButtonList.x += detaX;
    targetPositionButtonList.y += detaY;
    
    self.center = targetPositionSelf;
    //修改，让_buttonListView.center不跟着button移动
//    _buttonListView.center = targetPositionButtonList;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    //NSLog(@"touchCancell");
    
    // 触发touchBegan后，tap手势被识别后会将touchMove和touchEnd的事件截取掉触发自身手势回调，然后运行touchCancell。touchBegan中设置的按钮状态在touchEnd和按钮触发方法两者中分别设置还原。
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //NSLog(@"touchEnd");
    
    CGAffineTransform toNormal = CGAffineTransformTranslate(CGAffineTransformIdentity, 1/1.2, 1/1.2);
    CGPoint newPosition = [self correctPosition:self.frame.origin];
    
    [UIView animateWithDuration:0.1 animations:^{
        
        // Translate normal
        self.transform = toNormal;
        self.backgroundColor = GWMColor(0, 145, 208);
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.4 animations:^{
            self.frame = CGRectMake(newPosition.x, newPosition.y, self.bounds.size.width, self.bounds.size.height);
//            [self adjustButtonListView];
        }];
        
    }];
}

#pragma mark-----提交按钮

-(void)submitBtnButtonListViewClicked
{
    NSLog(@"第一页提交按钮");
    if ([self.sendDelegate respondsToSelector:@selector(submit)]) {
        [self.sendDelegate submit];
    }
}

-(void)submitBtnAskQuestionListViewClicked
{
    NSLog(@"第二页提交按钮");
    if ([self.sendDelegate respondsToSelector:@selector(submit)]) {
        [self.sendDelegate submit];
    }
}

/*
#pragma mark-----提问
//-(void)askQuestionClicked
//{
//    _buttonListView.hidden=YES;
//    [_instance setupAskQuestionView];
//}

-(void)setupAskQuestionView
{
    _askQuestionListView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, listViewWidth, 220)];
    _askQuestionListView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1.0];//按钮列表背景色
    _askQuestionListView.layer.cornerRadius = 10;
    //修改，让_buttonListView居中
    _askQuestionListView.center =_baseView.center;
    [_baseView addSubview:_askQuestionListView];
    
    [self setupAskQuestionViewSubViews];
}

//子视图
-(void)setupAskQuestionViewSubViews
{
    //带边框的View
    askQuestionBackView =[[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(dottedImageView.frame)+15, listViewWidth-20, 150)];
    askQuestionBackView.backgroundColor=[UIColor whiteColor];
    askQuestionBackView.layer.cornerRadius=5;
    askQuestionBackView.layer.borderWidth=1;
    askQuestionBackView.layer.borderColor=[[UIColor blackColor] CGColor];
    [_buttonListView addSubview:askQuestionBackView];
    
    //输入框
    askQuestionInPut=[[UITextView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(dottedImageView.frame)+20, listViewWidth-30, 200-10-60-60)];
    askQuestionInPut.delegate=self;
    if (askQuestionDefLabel) {
        [askQuestionDefLabel removeFromSuperview];
        askQuestionDefLabel=nil;
    }
    askQuestionDefLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 20)];
    askQuestionDefLabel.enabled = NO;
    askQuestionDefLabel.text = @"请输入提问内容";
    askQuestionDefLabel.font =  [UIFont systemFontOfSize:13];
    askQuestionDefLabel.textColor=[UIColor colorWithRed:199/255.0 green:199/255.0 blue:205/255.0 alpha:1.0];
    [askQuestionInPut addSubview:askQuestionDefLabel];
    [_buttonListView addSubview:askQuestionInPut];
    self.askQuestionInPutText=askQuestionInPut;

    //添加照片按钮
    addPicBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    addPicBtn.frame=CGRectMake(20, CGRectGetMaxY(askQuestionInPut.frame)+10, 50, 50);
    [addPicBtn setImage:[UIImage imageNamed:@"addPicture"] forState:UIControlStateNormal];
    addPicBtn.layer.cornerRadius=5;
    [addPicBtn addTarget:self action:@selector(addPicture) forControlEvents:UIControlEventTouchUpInside];
    addPicBtn.adjustsImageWhenHighlighted = NO;
    [_buttonListView addSubview:addPicBtn];
    
    //添加照片按钮右上角的红色按钮
    addPicBtnDelete=[UIButton buttonWithType:UIButtonTypeCustom];
    addPicBtnDelete.frame=CGRectMake(CGRectGetMaxX(addPicBtn.frame)-10, CGRectGetMaxY(askQuestionInPut.frame), 20, 20);
    [addPicBtnDelete setImage:[UIImage imageNamed:@"addPicBtnDelete"] forState:UIControlStateNormal];
    [addPicBtnDelete addTarget:self action:@selector(addPictureDelete) forControlEvents:UIControlEventTouchUpInside];
    addPicBtnDelete.adjustsImageWhenHighlighted = NO;
    [_buttonListView addSubview:addPicBtnDelete];
    
    //添加图片的提示lable
    addPicLable=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(addPicBtn.frame)+5, CGRectGetMaxY(askQuestionInPut.frame)+5+20, 100, 20)];
    addPicLable.enabled = NO;
    addPicLable.text = @"添加图片";
    addPicLable.font =  [UIFont systemFontOfSize:13];
    addPicLable.textColor=[UIColor colorWithRed:199/255.0 green:199/255.0 blue:205/255.0 alpha:1.0];
    [_buttonListView addSubview:addPicLable];

    
//    //返回按钮
//    goBackBtn =[UIButton buttonWithType:UIButtonTypeCustom];
//    goBackBtn.frame=CGRectMake(20, CGRectGetMaxY(askQuestionBackView.frame)+15, 30, 30);
//    [goBackBtn setImage:[UIImage imageNamed:@"gobackToList"] forState:UIControlStateNormal];
//    goBackBtn.layer.cornerRadius=5;
//    [goBackBtn addTarget:self action:@selector(gobackToListBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//    goBackBtn.adjustsImageWhenHighlighted = NO;
//    [_askQuestionListView addSubview:goBackBtn];
//    
//    //提交按钮
//    submitBtnAskQuestionListView =[UIButton buttonWithType:UIButtonTypeCustom];
//    submitBtnAskQuestionListView.frame=CGRectMake(_buttonListView.frame.size.width-60-10, CGRectGetMaxY(askQuestionBackView.frame)+10, 60, 40);
//    [submitBtnAskQuestionListView addTarget:self action:@selector(submitBtnAskQuestionListViewClicked) forControlEvents:UIControlEventTouchUpInside];
//    [submitBtnAskQuestionListView setTitle:@"提交" forState:UIControlStateNormal];
//    submitBtnAskQuestionListView.titleLabel.font=[UIFont systemFontOfSize:15];
//    submitBtnAskQuestionListView.layer.cornerRadius=20;
//    //设置背景色
//    [submitBtnAskQuestionListView setBackgroundColor:[UIColor redColor]];
//    //    [submitBtnAskQuestionListView setBackgroundColor:<#(UIColor * _Nullable)#>];
//    [_askQuestionListView addSubview:submitBtnAskQuestionListView];

    
}

//返回按钮事件
-(void)gobackToListBtnClicked
{
    if (_askQuestionListView) {
        [_askQuestionListView removeFromSuperview];
        _askQuestionListView=nil;
    }
    _buttonListView.hidden=NO;
    
}

//跳转相机
-(void)addPicture
{
    //通知去跳转
    NSLog(@"去跳转");
    if ([self.sendDelegate respondsToSelector:@selector(goToChoosePicture)]) {
        [self.sendDelegate goToChoosePicture];
    }
}

//图片删除事件
-(void)addPictureDelete
{
    [addPicBtn setImage:[UIImage imageNamed:@"addPicture"] forState:UIControlStateNormal];
    addPicBtnDelete.hidden=YES;
    addPicLable.hidden=NO;
}
 
 */

#pragma mark - 类方法
+ (suspendedButton *)suspendedButtonWithCGPoint:(CGPoint)pos inView:(UIView *)baseview
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[suspendedButton alloc] initWithCGPoint:pos];
        _instance.baseView = baseview;
        //背景view
//        [_instance configBackView];
        
        [_instance constructUI];
        [baseview addSubview:_instance];
    });
    
    return _instance;
}

-(void)configBackView
{
    _myBackView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height)];
    _myBackView.backgroundColor=[UIColor blackColor];
    _myBackView.alpha=0.4;
    _myBackView.userInteractionEnabled=YES;
    _myBackView.hidden=YES;
    [_baseView addSubview:_myBackView];
}

+ (void)deleteSuspendedButton
{
    [_instance removeFromSuperview];
}

#pragma mark - 辅助方法
- (id)initWithCGPoint:(CGPoint)pos
{
    AppDelegate *appdel=[UIApplication sharedApplication].delegate;
    _windowSize = appdel.window.frame; //封装了获取屏幕Size的方法
    
    CGPoint newPosition = [self correctPosition:pos];
    
    return [self initWithFrame:CGRectMake(newPosition.x, newPosition.y, 60, 60)];
}

- (CGPoint)correctPosition:(CGPoint)pos
{
    CGPoint newPosition;
    
    if ((pos.x + 60 > _windowSize.size.width) || (pos.x > _windowSize.size.width/2-30)) {
        newPosition.x = _windowSize.size.width - 60 -10;
        _isOnLeft = NO;
    } else {
        newPosition.x = 10;
        _isOnLeft = YES;
    }
    
    (pos.y + 60 > _windowSize.size.height)?(newPosition.y = _windowSize.size.height - 60 -10):((pos.y < 0)?newPosition.y = 10:(newPosition.y = pos.y));
    
    return newPosition;
}

- (void)constructUI
{
    self.backgroundColor = GWMColor(0, 145, 208);
    self.alpha = 1.0;
    self.layer.cornerRadius = 30;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tiggerButtonList)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tap];
    
//    //按钮的个数
//    numOfButton = 2;
////    listViewWidth =3*(60+20)+10;
//    self.buttonListView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, listViewWidth, listH)];
//    _buttonListView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1.0];//按钮列表背景色
//    _buttonListView.alpha = 0;
//    _buttonListView.layer.cornerRadius = 10;
//    
//    [self createButtonByNumber:numOfButton withSize:CGSizeMake(60, 60) inView:(UIView *)_buttonListView];
//    _buttonListView.hidden = YES;
//    
//    //修改，让_buttonListView居中
//    _buttonListView.center =_baseView.center;
//    
//    [_baseView addSubview:_buttonListView];

}

- (void)createButtonByNumber:(NSUInteger)number withSize:(CGSize)size inView:(UIView *)view
{
    
    NSArray * picArray=@[@"pushHand",@"speakFast"];
    NSArray * titleArray=@[GWMString(@"local_pushHandEasy"),GWMString(@"local_speakFastEasy")];

    //子按钮的UI效果自定义
    for (NSUInteger i = 0; i < number; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake((250/3-40) + i*(size.width+(250/3-40)), 15, size.width, size.height);
        CALayer *layer=[button layer];
        layer.cornerRadius=20;
        layer.masksToBounds=YES;
        [button setImage:[UIImage imageNamed:picArray[i]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(optionsButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i + 2000;
        [view addSubview:button];
        
        UILabel * lable=[[UILabel alloc]initWithFrame:CGRectMake((250/3-40) + i*(size.width+(250/3-40)), CGRectGetMaxY(button.frame)+3, size.width, 21)];
        lable.textAlignment=NSTextAlignmentCenter;
        lable.text=titleArray[i];
        lable.font=[UIFont systemFontOfSize:13];
        [view addSubview:lable];
        
    }
    //虚线
    [self layoutLines];

//    YQFiveStarView *starView = [[YQFiveStarView alloc]initWithFrame:CGRectMake(10,35+65, _buttonListView.frame.size.width-20,30)];
//    starView.Score=@0.0;
//    starView.canChoose = YES;
////    starView.starImage_Full = [UIImage imageNamed:@"img1.png"];
////    starView.starImage_Empty = [UIImage imageNamed:@"img2.png"];
////    starView.animation = YES;
//    [_buttonListView addSubview:starView];
//    self.starView=starView;
    
//    UITextView *input=[[UITextView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(starView.frame)+15, _buttonListView.frame.size.width-20, _buttonListView.frame.size.height-10-60-70-60)];
//    input.delegate=self;
//    if (defLabel) {
//        [defLabel removeFromSuperview];
//        defLabel=nil;
//    }
//    defLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 100, 20)];
//    defLabel.enabled = NO;
//    defLabel.text = @"请输入建议内容";
//    defLabel.font =  [UIFont systemFontOfSize:13];
//    defLabel.textColor=[UIColor colorWithRed:199/255.0 green:199/255.0 blue:205/255.0 alpha:1.0];
//    [input addSubview:defLabel];
//    [_buttonListView addSubview:input];
//    self.inputText=input;
    
    [self setupAskQuestionViewSubViews];

    
    //提交按钮
    submitBtnButtonListView =[UIButton buttonWithType:UIButtonTypeCustom];
    submitBtnButtonListView.frame=CGRectMake(_buttonListView.frame.size.width-60-10, CGRectGetMaxY(askQuestionBackView.frame)+8, 60, 40);
    [submitBtnButtonListView addTarget:self action:@selector(submitBtnButtonListViewClicked) forControlEvents:UIControlEventTouchUpInside];
    [submitBtnButtonListView setTitle:@"提问" forState:UIControlStateNormal];
    submitBtnButtonListView.titleLabel.font=[UIFont systemFontOfSize:15];
    submitBtnButtonListView.layer.cornerRadius=20;
    //设置背景色
    [submitBtnButtonListView setBackgroundColor:GWMColor(0, 145, 208)];
    [_buttonListView addSubview:submitBtnButtonListView];
    
    
     self.buttonListView.frame=CGRectMake(0, 0, listViewWidth, CGRectGetMaxY(submitBtnButtonListView.frame)+8);
    
}


-(void)layoutLines
{
    //虚线
    dottedImageView=[[UIImageView alloc] initWithFrame:CGRectMake(10, 90+15,  _buttonListView.frame.size.width-20, 2)];
    dottedImageView.image = [self drawLineByImageView:dottedImageView];
    [_buttonListView addSubview:dottedImageView];


}

// 返回虚线image的方法
- (UIImage *)drawLineByImageView:(UIImageView *)imageView
{
    UIGraphicsBeginImageContext(imageView.frame.size);   //开始画线 划线的frame
    [imageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
    //设置线条终点形状
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    // 5是每个虚线的长度  1是高度
    CGFloat lengths[] = {5,1};
    CGContextRef line = UIGraphicsGetCurrentContext();
    // 设置颜色
    CGContextSetStrokeColorWithColor(line, [UIColor colorWithWhite:0.408 alpha:1.000].CGColor);
    
    CGContextSetLineDash(line, 0, lengths, 2);  //画虚线
    CGContextMoveToPoint(line, 0.0, 2.0);    //开始画线
    CGContextAddLineToPoint(line, imageView.frame.size.width, 2.0);
    CGContextStrokePath(line);
    // UIGraphicsGetImageFromCurrentImageContext()返回的就是image
    return UIGraphicsGetImageFromCurrentImageContext();
}

- (void)adjustButtonListView
{
    CGFloat viewY;
    if (self.frame.origin.y+self.frame.size.height/2>self.baseView.frame.size.height/2) {
        viewY=self.center.y - listH;
    }else{
        viewY=self.center.y;
    }
    if (_isOnLeft) {
        _buttonListView.frame = CGRectMake(60 +15, viewY, _buttonListView.bounds.size.width, _buttonListView.bounds.size.height);
    } else {
        _buttonListView.frame = CGRectMake((_windowSize.size.width - 60 -15 - _buttonListView.bounds.size.width), viewY, _buttonListView.bounds.size.width, _buttonListView.bounds.size.height);
    }
}

#pragma mark - 按钮回调
- (void)tiggerButtonList
{
    NSLog(@"tiggerTap");
    
//    _isShowingButtonList = !_isShowingButtonList;
//    
//    CGAffineTransform toNormal = CGAffineTransformTranslate(CGAffineTransformIdentity, 1/1.2, 1/1.2);
//    [UIView animateWithDuration:0.1 animations:^{
//        // Translate normal
//        self.transform = toNormal;
//        self.backgroundColor = GWMColor(0, 145, 208);
//    } completion:^(BOOL finished) {
//        
//        [UIView animateWithDuration:0.1 animations:^{
//            self.center = _tempCenter;
////            [self adjustButtonListView];
//        } completion:^(BOOL finished) {
//            
//            [UIView animateWithDuration:0.3 animations:^{
//                _buttonListView.hidden = !_isShowingButtonList;
//                _isShowingButtonList ? (_buttonListView.alpha = 1.0) : (_buttonListView.alpha = 0);
//                _isShowingButtonList ? (_myBackView.hidden = NO) : (_myBackView.hidden = YES);
//                _isShowingButtonList ? (_instance.hidden = YES) : (_instance.hidden = NO);
//
//            }];
//        }];
//    }];
//    
    
    if ([self.sendDelegate respondsToSelector:@selector(isButtonTouched)]) {
        [self.sendDelegate isButtonTouched];
    }
    
}

- (void)optionsButtonPressed:(UIButton *)button
{
    //NSLog(@"buttonNumberPressed:%d",button.tag);
    if ([self.sendDelegate respondsToSelector:@selector(sendResultType:result:score:)]) {
        [self.sendDelegate sendResultType:(int)button.tag-2000 result:_inputText.text score:[self.starView.Score intValue]];
    }
//    switch (button.tag-2000) {
//        case 0:
//            NSLog(@"button0: %@",_inputText.text);
//            
//            break;
//        case 1:
//            NSLog(@"button1: %@",_inputText.text);
//            break;
//        case 2:
//            NSLog(@"button2: %@",_inputText.text);
//            break;
//        case 3:
//            NSLog(@"button3: %@",_inputText.text);
//            break;
//        default:
//            NSLog(@"button4: %@",_inputText.text);
//            break;
//    }
}
//默认文字效果
- (void) textViewDidChange:(UITextView *)textView{
    if ([textView.text length] == 0) {
        [defLabel setHidden:NO];
        [askQuestionDefLabel setHidden:NO];
    }else{
        [defLabel setHidden:YES];
        [askQuestionDefLabel setHidden:YES];
    }
}

-(void)removeAllViews
{
    if (_buttonListView) {
        _buttonListView.hidden=YES;
    }
    if (_askQuestionListView) {
        [_askQuestionListView removeFromSuperview];
        _askQuestionListView=nil;
    }
    if (_myBackView) {
        _myBackView.hidden=YES;

    }
    _isShowingButtonList=NO;
    _instance.hidden=NO;
}

@end
