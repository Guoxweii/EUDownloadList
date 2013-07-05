//
//  EUDownload.h
//  InterruptDownload
//
//  Created by csj on 13-7-5.
//  Copyright (c) 2013年 csj. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EUDownloadDelegate <NSObject>

- (void)downloadFinished:(id )download;

@end

@interface EUDownload  : NSObject <ASIHTTPRequestDelegate>{
    
}
@property (nonatomic, assign) id<EUDownloadDelegate> delegate;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSString *fileName;
@property (nonatomic, retain) NSString *filePath;
@property (nonatomic, retain) NSString *identify;
@property (nonatomic, retain) ASIHTTPRequest *request;
@property (nonatomic, retain) UIProgressView *progressView;

//开始下载
- (void)start;
//恢复断点下载
- (void)resumeInterruptedDownload;
//恢复下载的进度条
- (void)resumeInterruptedDownloadDelegate:(id)downloadDelegate;
- (EUDownload *)initWithUrl:(NSString *)url fileName:(NSString *)fileName path:(NSString *)filePath identify:(NSString *)identify progressView:(UIProgressView *)progressView;
+ (EUDownload *)downloadWithUrl:(NSString *)url fileName:(NSString *)fileName path:(NSString *)filePath identify:(NSString *)identify progressView:(UIProgressView *)progressView;
@end
