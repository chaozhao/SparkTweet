//
//  AppDelegate.h
//  SparkTweet
//
//  Created by Chao Zhao on 26/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>
@class TimeLineViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    IBOutlet TimeLineViewController *timeLineVC;
    NSMutableArray *allTweets;
}
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) IBOutlet TimeLineViewController *timeLineVC;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) NSMutableArray *allTweets;

@property (strong, nonatomic) ACAccountStore *accountStore;
@property (strong, nonatomic) ACAccountType *accountType;
@property (strong, nonatomic) NSArray *accountsArray;
@property (strong, nonatomic) ACAccount *twitterAccount;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
