//
//  TimeLineViewController.h
//  SparkTweet
//
//  Created by Chao Zhao on 20/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>
#import "Tweet.h"
#import "Downloader.h"
#import "TweetRequest.h"
#import "DetailedTweetViewController.h"

@interface TimeLineViewController : UITableViewController <DownloaderDelegate, TweetDelegate>
{
    IBOutlet UITableView* tableView;    
    NSMutableArray* allTweets;
    ACAccount *twitterAccount;
    TweetRequest *tweetRequest;
}

@property (strong, nonatomic) IBOutlet UITableView* tableView;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong,nonatomic) NSMutableArray* allTweets;
@property (strong, nonatomic) TWRequest *postRequest;
@property (strong,nonatomic) NSMutableDictionary *imageDownloadsInProgress;
@property (strong,nonatomic) TweetRequest *tweetRequest;

// an account store object.
@property (strong, nonatomic) ACAccountStore *accountStore;
@property (strong, nonatomic) ACAccountType *accountType;
@property (strong, nonatomic) NSArray *accountsArray;
@property (strong, nonatomic) ACAccount *twitterAccount;


- (IBAction)getTimeLineTweets:(id)sender;
- (IBAction)sendEasyTweet:(id)sender;

-(void) twitterJSONDidDownload:(NSData*) responseData;
- (void)userImageDidLoad:(NSIndexPath *)indexPath;
@end
