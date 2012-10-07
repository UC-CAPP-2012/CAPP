//
//  BlabberViewController.m
//  Eric Test CTCCA Project
//
//  Created by CTCCA on 8/10/12.
//
//

#import "BlabberViewController.h"
#import "BlabberStoryViewController.h"
#import "News.h"
#import "EventFilterViewController.h"
#import <EventKitUI/EventKitUI.h>
#import <EventKit/EventKit.h>
#import "Listing.h"
#import "MainTypeClass.h"
#import "SearchArray.h"
#import "SaveToFavorites.h"
#import "SideSwipeTableViewCell.h"

@interface BlabberViewController ()
- (void)startIconDownload:(News *)news forIndexPath:(NSIndexPath *)indexPath;
@end

@implementation BlabberViewController
@synthesize newsListString, newsListingsList, newsListingTable;
@synthesize currentNews;
@synthesize imageDownloadsInProgress;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated{
    [self setupArray];
    [tableView reloadData];
    
    loadView.hidden=TRUE;
    
}


- (void)viewDidLoad
{
    [super setTitle:@"Blabber"];
    
    [super viewDidLoad];
    self.imageDownloadsInProgress = [NSMutableDictionary dictionary];

	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];

}

-(void) setupArray // Connection to DataSource
{
    [NSThread detachNewThreadSelector:@selector(threadStartAnimating:) toTarget:self withObject:nil];
    
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"news.xml"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:data];
    
    //NSString * urlString = [NSString stringWithFormat:@"http://itp2012.com/CMS/IPHONE/subscribe.php?Name=%@&Postcode=%@&Email=%@&Subscribe=%@", x1,x2,y1,y2];
    //NSString *urlString = [NSString stringWithFormat:@"http://www.itp2012.com/CMS/IPHONE/AroundMe.php?x1=-36&x2=-34&y1=150&y2=149"];
    //NSURL *url = [[NSURL alloc] initWithString:urlString];
    //NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    
    
    [xmlParser setDelegate:self];
    
    BOOL worked = [xmlParser parse];
    
    if(worked) {
        NSLog(@"Amount %i", [newsListString count]);
    }
    else
    {
        NSLog(@"did not work!");
    }
    
    //This needs to be set via the filter and sorter.
    newsListingsList = [[NSMutableArray alloc] init]; //Complete List of Listings
    newsListingTable = [[NSMutableArray alloc] init]; //List Displayed in the Table
    
    [newsListingTable removeAllObjects]; // Clear Table
    for (NewsString *newsStringElement in  newsListString) {
        
        News *currNews = [[News alloc] init];
        
        // ListingID , Title , SubTitle
        
        currNews.NewsID = [newsStringElement.NewsID stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        currNews.NewsHeading = [newsStringElement.NewsHeading stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        currNews.NewsAuthor = [newsStringElement.NewsAuthor stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        currNews.NewsBody = newsStringElement.NewsBody;
        currNews.NewsPublisher = [newsStringElement.NewsPublisher stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
        
        // Listing View details
        NSString *urlTemp = [newsStringElement.NewsMediaURL stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        NSString *mediaUrlString = [[NSString stringWithFormat:urlTemp] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        currNews.NewsMediaURL = [NSURL URLWithString:mediaUrlString];
        
        // Publish Date
        currNews.NewsDateTime = [newsStringElement.NewsDateTime stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
        // ** CHECKS -------------------------------
        NSLog(@"%@",newsStringElement.NewsID);
        NSLog(@"%@",newsStringElement.NewsHeading);
        NSLog(@"%@",newsStringElement.NewsDateTime);
        NSLog(@"%@",newsStringElement.NewsAuthor);
        NSLog(@"%@",newsStringElement.NewsMediaURL);
        NSLog(@"%@",newsStringElement.NewsPublisher);
        NSLog(@"%@",newsStringElement.NewsBody);
        // -----------------------------------------
        
        [newsListingsList addObject:currNews];
        
    }
    
    NSMutableArray *section = [[NSMutableArray alloc] init];
    for (News *listingListListing in newsListingsList)
    {
        [section addObject:listingListListing];
    }
    
    NSDictionary *sectionDict = [NSDictionary dictionaryWithObject:section forKey:@"News"];
    [newsListingTable addObject:sectionDict];
}


#pragma mark - Table view data source


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NewsCell";
    UITableViewCell *cell = [self->tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    NSDictionary *dictionary = [newsListingTable objectAtIndex:indexPath.section];
    NSArray *array = [dictionary objectForKey:@"News"];
    News *currListing = [array objectAtIndex:indexPath.row];
    // Configure the cell...
    UILabel *cellHeading = (UILabel *)[cell viewWithTag:3];
    [cellHeading setText: currListing.NewsHeading];
    
    UILabel *cellDate = (UILabel *)[cell viewWithTag:2];
    [cellDate setText: currListing.NewsDateTime];
    UILabel *cellFilters = (UILabel *)[cell viewWithTag:4];
    [cellFilters setText: [NSString stringWithFormat:@"%@ | %@", currListing.NewsAuthor, currListing.NewsPublisher]];
    
    UILabel *cellBody = (UILabel *)[cell viewWithTag:5];
    [cellBody setText: currListing.NewsBody];
    
    UIImageView *cellImage = (UIImageView *)[cell viewWithTag:1];
    
    
    
    //dispatch_queue_t concurrentQueue =
    //dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //dispatch_async(concurrentQueue, ^(void){
    if (!currListing.NewsIcon)
    {
        if (self->tableView.dragging == NO && self->tableView.decelerating == NO)
        {
            [self startIconDownload:currListing forIndexPath:indexPath];
        }
        // if a download is deferred or in progress, return a placeholder image
        cellImage.image = [UIImage imageNamed:@"Placeholder.png"];
    }
    else
    {
        cellImage.image = currListing.NewsIcon;
    }
    
    //dispatch_async(dispatch_get_main_queue(), ^{
    //cellImage.image = image;
    
    //});
    //});
    return cell;
}

- (void)startIconDownload:(News *)news forIndexPath:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader == nil)
    {
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.news = news;
        iconDownloader.indexPathInTableView = indexPath;
        iconDownloader.delegate = self;
        [imageDownloadsInProgress setObject:iconDownloader forKey:indexPath];
        [iconDownloader startDownload];
    }
}

// this method is used in case the user scrolled into a set of cells that don't have their app icons yet
- (void)loadImagesForOnscreenRows
{
    if ([newsListingsList count] > 0)
    {
        NSArray *visiblePaths = [tableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            News *news = [self.newsListingsList objectAtIndex:indexPath.row];
            
            if (!news.NewsIcon) // avoid the app icon download if the app already has an icon
            {
                [self startIconDownload:news forIndexPath:indexPath];
            }
        }
    }
}

// called by our ImageDownloader when an icon is ready to be displayed
- (void)appImageDidLoad:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader != nil)
    {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
        
        // Display the newly loaded image
        UIImageView *cellImage = (UIImageView *)[cell viewWithTag:1];
        cellImage.image = iconDownloader.news.NewsIcon;
    }
    
    // Remove the IconDownloader from the in progress list.
    // This will result in it being deallocated.
    [imageDownloadsInProgress removeObjectForKey:indexPath];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [newsListingTable count];
}

- (NSInteger)tableView:(UITableView *)listingTableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *dictionary = [newsListingTable objectAtIndex:section];
    NSArray *array = [dictionary objectForKey:@"News"];
    return [array count];
}

// Load images for all onscreen rows when scrolling is finished
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dictionary = [newsListingTable objectAtIndex:indexPath.section];
    NSArray *array = [dictionary objectForKey:@"News"];
    News *selectedNews = [array objectAtIndex:indexPath.row];
    
    BlabberStoryViewController *listingView = [self.storyboard instantiateViewControllerWithIdentifier:@"BlabberStoryViewController"]; // News Detail Page
    listingView.currentListing = selectedNews;
    [self.navigationController pushViewController:listingView animated:YES];
    NSLog(@"Button");}



// --- XML Delegate Classes ----

-(void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    
    if ([elementName isEqualToString:@"NewsArticles"])
    {
        self.newsListString = [[NSMutableArray alloc] init];
    }
    else if ([elementName isEqualToString:@"News"])
    {
        newsList = [[NewsString alloc] init];
        newsList.NewsID = [[attributeDict objectForKey:@"NewsID"] stringValue];
    }
}

-(void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (!currentElementValue)
    {
        currentElementValue = [[NSMutableString alloc] initWithString:string];
    }
    else
    {
        [currentElementValue appendString:string];
    }
}

-(void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"NewsArticles"])
    {
        return;
    }
    
    if([elementName isEqualToString:@"News"])
    {
        [self.newsListString addObject:newsList];
        newsList = nil;
    }
    else
    {
        [newsList setValue:currentElementValue forKey:elementName];
        NSLog(@"%@",currentElementValue);
        currentElementValue = nil;
    }
}

-(void) threadStartAnimating:(id)data{
    //loadView.hidden = false;
}

- (void)eventEditViewController:(EKEventEditViewController *)controller didCompleteWithAction:(EKEventEditViewAction)action
{
    [self dismissModalViewControllerAnimated:YES];
}

@end
