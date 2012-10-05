//
//  BlabberTableViewController.m
//  Eric Test CTCCA Project
//
//  Created by Hassna Alqarni on 4/10/12.
//
//

#import "BlabberTableViewController.h"
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
@interface BlabberTableViewController ()

@end

@implementation BlabberTableViewController

@synthesize newsListString, newsListingsList, newsListingTable;
@synthesize currentNews;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated{
    [tableView reloadData];
    loadView.hidden=TRUE;
    
}

- (void)viewDidLoad
{
    [super setTitle:@"Blabber"];
    [self setupArray];
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        currNews.NewsBody = [newsStringElement.NewsBody stringByReplacingOccurrencesOfString:@"\n" withString:@""];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
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
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:currListing.NewsMediaURL]];
        
        //dispatch_async(dispatch_get_main_queue(), ^{
            cellImage.image = image;
            
        //});
    //});
    return cell;
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
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
    loadView.hidden = false;
}

- (void)eventEditViewController:(EKEventEditViewController *)controller didCompleteWithAction:(EKEventEditViewAction)action
{
    [self dismissModalViewControllerAnimated:YES];
}

@end
