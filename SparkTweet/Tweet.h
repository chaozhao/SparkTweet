//
//  Tweet.h
//  SparkTweet
//
//  Created by Chao Zhao on 26/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tweet : NSObject
{
    NSString* name;
    NSString* screenName;
    NSString* text;
    NSString* createAt;
    NSString* profileImageURL;
    UIImage* profileImage;
}

@property (copy) NSString* name;
@property (copy) NSString* screenName;
@property (copy) NSString* text;
@property (copy) NSString* createAt;
@property (copy) NSString* profileImageURL;
@property (retain) UIImage* profileImage;

- (id)init;
+ (id) newTweet;

@end
