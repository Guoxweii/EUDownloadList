//
//  EUDownload.m
//  InterruptDownload
//
//  Created by csj on 13-7-5.
//  Copyright (c) 2013年 csj. All rights reserved.
//

#import "EUDownload.h"

@implementation EUDownload

- (EUDownload *)initWithUrl:(NSString *)url fileName:(NSString *)fileName path:(NSString *)filePath identify:(NSString *)identify progressView:(UIProgressView *)progressView{
    self = [super init];
    
    self.url = url;
    self.fileName = fileName;
    self.filePath = filePath;
    self.identify = identify;
    self.progressView = progressView;
    
    return (EUDownload *)self;
}

+ (EUDownload *)downloadWithUrl:(NSString *)url fileName:(NSString *)fileName path:(NSString *)filePath identify:(NSString *)identify progressView:(UIProgressView *)progressView{
    EUDownload *download = [[[self alloc ]initWithUrl:url fileName:fileName path:filePath identify:identify progressView:progressView] autorelease];
    return download;
}

//开始下载
- (void)start {
    [self resumeInterruptedDownload];
}

//恢复断点下载
- (void)resumeInterruptedDownload {
    if (_request) {
        [_request clearDelegatesAndCancel];
        [_request release];
        _request = nil;
    }
    _request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:self.url]];
    
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.filePath]) {
        //文件已经存在
        NSLog(@"thie file is exit");
        _progressView.progress = 1.0;
        return;
    }
    
    [_request setDownloadDestinationPath:self.filePath];
    NSString *tempPath = [self.filePath stringByAppendingFormat:@".download"];
    [_request setTemporaryFileDownloadPath:tempPath];
    [_request setAllowResumeForFileDownloads:YES];
    [_request setDownloadProgressDelegate:_progressView];
    _request.delegate = self;
    [_request startAsynchronous];
}

//恢复断点下载的进度条，在程序从后台手动结束后，在开启并恢复下载的时候需要恢复进度条
- (void)resumeInterruptedDownloadDelegate:(id)downloadDelegate {
    self.progressView = downloadDelegate;
    [self resumeInterruptedDownload];
}

- (void)dealloc {
    [_url release];
    [_fileName release];
    [_filePath release];
    [_identify release];
    if (_request) {
        [_request release];
    }
    if (_progressView) {
        [_progressView release];
    }
    [super dealloc];
}

//下载结束，下载队列管理，移除本下载
- (void)requestFinished:(ASIHTTPRequest *)request {
    //
    if (_delegate && [_delegate respondsToSelector:@selector(downloadFinished:)]) {
        [_delegate downloadFinished:self];
    }
}

@end
