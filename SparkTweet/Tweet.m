//
//  Tweet.m
//  SparkTweet
//
//  Created by Chao Zhao on 26/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

@synthesize name;
@synthesize screenName;
@synthesize text;
@synthesize createAt;
@synthesize profileImage;
@synthesize profileImageURL;

- (id)init 
{
    self = [super init];
    if (self) 
    {
        name = [NSString string];
        screenName =  [NSString string];
        text =  [NSString string];
        createAt =  [NSString string];
    }
    return self;
}

+ (id) newTweet
{
    return [[self alloc]init];
}





@end
