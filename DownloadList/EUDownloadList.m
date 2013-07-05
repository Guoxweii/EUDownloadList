//
//  EUDownloadList.m
//  InterruptDownload
//
//  Created by csj on 13-7-5.
//  Copyright (c) 2013年 csj. All rights reserved.
//

#import "EUDownloadList.h"

@implementation EUDownloadList

static EUDownloadList *shareInstance;

static NSMutableArray *arrAllDownload;

//单例初始化
+ (void)initialize {
    if (self == [EUDownloadList class]) {
        shareInstance = [[self alloc] init];
        arrAllDownload = [[NSMutableArray alloc] init];
        
        NSLog(@"init download list");
        //get the last unfinish download instance
        NSArray *arrCache = [[NSUserDefaults standardUserDefaults] objectForKey:kEUDownloadListCacheData];
        for (NSDictionary *dicDownloadInfo in arrCache) {
            EUDownload *download = [EUDownload downloadWithUrl:[dicDownloadInfo objectForKey:@"url"] fileName:[dicDownloadInfo objectForKey:@"fileName"] path:[dicDownloadInfo objectForKey:@"filePath"] identify:[dicDownloadInfo objectForKey:@"identify"] progressView:nil];
            if ([shareInstance addDownload:download cache:NO]) {
                [download start];
            }
        }
        [shareInstance cacheAllDownloads];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    }
}

+ (EUDownloadList *)shareInstance {
    return shareInstance;
}

- (NSArray *)getAllDownload {
    return arrAllDownload;
}

//开始一个下载：url ：文件地址  fileName：下载下来的文件名  path文件存储地址
- (BOOL)startDownloadWithUrl:(NSString *)url fileName:(NSString *)fileName path:(NSString *)storePath identify:(NSString *)identify progressView:(UIProgressView *)progressView {
    //TODO 如果文件存在，返回NO
    if ([[NSFileManager defaultManager] fileExistsAtPath:storePath]) {
        progressView.progress = 1.0;
        NSLog(@"the download file is exit");
        return NO;
    }
    
    EUDownload *download = [EUDownload downloadWithUrl:url fileName:fileName path:storePath identify:identify progressView:progressView];
    if (![self addDownload:download cache:YES]) {
        NSLog(@"the downlod instance is exit!");
        return NO;
    }
    [download start];
    
    NSLog(@"downloading count:%d", arrAllDownload.count);
    return YES;
}

//下载文件的存放路径
- (NSString *)downloadPathDirectory {
    NSString *cacheDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //NSString *path = [cacheDirectory stringByAppendingPathComponent:@"/Foxmail_Setup_1.1.0.dmg"];
    return cacheDirectory;
}

#pragma mark Application Active
//当程序从后台重新激活的时候，恢复被中断的下载
+ (void)applicationActive {
    for (EUDownload *download in arrAllDownload) {
        [download resumeInterruptedDownload];
    }
}

#pragma mark EUDownloadDelegate
//下载结束，移除该下载
- (void)downloadFinished:(id )download {
    [self removeDownload:(EUDownload *)download];
}

#pragma mark download save and remove

//保存一个下载，如果该实例存在，则保存不成功
- (BOOL)addDownload:(EUDownload *)download cache:(BOOL)cache {
    for (EUDownload *downloadInstance in arrAllDownload) {
        if ([download.identify isEqualToString:downloadInstance.identify]) {
            return NO;
        }
    }
    
    download.delegate = self;
    [arrAllDownload addObject:download];
    if (cache) {
        [self cacheAllDownloads];
    }
    return YES;
}


//下载完成之后，移除该下载
- (void)removeDownload:(EUDownload *)download {
    for (EUDownload *downloadInstance in arrAllDownload) {
        if ([download.identify isEqualToString:downloadInstance.identify]) {
            [arrAllDownload removeObject:downloadInstance];
            NSLog(@"finish the download：%@", downloadInstance.identify);
            break;
        }
    }
    [self cacheAllDownloads];
}

//将download实例转化成dictionary持久化
- (void)cacheAllDownloads{
    NSMutableArray *arrCache = [NSMutableArray array];
    for (EUDownload *downloadInstance in arrAllDownload) {
        NSDictionary *dicDownloadInfo = [NSDictionary dictionaryWithObjectsAndKeys:downloadInstance.url, @"url", downloadInstance.fileName, @"fileName", downloadInstance.filePath, @"filePath", downloadInstance.identify, @"identify", nil];
        [arrCache addObject:dicDownloadInfo];
    }
    [[NSUserDefaults standardUserDefaults] setObject:arrCache forKey:kEUDownloadListCacheData];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
