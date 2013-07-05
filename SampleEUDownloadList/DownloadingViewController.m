//
//  TestDownloadListViewController.m
//  InterruptDownload
//
//  Created by csj on 13-7-5.
//  Copyright (c) 2013年 csj. All rights reserved.
//

#import "DownloadingViewController.h"
#import "EUDownloadList.h"

@interface DownloadingViewController ()

@end

@implementation DownloadingViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.title = @"downloading list";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[EUDownloadList shareInstance] getAllDownload].count;
    // Return the number of rows in the section.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        UIProgressView *progressView = [[[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault] autorelease];
        progressView.frame = CGRectMake(20, 20, 200, progressView.frame.size.height);
        progressView.tag = 1;
        [cell.contentView addSubview:progressView];
    } else {
        ((UIProgressView *)[cell.contentView viewWithTag:1]).progress = 0;
    }
    
    EUDownload *download = [[[EUDownloadList shareInstance] getAllDownload] objectAtIndex:indexPath.row];
    [download resumeInterruptedDownloadDelegate:((UIProgressView *)[cell.contentView viewWithTag:1])];
    
    return cell;
}

@end
