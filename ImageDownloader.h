//
//  ImageDownloader.h
//  SparkTweet
//
//  Created by Chao Zhao on 6/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TimeLineViewController;
@class Tweet;

@protocol ImageDownloaderDelegate;

@interface ImageDownloader : NSObject<ImageDownloaderDelegate>
{
    Tweet *aTweet;
    NSIndexPath *indexPathInTableView;
    __weak id <ImageDownloaderDelegate> delegate;
    NSMutableData *activeDownload;
    NSURLConnection *imageConnection;
}

@property (nonatomic,strong) Tweet *aTweet;
@property (nonatomic,strong) NSIndexPath *indexPathInTableView;
@property (nonatomic, weak) id <ImageDownloaderDelegate> delegate;

@property (nonatomic,strong) NSMutableData *activeDownload;
@property (nonatomic,strong) NSURLConnection *imageConnection;
- (void)userImageDidLoad:(NSIndexPath *)indexPath;
- (void)startDownload;

@end




