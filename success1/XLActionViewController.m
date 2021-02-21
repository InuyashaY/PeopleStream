//
//  XLMyController.m
//  相册
//
//  Created by 许磊 on 2019/4/26.
//  Copyright © 2019年 许磊. All rights reserved.
//

#import "XLActionViewController.h"

@interface XLActionViewController()

@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation XLActionViewController

#pragma mark -------加载的时候做的事 ---------
-(void)awakeFromNib{
    [super awakeFromNib];
    self.sureBtn.font = ALERT_BUTTON_FONT;
    self.nameLabel.font = ALERT_TITLE_FONT;
    self.cancelBtn.font = ALERT_BUTTON_FONT;
    
    //输入框的样式
    self.textField.layer.borderWidth = 1;
    self.textField.layer.cornerRadius = 15;
    self.textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

#pragma mark -------输入框 警告框添加的方法 ---------
+(XLActionViewController *)showAlertControllerWithType:(AlertType)type AndName:(NSString *)name{
    
    //获得nib文件数组
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"XLActionViewController" owner:nil options:nil];
    
    //创建
    XLActionViewController *myController = [[XLActionViewController alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    //判断是添加相册还是警告框
    if (type == AlertTypeAddSite) {
        
        //添加相册
        myController = [nibs objectAtIndex:0];
        
        //输入框名称
        myController.nameLabel.text = name;
        
        //成为第一响应者
        [myController.textField becomeFirstResponder];
        
    }else{
        
        //添加警告框
        myController = [nibs objectAtIndex:1];
        
        //警告框名称
        myController.nameLabel.text = name;
    }
    
    //渐变显示
    myController.alpha = 0;
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:myController];
    [UIView animateWithDuration:0.5 animations:^{
        myController.alpha = 1;
    }];
    
    return myController;
}

#pragma mark -------操作框的添加方法 ---------
+(XLActionViewController *)showActionSheet{
    
    //获得nib文件数组
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"XLActionViewController" owner:nil options:nil];
    
    //创建操作框
    XLActionViewController *myController = [nibs objectAtIndex:2];
   
    //渐变显示
    myController.alpha = 0;
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:myController];
    [UIView animateWithDuration:0.5 animations:^{
        myController.alpha = 1;
    }];
    
    return myController;
}

#pragma mark -------移除添加的各种框 ---------
-(void)dismiss{

    //从父视图上移除
    [self removeFromSuperview];
}

#pragma mark -------输入框按钮 ---------
//确认按钮被点击了
- (IBAction)sureBtnDidClicked:(UIButton *)sender {
    
    if (self.sureblock) {
        self.sureblock(self.textField.text);
    }
    [self dismiss];
}

//取消按钮被点击了
- (IBAction)cancelBtnDidClicked:(UIButton *)sender {
    
    if (self.cancelblock) {
        self.cancelblock();
    }
    [self dismiss];
}

#pragma mark -------警告框按钮 ---------
//确定按钮被点击了
- (IBAction)continueBtnDidClicked:(UIButton *)sender {
    
    if (self.cancelblock) {
        self.cancelblock();
    }
    [self dismiss];
}

#pragma mark -------操作框按钮 ---------
//相机来源按钮被点击了
- (IBAction)cameraBtnDidClicked:(UIButton *)sender {
    
    if (self.actionBlock) {
        self.actionBlock(ActionTypeCamera);
    }
    [self dismiss];
}

//系统相册来源按钮被点击了
- (IBAction)albumBtnDidClicked:(UIButton *)sender {
    
    if (self.actionBlock) {
        self.actionBlock(ActionTypeLibrary);
    }
    [self dismiss];
}

//取消添加的按钮被点击了
- (IBAction)cancelAddPictureBtnDidClicked:(UIButton *)sender {
    
    if (self.cancelblock) {
        self.cancelblock();
    }
    [self dismiss];
}

@end
