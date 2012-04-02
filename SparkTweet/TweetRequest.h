//
//  TweetRequest.h
//  SparkTweet
//
//  Created by Chao Zhao on 8/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>
#import "TweetDelegate.h"

@interface TweetRequest : NSObject<TweetDelegate>
{
    __weak id <TweetDelegate> delegate;
     NSData *responseData;
    TWRequest *twRequest;
}

@property (weak, nonatomic) id <TweetDelegate> delegate;
@property (strong, nonatomic) NSData *responseData;
@property (strong, nonatomic) TWRequest *postRequest;
@property (strong, nonatomic) ACAccount *twitterAccount;
@property (strong, nonatomic) TWRequest *twRequest;

- (id) initWithDelegate: (id <TweetDelegate>) theDelegate;

- (void) getTimeline;
- (void) sendEasyTweet;




@end
