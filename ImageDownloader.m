//
//  ImageDownloader.m
//  SparkTweet
//
//  Created by Chao Zhao on 6/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ImageDownloader.h"

#define kAppIconHeight 48

@implementation ImageDownloader

@synthesize aTweet;
@synthesize indexPathInTableView;
@synthesize activeDownload;
@synthesize imageConnection;
@synthesize delegate;

- (void)userImageDidLoad:(NSIndexPath *)indexPath
{
    NSLog(@"this is delegate");
}


- (void)startDownload
{
    self.activeDownload = [NSMutableData data];
    
    // alloc+init and start an NSURLConnection; release on completion/failure

     NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:
                             [NSURLRequest requestWithURL:
                                [NSURL URLWithString:aTweet.imageURLString]] delegate:self];
    self.imageConnection = conn;
    conn = nil;
}

- (void)cancelDownload
{
    [self.imageConnection cancel];
    self.imageConnection = nil;
    self.activeDownload = nil;
}

#pragma mark -
#pragma mark Download support (NSURLConnectionDelegate)

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.activeDownload appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	// Clear the activeDownload property to allow later attempts
    self.activeDownload = nil;
    
    // Release the connection now that it's finished
    self.imageConnection = nil;
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // Set appIcon and clear temporary data/image
    UIImage *image = [[UIImage alloc] initWithData:self.activeDownload];
    self.aTweet.userImage = image;
    
    // Release the connection now that it's finished
    self.activeDownload = nil;
    self.imageConnection = nil;
    
    // call our delegate and tell it that our icon is ready for display
    [self.delegate appImageDidLoad:self.indexPathInTableView];
}



@end
