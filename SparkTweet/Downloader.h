/*
     File: IconDownloader.h 
 Abstract: Helper object for managing the downloading of a particular app's icon.
 As a delegate "NSURLConnectionDelegate" is downloads the app icon in the background if it does not
 yet exist and works in conjunction with the RootViewController to manage which apps need their icon.
 
 A simple BOOL tracks whether or not a download is already in progress to avoid redundant requests.
  
  Version: 1.2 
  
 Copyright (C) 2010 Apple Inc. All Rights Reserved. 
  
 */

@class Tweet;
@class RootViewController;

@protocol DownloaderDelegate;

@interface Downloader : NSObject
{
    Tweet *aTweet;
    NSIndexPath *indexPathInTableView;
    __weak id <DownloaderDelegate> delegate;
    
    NSMutableData *activeDownload;
    NSURLConnection *imageConnection;
}

@property (nonatomic, strong) Tweet *aTweet;
@property (nonatomic, retain) NSIndexPath *indexPathInTableView;
@property (nonatomic, weak) id <DownloaderDelegate> delegate;

@property (nonatomic, retain) NSMutableData *activeDownload;
@property (nonatomic, retain) NSURLConnection *imageConnection;

- (void)startDownload;
- (void)cancelDownload;

@end

@protocol DownloaderDelegate 

- (void)userImageDidLoad:(NSIndexPath *)indexPath;

@end