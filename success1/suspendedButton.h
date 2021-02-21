//
//  suspendedButton.h
//  suspendButton
//
//  Created by WF on 16/8/18.
//  Copyright © 2016年 YJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
//代理
@class suspendedButton;
@protocol suspendedButtonDelegate <NSObject>
@optional
-(void)sendResultType:(int)type result:(NSString *)result score:(int)score;
-(void)submit;//提交
-(void)isButtonTouched;//suspendedButton被点击了
-(void)goToChoosePicture;//跳转去选择图片

@end


@interface suspendedButton : UIButton
+ (suspendedButton *)suspendedButtonWithCGPoint:(CGPoint)pos inView:(UIView *)baseview;
@property (nonatomic,strong) UITextView *inputText;
@property (nonatomic,strong) UITextView *askQuestionInPutText;

//代理
@property(nonatomic,weak)id<suspendedButtonDelegate> sendDelegate;

-(void)tiggerButtonList;
-(void)askQuestionClicked;
-(void)removeAllViews;//点击关闭所有view


@property(nonatomic,strong)UIView *baseView;//基层的View
@property(nonatomic,strong)UIView *myBackView;//蒙层

@end
