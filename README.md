# EUDownloadList
version 0.9 

支持中断继续的下载列表组件


#### Usage

- 新增一个下载 

```
EUDownloadList *downloadList = [EUDownloadListshareInstance];
NSString *name = [NSString stringWithFormat:@"Foxmail_Setup_1.1.0.dmg%d", num];
NSString *path = [[downloadList downloadPathDirectory] stringByAppendingPathComponent:name];
[downloadList startDownloadWithUrl:@"http://dldir1.qq.com/foxmail/MacFoxmail/Foxmail_Setup_1.1.0.dmg" fileName:name path:path identify:name progressView:nil];
 ```
 
- 显示正在下载的列表
 
```
download = [[downloadList getAllDownload] objectAtIndex:0]
[download resumeInterruptedDownloadDelegate:((UIProgressView *)[cell.contentView viewWithTag:1])];
 ```
 
- 当程序被强行从后台退出后，再次开启时候恢复下载，则发送一个消息给下载列表,下载列表组件将自动恢复下载 

```
 EUDownloadList *downloadList = [EUDownloadList shareInstance];
```

####依赖

ASIHTTPRequest  

[http://allseeing-i.com/ASIHTTPRequest/](http://allseeing-i.com/ASIHTTPRequest/)

####TODO:

这只是beta版本，需要继续改进代码质量