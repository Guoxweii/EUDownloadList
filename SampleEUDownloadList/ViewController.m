//
//  ViewController.m
//  InterruptDownload
//
//  Created by csj on 13-7-4.
//  Copyright (c) 2013年 csj. All rights reserved.
//

#import "ViewController.h"
#import "EUDownloadList.h"
#import "DownloadingViewController.h"

@interface ViewController () {
    EUDownloadList *downloadList;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"test download list";
    downloadList = [EUDownloadList shareInstance];
}

- (IBAction)addAnDownload {
    NSNumber *downloadNum = [[NSUserDefaults standardUserDefaults] objectForKey:@"downloadNum"];
    if (!downloadNum) {
        downloadNum = [NSNumber numberWithInt:0];
    }
    
    int num = [downloadNum intValue];
    
    num++;
    
    NSString *name = [NSString stringWithFormat:@"Foxmail_Setup_1.1.0.dmg%d", num];
    
    NSString *path = [[downloadList downloadPathDirectory] stringByAppendingPathComponent:name];
    [downloadList startDownloadWithUrl:@"http://dldir1.qq.com/foxmail/MacFoxmail/Foxmail_Setup_1.1.0.dmg" fileName:name path:path identify:name progressView:nil];
    
    [[NSUserDefaults standardUserDefaults] setInteger:num forKey:@"downloadNum"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)btnDownloadList:(id)sender {
    DownloadingViewController *test = [[DownloadingViewController alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:test animated:YES];
    [test release];
}

@end
