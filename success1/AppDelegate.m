//
//  AppDelegate.m
//  success1
//
//  Created by Inuyasha on 07/10/2019.
//  Copyright © 2019 Inuyasha. All rights reserved.
//

#import "AppDelegate.h"
#import "YTabBar.h"
#import "MeViewController.h"
#import "RankViewController.h"
#import "AreaViewController.h"
#import "Manager/FCWR_DataCenter.h"
#import "Factory.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 1.创建窗口
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    // 2.创建TabBarController
    UITabBarController *tbc = [UITabBarController new];
    // 更改渲染的颜色 选中的颜色
    //tbc.tabBar.tintColor = [UIColor blackColor];
    // 设置标题选中状态的属性 颜色 大小 字体 富文本
    
    //将系统默认的tabbar改为自己的tabbar
    [tbc setValue:[YTabBar new] forKeyPath:@"tabBar"];
    [[UITabBar appearance] setTintColor:TABBAR_BG_COLOR];
    [UITabBar appearance].translucent = NO;
    
    // 2.1 为tabbar创建子视图
    
    //排行榜
    [Factory addChild:@"RankViewController" withTitle:@"排行榜" normal:@"1" selected:@"2" to:tbc withBGColor:[UIColor whiteColor]];
    
    //区域
    [Factory addChild:@"AreaViewController" withTitle:@"区域" normal:@"3" selected:@"4" to:tbc withBGColor:[UIColor whiteColor]];
    
    //我的
    [Factory addChild:@"MeViewController" withTitle:@"管理员" normal:@"5" selected:@"6" to:tbc withBGColor:[UIColor whiteColor]];
    
    //设置TabBarController默认显示的栏目
    tbc.selectedIndex = 1;
    
    // 3.设置rootViewController
    _window.rootViewController =  tbc;
    
    // 4.显示窗口
    [_window makeKeyAndVisible];
//    for (NSString *fontfamilyname in [UIFont familyNames])
//    {
//        NSLog(@"family:'%@'",fontfamilyname);
//        for(NSString *fontName in [UIFont fontNamesForFamilyName:fontfamilyname])
//        {
//            NSLog(@"\tfont:'%@'",fontName);
//        }
//        NSLog(@"-------------");
//    } 
    return YES;
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"success1"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
