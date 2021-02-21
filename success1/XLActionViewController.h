//
//  XLMyController.h
//  相册
//
//  Created by 许磊 on 2019/4/26.
//  Copyright © 2019年 许磊. All rights reserved.
//

#import <UIKit/UIKit.h>

//定义block类型用于回调数据
typedef void(^Sureblock) (NSString *text);
typedef void(^Cancelblock) (void);
typedef void(^ActionBlock) (ActionType type);

@interface XLActionViewController : UIView

//属性变量保存
@property (nonatomic,copy) Sureblock sureblock;
@property (nonatomic,copy) Cancelblock cancelblock;
@property (nonatomic,copy) ActionBlock actionBlock;


//输入框+警告框
+(XLActionViewController *)showAlertControllerWithType:(AlertType)type AndName:(NSString *)name;

//操作框
+(XLActionViewController *)showActionSheet;

//提供自动移除的方法
-(void)dismiss;

@end
