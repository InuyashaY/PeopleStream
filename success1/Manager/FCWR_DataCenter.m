//
//  FXWR_DataCenter.m
//  TestData
//
//  Created by 许磊 on 2019/10/15.
//  Copyright © 2019年 许磊. All rights reserved.
//

#import "FCWR_DataCenter.h"

/**静态变量*/
static FCWR_DataCenter *instance = nil;

NSString *ip4 = @"http://10.129.15.159";

@implementation FCWR_DataCenter

/**单例模式*/
+(FCWR_DataCenter *)defaultDataCenter{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [FCWR_DataCenter new];
    });
    return instance;
}

/**设置阈值*/
- (void)setThreshold:(NSString *)threshold{
    //请求的URL
    NSURL *url = [NSURL URLWithString:[[ip4 stringByAppendingString:@"/python/saveThreshold.php?threshold="] stringByAppendingString:threshold]];
    //NSLog(@"%@",url);
    
    //初始化一个会话
    NSURLSession *session = [NSURLSession sharedSession];
    
    //初始化一个任务
    NSURLSessionDataTask *task = [session dataTaskWithURL:url];
    
    //执行任务
    [task resume];
}

/**获得对应地点人流所有数据*/
- (void)getPersonNumberDataWith:(NSString *)location handle:(HandleDataBlock)block{
    //请求的URL
    NSURL *url = [NSURL URLWithString:[[[ip4 stringByAppendingString:@"/python/file/"] stringByAppendingString:location] stringByAppendingString:@"/allData.json"]];
    NSLog(@"%@",url);
    
    //初始化一个会话
    NSURLSession *session = [NSURLSession sharedSession];
    
    //初始化一个任务
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        //获取不标准的json数据字符串
        NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        
        //字符串以换行符为标准划分为数组
        NSArray *dataArray = [dataString componentsSeparatedByString:@"\n"];
        
        //创建一个数组用于保存清洗后的数据
        NSMutableArray *personDataArray = [NSMutableArray array];
        
        //数组数据清洗，整合
        for (NSString *string in dataArray) {
            //获得的每个字符串转化为数据，标准的JSON数据
            NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
            //NSLog(@"%lu",data.length);
            
            //将JSON数据转化为字典
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            //NSLog(@"%@",dic);
            
            //判断数据字典是否为空
            if (dic != NULL) {
                [personDataArray addObject:dic];
            }
        }
        
        //NSLog(@"%lu",personDataArray.count);
        //NSLog(@"%@",personDataArray[personDataArray.count-1]);
        
        //回调数据
        block(personDataArray);
    }];
    
    //执行任务
    [task resume];
}

/**获得对应地点人流瞬时数据*/
- (void)getLatestPersonNumberDataWith:(NSString *)location handle:(HandleDataBlock)block{
    //请求的URL
    NSURL *url = [NSURL URLWithString:[[[ip4 stringByAppendingString:@"/python/file/"] stringByAppendingString:location] stringByAppendingString:@"/latestData.json"]];
    NSLog(@"%@",url);
    
    //初始化一个会话
    NSURLSession *session = [NSURLSession sharedSession];
    
    //初始化一个任务
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        //获取不标准的json数据字符串
        NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        
        //字符串以换行符为标准划分为数组
        NSArray *dataArray = [dataString componentsSeparatedByString:@"\n"];
        
        //创建一个数组用于保存清洗后的数据
        NSMutableArray *personDataArray = [NSMutableArray array];
        
        //数组数据清洗，整合
        for (NSString *string in dataArray) {
            //获得的每个字符串转化为数据，标准的JSON数据
            NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
            //NSLog(@"%lu",data.length);
            
            //将JSON数据转化为字典
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            //NSLog(@"%@",dic);
            
            //判断数据字典是否为空
            if (dic != NULL) {
                [personDataArray addObject:dic];
            }
        }
        
        //NSLog(@"%lu",personDataArray.count);
        //NSLog(@"%@",personDataArray[personDataArray.count-1]);
        
        //回调数据
        block(personDataArray);
    }];
    
    //执行任务
    [task resume];
}

/**获得对应地点超过阈值被保存的视频信息*/
- (void)getVideoDataWith:(NSString *)location handle:(CouldHandleDataBlock)block{
    //请求的URL字符串
    NSString *urlString = [[[ip4 stringByAppendingString: @"/python/file_video/"] stringByAppendingString:location] stringByAppendingString:@"/video.json"];
    
    //获取请求的数据
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
    
    //判断是否有数据
    if (data == NULL) {
        //NSLog(@"该时间没有超过阈值的数据");
        
        //回调数据
        block(NO,NULL);
    }else{
        //获取不标准的json数据字符串
        NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //NSLog(@"%@",dataString);
        
        //字符串以换行符为标准划分为数组
        NSArray *dataArray = [dataString componentsSeparatedByString:@"\n"];
        
        //创建一个数组用于保存清洗后的数据
        NSMutableArray *videoDataArray = [NSMutableArray array];
        
        //数组数据清洗，整合
        for (NSString *string in dataArray) {
            //获得的每个字符串转化为数据，标准的JSON数据
            NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
            //NSLog(@"%lu",data.length);
            
            //将JSON数据转化为字典
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            //NSLog(@"%@",dic);
            
            //判断数据字典是否为空
            if (dic != NULL) {
                [videoDataArray addObject:dic];
            }
        }
        
        //NSLog(@"%@",videoDataArray);
        
        //回调数据
        block(YES,videoDataArray);
    }
    
}

@end
