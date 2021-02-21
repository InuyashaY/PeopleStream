//
//  YFileManager.m
//  success1
//
//  Created by Inuyasha on 19/10/2019.
//  Copyright © 2019 Inuyasha. All rights reserved.
//

#import "YFileManager.h"
#import <UIKit/UIKit.h>
#import "DownloadVideoModel.h"
#import "Factory.h"
//#import "YAlertController.h"
#import "XLActionViewController.h"

#define DOWNLOAD_PATH @"downloadVideos"

@interface YFileManager()<NSURLSessionDelegate>
@property (copy , nonatomic) NSString *downloadPath;
@property (strong , nonatomic) UIProgressView *progressView;
@property(nonatomic,strong)NSURLSessionDownloadTask *downloadTask;
@property (copy , nonatomic) NSString *desPath;
@end

static YFileManager *instance = nil;
@implementation YFileManager

+(YFileManager *)sharedManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [YFileManager new];
    });
    return instance;
}


//创建存放下载视频的路径
-(void)createDownLoadPath{
    NSString *downLoadPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:DOWNLOAD_PATH];
    self.downloadPath = downLoadPath;
    [[NSFileManager defaultManager] createDirectoryAtPath:downLoadPath withIntermediateDirectories:YES attributes:nil error:nil];
    NSLog(@"----%@",downLoadPath);
}

//访问下载路径
-(NSString *)downloadPath{
    if (_downloadPath == nil) {
        [self createDownLoadPath];
    }
    return _downloadPath;
}




/** 下载视频 */
- (void)startDownLoadVideoWithURL:(NSURL *)url toFileName:(nonnull NSString *)fileName{
    self.desPath = [[self downloadPath] stringByAppendingPathComponent:fileName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:_desPath]) {
        //创建目录
        [[NSFileManager defaultManager] createDirectoryAtPath:_desPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    self.downloadTask = [session downloadTaskWithURL:url];
    [self.downloadTask resume];
}


#pragma mark NSSessionUrlDelegate
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    //下载进度
    CGFloat progress = totalBytesWritten / (double)totalBytesExpectedToWrite;
    dispatch_async(dispatch_get_main_queue(), ^{
        //进行UI操作  设置进度条
        self.progressView.progress = progress;
        //        self.progressView. = [NSString stringWithFormat:@"%.2f%%",progress*100];
    });
}


//下载完成 保存到本地相册
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    //拿到cache文件夹和文件名
    NSString *file=[self.desPath stringByAppendingPathComponent:downloadTask.response.suggestedFilename];
    //保存到download路径下
    [[NSFileManager defaultManager] moveItemAtURL:location toURL:[NSURL fileURLWithPath:file] error:nil];
//    [YAlertController showAlertControllerWithType:AlertTypeAlert alert:@"下载完成！" sure:nil];
    [XLActionViewController showAlertControllerWithType:AlertTypeAlert AndName:@"下载完成"];
    
}


//加载数据
-(NSArray *)loadDatawithSiteModel:(SiteModel*)model {
    //加载所有视频名称
    NSString *secondPath = [[self downloadPath] stringByAppendingPathComponent:model.siteName];
    NSLog(@"secondPath:%@",secondPath);
    NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:secondPath error:nil];
    //将mp4文件全部取出
    NSMutableArray *videoModelArray = [NSMutableArray array];
    for (NSString * item in contents) {
        if ([item containsString:@".mp"]) {
            DownloadVideoModel *model = [DownloadVideoModel new];
            // 拼接完整路径
            NSString *completePath = [secondPath stringByAppendingPathComponent:item];
            NSLog(@"CompletePath:%@",completePath);
            //创建model
            model.name = item;
            model.url = completePath;
            model.time = [Factory getVideoTimeByUrl:[NSURL fileURLWithPath:completePath]];
            
            [videoModelArray addObject:model];
        }
    }
    
    
    return videoModelArray;
}

@end
