//
//  TweetDelegate.h
//  SparkTweet
//
//  Created by Chao Zhao on 8/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//


#import <Foundation/Foundation.h>

@class Tweet;

@protocol TweetDelegate <NSObject>

@optional
//-(void) getTimeLineStarted;
- (void)twitterJSONDidDownload:(NSData *)responesData;
- (void)parsingDidFinish:(NSArray *)appList;
- (void)parseErrorOccurred:(NSError *)error;
- (void)profileImageDidDownload:(NSIndexPath *)indexPath;
- (void)imageDidLoad:(NSIndexPath *)indexPath;

@end