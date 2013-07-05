//
//  EUDownloadList.h
//  InterruptDownload
//
//  Created by csj on 13-7-5.
//  Copyright (c) 2013年 csj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "EUDownload.h"

#define kEUDownloadListCacheData @"kEUDownloadListCacheData"

@interface EUDownloadList : NSObject <EUDownloadDelegate>

+ (EUDownloadList *)shareInstance;
- (NSArray *)getAllDownload;
//下载文件的存放路径
- (NSString *)downloadPathDirectory;
//开始一个下载：url ：文件地址  fileName：下载下来的文件名  path文件存储地址
- (BOOL)startDownloadWithUrl:(NSString *)url fileName:(NSString *)fileName path:(NSString *)storePath identify:(NSString *)identify progressView:(UIProgressView *)progressView;

/**
 Usage
 
 ---- add a download  ----
 
 EUDownloadList *downloadList = [EUDownloadList shareInstance];
 NSString *name = [NSString stringWithFormat:@"Foxmail_Setup_1.1.0.dmg%d", num];
 
 NSString *path = [[downloadList downloadPathDirectory] stringByAppendingPathComponent:name];
 [downloadList startDownloadWithUrl:@"http://dldir1.qq.com/foxmail/MacFoxmail/Foxmail_Setup_1.1.0.dmg" fileName:name path:path identify:name progressView:nil];
 
 
 ----- show downling ------
 download = [[downloadList getAllDownload] objectAtIndex:0]
 [download resumeInterruptedDownloadDelegate:((UIProgressView *)[cell.contentView viewWithTag:1])];
 
 ----- resume download while application is opened, send an messaget to the downloadlist single instance ------
 
 EUDownloadList *downloadList = [EUDownloadList shareInstance];

 **/
@end
