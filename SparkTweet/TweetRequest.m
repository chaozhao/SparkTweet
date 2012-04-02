//
//  TweetRequest.m
//  SparkTweet
//
//  Created by Chao Zhao on 8/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//
#define home_timeline @"https://api.twitter.com/1/statuses/home_timeline.json"

#import "TweetRequest.h"

@implementation TweetRequest

@synthesize twRequest;
@synthesize postRequest;
@synthesize delegate;
@synthesize twitterAccount;
@synthesize responseData;


-(id) initWithDelegate: (id <TweetDelegate>) theDelegate
{
    self = [super init];
    if (self) 
    {
        self.delegate = theDelegate;
        [self.postRequest setAccount:self.twitterAccount];
    }
    return self;
}

- (void)getTimeline
{    
    /*ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    NSArray *accountsArray = [accountStore accountsWithAccountType:accountType];
    self.twitterAccount = [[ACAccount alloc]init];
    
    // Request access from the user to use their Twitter accounts.
    [accountStore requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error) 
     {
         if(granted) 
         {
             // Grab the initial Twitter account to tweet from.
             if ([accountsArray count]>0)
             {
                 //self.twitterAccount = [accountsArray objectAtIndex:0];
                 self.postRequest = [[TWRequest alloc] initWithURL: [NSURL URLWithString:home_timeline] parameters:nil requestMethod:TWRequestMethodGET];
                 [self.postRequest setAccount:[accountsArray objectAtIndex:0]];
                
                 // Perform the request created above and create a handler block to handle the response.
                 [self.postRequest performRequestWithHandler:^(NSData *theResponseData, NSHTTPURLResponse *urlResponse, NSError *error) 
                  {
                      NSString *output;
                      if ([urlResponse statusCode] == 200) 
                      {
                          self.responseData = theResponseData;
                          [delegate twitterJSONDidDownload:self.responseData];
                          output = [NSString stringWithFormat:@"HTTP response status: %i\n", [urlResponse statusCode]];
                      }
                      else 
                      {
                          self.responseData = nil;
                          output = [NSString stringWithFormat:@"HTTP response status: %i\n", [urlResponse statusCode]];
                      }
                        NSLog(@"%@",output);
                  }];

             }
         }
     }];

    
    */
    
    //  First, we need to obtain the account instance for the user's Twitter account
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    //  Request access from the user for access to his Twitter accounts
    [accountStore requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error) 
     {
         if (!granted) 
         {
             // The user rejected your request 
         } 
         else 
         {
             // Grab the available accounts
             NSArray *twitterAccounts = [accountStore accountsWithAccountType:accountType];
             
             if ([twitterAccounts count] > 0) 
             {                 
                 self.postRequest = [[TWRequest alloc] initWithURL: [NSURL URLWithString:home_timeline] 
                                                        parameters:nil 
                                                     requestMethod:TWRequestMethodGET];
                 
                 //  We attach the account object to this request so TWRequest knows how to sign    
                 [self.postRequest setAccount:[twitterAccounts objectAtIndex:0]];
                 
                 // Perform the request created above and create a handler block to handle the response.
                 [self.postRequest performRequestWithHandler:^(NSData *theResponseData, NSHTTPURLResponse *urlResponse, NSError *error) 
                  {
                      NSString *output;
                      if ([urlResponse statusCode] == 200) 
                      {
                          self.responseData = theResponseData;
                          output = [NSString stringWithFormat:@"HTTP response status: %i\n", [urlResponse statusCode]];
                          [delegate twitterJSONDidDownload:self.responseData];
                      }
                      else
                      {
                          self.responseData = nil;
                          output = [NSString stringWithFormat:@"HTTP response status: %i\n", [urlResponse statusCode]];
                          NSLog(@"%@",error);
                      }
                      NSLog(@"%@",output);
                  }];
                 
             }
         }
     }];
	}

- (void)sendEasyTweet
{
    // Set up the built-in twitter composition view controller.
    TWTweetComposeViewController *tweetViewController = [[TWTweetComposeViewController alloc] init];
    // Create the completion handler block.
    [tweetViewController setCompletionHandler:^(TWTweetComposeViewControllerResult result) 
     {
         NSString *output;
         switch (result) 
         {
             case TWTweetComposeViewControllerResultCancelled:
                 // The cancel button was tapped.
                 output = @"Tweet cancelled.";
                 break;
             case TWTweetComposeViewControllerResultDone:
                 // The tweet was sent.
                 output = @"Tweet done.";
                 break;
             default:
                 break;
         }         
     }
     ];
}




@end
