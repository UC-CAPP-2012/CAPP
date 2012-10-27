//
//  HomePageViewController.m
//  Eric Test CTCCA Project
//
//  Created by CTCCA on 23/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HomePageViewController.h"

@interface HomePageViewController ()

@end

@implementation HomePageViewController
@synthesize listingsListString;
@synthesize toolBar;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    if([listingsListString count]==0){
        [self setupArray];
    }
    [super viewDidLoad];
 
	// Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];

}

-(void)skipScreen
{
    //[self.navigationController setNavigationBarHidden:NO];
    EventFilterViewController *eventView = [self.storyboard instantiateViewControllerWithIdentifier:@"EventFilterViewController"];
    eventView.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;//UIModalTransitionStyleCoverVertical;
    [self presentModalViewController:eventView animated:YES];
    [self.navigationController setNavigationBarHidden:NO];
    NSLog(@"Button"); 
}

//Buttons
-(void)spinWheel:(id)sender // Control for Map View Button to Listing Detail View   
{
    //[self.navigationController setNavigationBarHidden:NO];
    PickerViewController *pickerView = [self.storyboard instantiateViewControllerWithIdentifier:@"PickerViewController"]; // Listing Detail Page
    pickerView.title = @"Spinwheel";
    [self.navigationController pushViewController:pickerView animated:YES];
    [self.navigationController setNavigationBarHidden:NO];
    NSLog(@"spinWheel");
    
}
-(void)blabber:(id)sender  // Control for Map View Button to Listing Detail View   
{
    //[self.navigationController setNavigationBarHidden:NO];
    BlabberViewController *blabberView = [self.storyboard instantiateViewControllerWithIdentifier:@"BlabberViewController"]; // Listing Detail Page
    [self.navigationController pushViewController:blabberView animated:YES];
    [self.navigationController setNavigationBarHidden:NO];
    //NSLog(@"Button");
    
}
-(void)aroundMe:(id)sender  // Control for Map View Button to Listing Detail View   
{
    //[self.navigationController setNavigationBarHidden:NO];
    AroundMeMapListViewController *aroundMeView = [self.storyboard instantiateViewControllerWithIdentifier:@"AroundMeMapListViewController"];
    aroundMeView.listingsListString = listingsListString;
    [self.navigationController pushViewController:aroundMeView animated:YES];
    [self.navigationController setNavigationBarHidden:NO];
    NSLog(@"Button");
    
}
-(void)explore:(id)sender  // Control for Map View Button to Listing Detail View   
{   
    //[self.navigationController setNavigationBarHidden:NO];
    ExploreScrollViewPagingController *exploreView = [self.storyboard instantiateViewControllerWithIdentifier:@"ExploreScrollViewPagingController"];
    [self.navigationController pushViewController:exploreView animated:YES];
    [self.navigationController setNavigationBarHidden:NO];
    NSLog(@"Button");
    
}
-(void)jaunts:(id)sender  // Control for Map View Button to Listing Detail View   
{
    //[self.navigationController setNavigationBarHidden:NO];
    TourMapListViewController *tourView = [self.storyboard instantiateViewControllerWithIdentifier:@"TourMapListViewController"]; // Listing Detail Page
    [self.navigationController pushViewController:tourView animated:YES];
    [self.navigationController setNavigationBarHidden:NO];
    NSLog(@"Button");
    
}
-(void)happenings:(id)sender  // Control for Map View Button to Listing Detail View   
{
    //[self.navigationController setNavigationBarHidden:NO];
    EventFilterViewController *eventView = [self.storyboard instantiateViewControllerWithIdentifier:@"EventFilterViewController"];
    [self.navigationController pushViewController:eventView animated:YES];
    [self.navigationController setNavigationBarHidden:NO];
    NSLog(@"Button");
    
}
-(void)loved:(id)sender // Control for Map View Button to Listing Detail View   
{
    //[self.navigationController setNavigationBarHidden:NO];
    FavoritesViewController *favoritesView = [self.storyboard instantiateViewControllerWithIdentifier:@"FavoritesViewController"]; // Listing Detail Page
    [self.navigationController pushViewController:favoritesView animated:YES];
    [self.navigationController setNavigationBarHidden:NO];
    NSLog(@"loved");
    
}
-(void)myTrial:(id)sender  // Control for Map View Button to Listing Detail View   
{      
    //ListingViewController *listingView = [self.storyboard instantiateViewControllerWithIdentifier:@"ListingViewController"]; // Listing Detail Page
    //[self.navigationController pushViewController:listingView animated:YES];
    NSLog(@"myTrial");
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// *** DATA CONNECTION ***

-(void)setupArray // Connection to DataSource
{
    [listingsListString removeAllObjects];
    
    //The strings to send to the webserver.
    
    NSDate *todaysDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStrToday = [dateFormatter stringFromDate:todaysDate];
    
    //NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"AroundMe.php.xml"];
    //NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    //NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:data];
    
    NSString *urlString = [NSString stringWithFormat:@"http://imaginecup.ise.canberra.edu.au/PhpScripts/AroundMe.php?today=%@",dateStrToday];
    
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    
    
    [xmlParser setDelegate:self];
    
    BOOL worked = [xmlParser parse];
    
    if(worked) {
        NSLog(@"Amount %i", [listingsListString count]);
    }
    else
    {
        NSLog(@"did not work!");
    }
}

// --- XML Delegate Classes ----

-(void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"ListingElements"])
    {
        self.listingsListString = [[NSMutableArray alloc] init];
    }
    else if ([elementName isEqualToString:@"ListingElement"])
    {
        theList = [[ListingString alloc] init];
        theList.ItemID = [attributeDict[@"listingID"] stringValue];
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
    if ([elementName isEqualToString:@"ListingElements"])
    {
        return;
    }
    
    if([elementName isEqualToString:@"ListingElement"])
    {
        [self.listingsListString addObject:theList];
        theList = nil;
    }
    else
    {
        [theList setValue:currentElementValue forKey:elementName];
        NSLog(@"%@",currentElementValue);
        currentElementValue = nil;
    }
}


@end
