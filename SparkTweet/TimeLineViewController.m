//
//  TimeLineViewController.m
//  SparkTweet
//
//  Created by Chao Zhao on 20/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#define home_timeline @"https://api.twitter.com/1/statuses/home_timeline.json"

#import "TimeLineViewController.h"

@implementation TimeLineViewController

@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize tableView;

@synthesize allTweets;
@synthesize postRequest;
@synthesize imageDownloadsInProgress;
@synthesize tweetRequest;

@synthesize accountStore;
@synthesize accountType;
@synthesize accountsArray;
@synthesize twitterAccount;

#pragma mark - IBAction

-(IBAction)getTimeLineTweets:(id)sender
{
     [self.tweetRequest getTimeline];
}

- (IBAction)sendEasyTweet:(id)sender
{
    [self.tweetRequest sendEasyTweet];
}

-(void) twitterJSONDidDownload:(NSData*) responseData
{
    if(self.allTweets) [self.allTweets removeAllObjects];
    
    NSArray* tempTweets = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
    
    //get each tweet from json dictionary
    for (NSDictionary *aTweetDict in tempTweets)
    {
        Tweet* eachTweet = [[Tweet alloc]init];    
        eachTweet.text =  [aTweetDict valueForKey:@"text"];
        eachTweet.screenName = [[aTweetDict valueForKey:@"user"] valueForKey:@"screen_name"];
        eachTweet.createAt = [aTweetDict valueForKey:@"create_at"];
        eachTweet.profileImageURL = [[aTweetDict valueForKey:@"user"]valueForKey:@"profile_image_url"];
        [self.allTweets addObject:eachTweet];
    }
    
    [self.tableView reloadData];  
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) 
    {
        // Custom initialization
    }
    return self;
}

#pragma mark - View lifecycle

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    self.allTweets = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
    self.allTweets = [NSMutableArray arrayWithCapacity:25];
    self.tweetRequest =[[TweetRequest alloc]initWithDelegate:self];
    NSLog(@"try to get time line");
    [self.tweetRequest getTimeline];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.tableView = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [allTweets count];
}

- (void)startImageDownload:(Tweet *)aTweet forIndexPath:(NSIndexPath *)indexPath
{
    Downloader *imgDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    
    if (imgDownloader == nil) 
    {
        imgDownloader = [[Downloader alloc] init];
        imgDownloader.aTweet = aTweet;
        
        //NSLog(@"%@",aTweet.profileImageURL);
        
        imgDownloader.indexPathInTableView = indexPath;
        imgDownloader.delegate = self;
        [imageDownloadsInProgress setObject:imgDownloader forKey:indexPath];
        [imgDownloader startDownload];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"HomeTimeLineCell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) 
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Set up the cell
    Tweet* aTweet = [[Tweet alloc]init];
    aTweet = [self.allTweets objectAtIndex:indexPath.row];
    
    cell.textLabel.text = aTweet.screenName;
    cell.detailTextLabel.text = aTweet.text;
    
    // Only load cached images; defer new downloads until scrolling ends
    if (!aTweet.profileImage)
    {        
        // if a download is deferred or in progress, return a placeholder image
        cell.imageView.image = [UIImage imageNamed:@"Placeholder.png"];                
    }
    else
    {
        cell.imageView.image = aTweet.profileImage;
    }
    
    return cell;
}

// this method is used in case the user scrolled into a set of cells that don't have their app icons yet
- (void)loadImagesForOnscreenRows
{
    if ([self.allTweets count] > 0)
    {
        NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            Tweet *aTweet = [self.allTweets objectAtIndex:indexPath.row];
            
            // avoid the app icon download if the app already has an icon
            if (!aTweet.profileImage) 
            {
                [self startImageDownload:aTweet forIndexPath:indexPath];
            }
        }
    }
}

// called by our Downloader when an icon is ready to be displayed
- (void)userImageDidLoad:(NSIndexPath *)indexPath
{
    Downloader *imgDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (imgDownloader != nil)
    {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:imgDownloader.indexPathInTableView];
        
        // Display the newly loaded image
        cell.imageView.image = imgDownloader.aTweet.profileImage;
    }
    else
    {
        NSLog(@"imgDownloader is nil");
    }
}

#pragma mark -
#pragma mark Deferred image loading (UIScrollViewDelegate)

//Load images for all onscreen rows when scrolling is finished

 - (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
	{
        [self loadImagesForOnscreenRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}

#pragma mark - Table view delegate

/*
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize labelsize;
    UILabel * textDesc1 = [[UILabel alloc] init];
    [textDesc1 setNumberOfLines:0];
    textDesc1.text=[self.allTweets objectAtIndex:indexPath.row];
    [textDesc1 setFont:[UIFont fontWithName:@"Helvetica" size:14.0]];
    labelsize=[textDesc1.text sizeWithFont:textDesc1.font constrainedToSize:CGSizeMake(268, 2000.0) lineBreakMode:UILineBreakModeWordWrap];
    labelsize.height=labelsize.height+35;
    return (CGFloat)labelsize.height; 
}*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

@end
