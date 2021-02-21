//
//  Constants.h
//  success1
//
//  Created by Inuyasha on 08/10/2019.
//  Copyright © 2019 Inuyasha. All rights reserved.
//

#ifndef Constants_h
#define Constants_h
#import <Foundation/Foundation.h>

//导航栏字体大小
#define NAVIGATION_TITLE_SIZE [UIFont systemFontOfSize:24.0f]
//导航栏字体
//family:'FZTanHeiS-L-GB' font:'FZXTHJW--GB1-0'
//family:'FZTieJinLiShu-S17' font:'FZTJLSK--GBK1-0'
#define NAVIGATION_TITLE_FONT [UIFont fontWithName:@"FZXTHJW--GB1-0" size:28]
//导航栏颜色
#define NAVIGATIONBAR_COLOR [UIColor colorWithRed:245.0/255.0 green:203.0/255.0 blue:0/255.0 alpha:1]
//tabbar背景颜色
#define TABBAR_BG_COLOR [UIColor whiteColor]
//tabbar选中时title的颜色
#define TABBAR_SELECTED_COLOR [UIColor colorWithRed:255.0/255.0 green:193.0/255.0 blue:37/255.0 alpha:1]
//tabbar未选中时title的颜色
#define TABBAR_NORMAL_COLOR [UIColor colorWithRed:79.0/255.0 green:79.0/255.0 blue:79.0/255.0 alpha:1]
//tabbar的title大小
#define TABBAR_TITLE_SIZE [UIFont systemFontOfSize:13]
// 屏幕宽高
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

//返回按钮的颜色
#define BACKBUTTON_COLOR [UIColor colorWithRed:53.0/255.0 green:50.0/255.0 blue:51.0/255.0 alpha:1]

#pragma mark --------------AlertView区域--------------
#define ALERT_TITLE_FONT [UIFont fontWithName:@"FZTJLSK--GBK1-0" size:22]
#define ALERT_BUTTON_FONT [UIFont fontWithName:@"FZTJLSK--GBK1-0" size:18]

#pragma mark --------------AreaView区域--------------

// item的宽和高
#define AREA_ITEM_WIDTH ([UIScreen mainScreen].bounds.size.width)
//#define AREA_ITEM_WIDTH (([UIScreen mainScreen].bounds.size.width-30)/2)
#define AREA_ITEM_HEIGHT 280
// item 圆角
#define AREA_ITEM_CORNER_RADIOS 5
// item 背景颜色
#define AREA_ITEM_BACKGROUND_COLOR [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1]
// item 字体大小
#define AREA_ITEM_FONT [UIFont fontWithName:@"FZTJLSK--GBK1-0" size:18]
#define AREA_MOREBUTTON_FONT [UIFont fontWithName:@"FZTJLSK--GBK1-0" size:16]
//add按钮的大小
#define ADD_BUTTON_WIDTH 64
#define ADD_BUTTON_HEIGHT 64


#pragma mark -----------------RankView 排行榜----------------
// item 宽高
#define RANK_ITEM_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define RANK_ITEM_HEIGHT 60
// header 宽高
#define RANK_HEADER_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define RANK_HEADER_HEIGHT 70
// header font
//item 字体
#define RANK_ITEM_FONT  [UIFont fontWithName:@"FZTJLSK--GBK1-0" size:18]
//header 字体
#define RANK_HEADER_FONT  [UIFont fontWithName:@"FZTJLSK--GBK1-0" size:20]




#pragma mark -----------------MeView 管理员-------------------
//item 宽高
#define ME_ITEM_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define ME_ITEM_HEIGHT 60
//item 字体
#define ME_ITEM_FONT  [UIFont fontWithName:@"FZTJLSK--GBK1-0" size:18]
//header 字体
#define ME_HEADER_FONT  [UIFont fontWithName:@"FZTJLSK--GBK1-0" size:24]



#pragma mark -----------------设置阈值界面-------------------
// item 宽高
#define SETUP_ITEM_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SETUP_ITEM_HEIGHT 60
//标题 字体
#define SETUP_ITEM_TITLE_FONT  [UIFont fontWithName:@"FZTJLSK--GBK1-0" size:18]
//显示值 字体
#define SETUP_ITEM_THRED_FONT  [UIFont fontWithName:@"FZTJLSK--GBK1-0" size:15]




#pragma mark -----------------视频页面展示-------------------
//Item 宽高
#define VIDEO_ITEM_WIDTH (([UIScreen mainScreen].bounds.size.width-30)/2)
#define VIDEO_ITEM_HEIGHT 130
//标题 font
#define OVER_TITLE_FONT  [UIFont fontWithName:@"FZTJLSK--GBK1-0" size:17]
//item 具体显示 字体
#define OVER_ITEM_FONT  [UIFont fontWithName:@"FZTJLSK--GBK1-0" size:17]




#pragma mark ------------缓存视频---------------
//头视图的宽高
#define DOWNLOAD_HEADER_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define DOWNLOAD_HEADER_HEIGHT 50
//Header   标题文字大小
#define DOWNLOAD_HEADER_FONT ([UIFont fontWithName:@"FZTJLSK--GBK1-0" size:35])



//Alert的类型的类型
typedef NS_ENUM(NSInteger, AlertType) {
    AlertTypeAddSite,
    AlertTypeAlert
};

//图片来源类型
typedef NS_ENUM(NSInteger,ActionType) {
    ActionTypeLibrary, //相册
    ActionTypeCamera   //相机
};

#endif /* Constants_h */
