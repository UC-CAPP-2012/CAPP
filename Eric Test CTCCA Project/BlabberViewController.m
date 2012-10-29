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

@interface BlabberViewController ()
- (void)startIconDownload:(News *)news forIndexPath:(NSIndexPath *)indexPath;
@end

int currentLimit = 1;
int limit = 1;
int numOfNews = 0;
@implementation BlabberViewController
PullToRefreshView *pull;
@synthesize newsListString, newsListingsList, newsListingTable;
@synthesize currentNews;
@synthesize imageDownloadsInProgress;
@synthesize filteredTableData;
@synthesize isFiltered;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated{
    if([newsListingsList count]==0){
        [self setupArray];
    }
    [tableView reloadData];
    
    [loadView removeFromSuperview];
    loadMoreView.hidden = false;
}

-(void)viewWillAppear:(BOOL)animated{
    tableView.contentOffset = CGPointMake(0, self.searchBar.frame.size.height);
}

- (void)viewDidLoad
{
    [super setTitle:@"blabber"];
    numOfNews = 0;
    currentLimit=limit;
    loadMoreView.hidden = true;
    loadMoreIndicator.hidden = true;
    [super viewDidLoad];
    self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
	//searchBar.delegate = (id)self;
    pull = [[PullToRefreshView alloc] initWithScrollView:(UIScrollView *) self->tableView];
    [pull setDelegate:self];
    [self->tableView addSubview:pull];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(foregroundRefresh:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setSearchBar:nil];
    [super viewDidUnload];
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
    
//    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"news.xml"];
//    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
//    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:data];
    
    NSString * urlString = [NSString stringWithFormat:@"http://imaginecup.ise.canberra.edu.au/PhpScripts/Blabber.php?limit=%i",currentLimit];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    
    
    [xmlParser setDelegate:self];
    
    BOOL worked = [xmlParser parse];
    
    if(worked) {
        NSLog(@"Amount %i", [newsListString count]);
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                        message:@"Something went wrong. Please make sure you are connected to the internet."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];

        NSLog(@"did not work!");
    }
    
    //This needs to be set via the filter and sorter.
    newsListingsList = [[NSMutableArray alloc] init]; //Complete List of Listings
    newsListingTable = [[NSMutableArray alloc] init]; //List Displayed in the Table
    NSMutableArray *section = [[NSMutableArray alloc] init];
    [newsListingTable removeAllObjects]; // Clear Table
    for (NewsString *newsStringElement in  newsListString) {
        
        News *currNews = [[News alloc] init];
        
        // ListingID , Title , SubTitle
        
        currNews.NewsID = [newsStringElement.NewsID stringByReplacingOccurrencesOfString:@"\n" withString:@""];
         currNews.NewsID = [currNews.NewsID stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        currNews.NewsHeading = [newsStringElement.NewsHeading stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        currNews.NewsHeading = [currNews.NewsHeading stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        currNews.NewsAuthor = [newsStringElement.NewsAuthor stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        currNews.NewsBody = [newsStringElement.NewsBody stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        currNews.NewsPublisher = [newsStringElement.NewsPublisher stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
        
        // Listing View details
        NSString *imageName = [newsStringElement.NewsMediaURL stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        currNews.NewsMediaURL = [NSURL URLWithString:[imageName stringByReplacingOccurrencesOfString:@"\t" withString:@""]];
        // Publish Date
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *published = [dateFormatter dateFromString:[newsStringElement.NewsDateTime stringByReplacingOccurrencesOfString:@"\n" withString:@""]];
        [dateFormatter setDateFormat:@"dd/MM/yyyy"];
        currNews.NewsDateTime = [dateFormatter stringFromDate:published];
        
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
        [section addObject:currNews];
        
    }
    
    
    NSDictionary *sectionDict = @{@"News": section};
    [newsListingTable addObject:sectionDict];
    if(numOfNews==[newsListingsList count]){
        loadMorebtn.hidden = true;
        loadMoreIndicator.hidden = true;
    }
    else{
        numOfNews = [newsListingsList count];
    }
}


#pragma mark - Table view data source


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NewsCell";
    UITableViewCell *cell = [self->tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    NSDictionary *dictionary = newsListingTable[indexPath.section];
    NSArray *array = dictionary[@"News"];
    News *currListing;
    if(isFiltered)
        currListing = filteredTableData[indexPath.row];
    else
        currListing = array[indexPath.row];

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

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
    if(text.length == 0)
    {
        isFiltered = FALSE;
    }
    else
    {
        isFiltered = true;
        filteredTableData = [[NSMutableArray alloc] init];
        
        for (News* news in newsListingsList)
        {
            NSRange nameRange = [news.NewsHeading rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange descriptionRange = [news.NewsBody rangeOfString:text options:NSCaseInsensitiveSearch];
            if(nameRange.location != NSNotFound || descriptionRange.location != NSNotFound)
            {
                [filteredTableData addObject:news];
            }
        }
    }
    
    [tableView reloadData];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self showDetailsForIndexPath:indexPath];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self showDetailsForIndexPath:indexPath];
}

-(void) showDetailsForIndexPath:(NSIndexPath*)indexPath
{
    [self.searchBar resignFirstResponder];
    NSDictionary *dictionary = newsListingTable[indexPath.section];
    NSArray *array = dictionary[@"News"];
    News* selectedNews;
    
    if(isFiltered)
    {
        selectedNews = filteredTableData[indexPath.row];
    }
    else
    {
        selectedNews = array[indexPath.row];
    }
    
    
    
    BlabberStoryViewController *listingView = [self.storyboard instantiateViewControllerWithIdentifier:@"BlabberStoryViewController"]; // News Detail Page
    listingView.currentListing = selectedNews;
    [self.navigationController pushViewController:listingView animated:YES];
    NSLog(@"Button");
}



-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (void)startIconDownload:(News *)news forIndexPath:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = imageDownloadsInProgress[indexPath];
    if (iconDownloader == nil)
    {
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.news = news;
        iconDownloader.indexPathInTableView = indexPath;
        iconDownloader.delegate = self;
        imageDownloadsInProgress[indexPath] = iconDownloader;
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
            News *news = (self.newsListingsList)[indexPath.row];
            
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
    IconDownloader *iconDownloader = imageDownloadsInProgress[indexPath];
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
    NSDictionary *dictionary = newsListingTable[section];
    NSArray *array = dictionary[@"News"];
    int rowCount;
    if(self.isFiltered)
        rowCount = filteredTableData.count;
    else
        rowCount = [array count];
    
    return rowCount;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 135;
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


- (void)pullToRefreshViewShouldRefresh:(PullToRefreshView *)view;
{
    //[self reloadTableData];
    [self performSelectorInBackground:@selector(reloadTableData) withObject:nil];
}

-(void) reloadTableData
{
    // call to reload your data
    [self setupArray];
    loadView.hidden=TRUE;
    [self->tableView reloadData];
    [pull finishedLoading];
}

-(void)foregroundRefresh:(NSNotification *)notification
{
    //self->tableView.contentOffset = CGPointMake(0, -65);
    //[pull setState:PullToRefreshViewStateLoading];
    //[self reloadTableData];
    //[self performSelectorInBackground:@selector(reloadTableData) withObject:nil];
}





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
        newsList.NewsID = [attributeDict[@"NewsID"] stringValue];
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

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:@"contentOffset"];
}

-(void) threadStartAnimating:(id)data{
    loadView.hidden = false;
}

- (void)eventEditViewController:(EKEventEditViewController *)controller didCompleteWithAction:(EKEventEditViewAction)action
{
    [self dismissModalViewControllerAnimated:YES];
}


- (IBAction)loadMoreNews:(id)sender {
    currentLimit +=limit;
    loadMoreIndicator.hidden = false;
    dispatch_queue_t concurrentQueue =
    dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(concurrentQueue, ^(void){
    
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setupArray];
            [tableView reloadData];
    loadMoreIndicator.hidden = true;
        });
    });
}
@end
