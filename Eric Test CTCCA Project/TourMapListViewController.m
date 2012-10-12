//
//  AreaMapListViewController.m
//  Eric Test CTCCA Project
//
//  Created by CTCCA on 11/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TourMapListViewController.h"
#import "Tour.h"
#import <EventKitUI/EventKitUI.h>
#import <EventKit/EventKit.h>

@interface TourMapListViewController ()
- (void)startIconDownload:(Tour *)tourCurrent forIndexPath:(NSIndexPath *)indexPath;
@end

@implementation TourMapListViewController
PullToRefreshView *pull;
@synthesize tourListString, tourListingsList, tourListingTable;
@synthesize currentTour;
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

-(void)viewDidAppear:(BOOL)animated
{
    
    [self setupArray];
    [tableView reloadData];
    loadView.hidden = YES;
}

-(void)viewWillAppear:(BOOL)animated{
    tableView.contentOffset = CGPointMake(0, self.searchBar.frame.size.height);
}

// *** Initialisation ***
- (void)viewDidLoad
{
    
    DetailView.hidden = TRUE;
    DetailView.backgroundColor = [UIColor clearColor];
    
    self.navigationItem.title = @"Tours";
    [super viewDidLoad];
    self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
    
    pull = [[PullToRefreshView alloc] initWithScrollView:(UIScrollView *) self->tableView];
    [pull setDelegate:self];
    [self->tableView addSubview:pull];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(foregroundRefresh:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
	// Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
    
}

// *** MAP VIEW Setup ***
-(void) setupMap
{
    // NEED TO ADD A RESTRICTION!
    // NEED TO TEST OUTSIDE OF CANBERRA
    // mapView user location coordinate may not work...
    
    //Map Settings
    [mapView setMapType:MKMapTypeStandard];
    [mapView setZoomEnabled:YES];
    [mapView setScrollEnabled:YES];
    [mapView setDelegate:self];
    
    //Center Map on users location;
    //CLLocationCoordinate2D zoomLocation;
    MKCoordinateRegion region = {{0.0, 0.0}, {0.0,0.0}};
    region.center.latitude = -35.281150; //mapView.userLocation.location.coordinate.latitude;
    region.center.longitude = 149.128668; //mapView.userLocation.location.coordinate.longitude;
    region.span.latitudeDelta = 0.05f; // Zoom Settings
    region.span.longitudeDelta = 0.05f; // Zoom Settings
    [mapView setRegion:region animated:YES];
    
    //Place marker on user
    //mapView.showsUserLocation = YES; // Shows User Location  
    
    //if (filter == nil) {
    //Do actions for map population for filter.
    //Do action for list population for filter.
    //}
    
    // *** DUMMY DATA ***
    
    
}

// *** DATA CONNECTION ***

-(void) setupArray // Connection to DataSource
{ 
    
    [mapView removeAnnotations:mapView.annotations];
    NSXMLParser *xmlParser;
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"tour.xml"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    xmlParser = [[NSXMLParser alloc] initWithData:data];
    
    //NSString * urlString = [NSString stringWithFormat:@"http://itp2012.com/CMS/IPHONE/subscribe.php?Name=%@&Postcode=%@&Email=%@&Subscribe=%@", x1,x2,y1,y2];
    //NSString *urlString = [NSString stringWithFormat:@"http://www.itp2012.com/CMS/IPHONE/AroundMe.php?x1=-36&x2=-34&y1=150&y2=149"];
    //NSURL *url = [[NSURL alloc] initWithString:urlString];
    //NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    
    [xmlParser setDelegate:self];
    BOOL worked = [xmlParser parse];
    
    if(worked) {
        NSLog(@"Amount %i", [tourListString count]);
    }
    else
    {
        NSLog(@"did not work!");
    }

    //This needs to be set via the filter and sorter.
    tourListingsList = [[NSMutableArray alloc] init]; //Complete List of Listings
    tourListingTable = [[NSMutableArray alloc] init]; //List Displayed in the Table
    NSMutableArray *section = [[NSMutableArray alloc] init];
    [tourListingTable removeAllObjects]; // Clear Table
    for (TourString *tourStringElement in  tourListString) {
        
        Tour *currTour = [[Tour alloc] init];
        
        // TourID , Title , SubTitle
        
        currTour.TourID = [tourStringElement.TourID stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        currTour.TourName = [tourStringElement.TourName stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        currTour.TourDetail = [tourStringElement.TourDetail stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        currTour.TourCost = tourStringElement.TourCost;
        currTour.TourEmail = [tourStringElement.TourEmail stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        currTour.TourPhone = [tourStringElement.TourPhone stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        currTour.ImageFileNames = [tourStringElement.ImageURL componentsSeparatedByString:@","];
        
        // Listing View details
        NSString *urlTemp = [tourStringElement.TourWebsite stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        NSString *mediaUrlString = [[NSString stringWithFormat:urlTemp] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        currTour.TourWebsite = [NSURL URLWithString:mediaUrlString];
        
        NSString *urlTemp2 = [tourStringElement.VideoURL stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        NSString *mediaUrlString2 = [[NSString stringWithFormat:urlTemp2] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        currTour.VideoURL = [NSURL URLWithString:mediaUrlString2];
        
        // ** CHECKS -------------------------------
        NSLog(@"%@",tourStringElement.TourID);
        NSLog(@"%@",tourStringElement.TourName);
        NSLog(@"%@",tourStringElement.TourDetail);
        NSLog(@"%@",tourStringElement.TourCost);
        NSLog(@"%@",tourStringElement.TourEmail);
        NSLog(@"%@",tourStringElement.TourPhone);
        NSLog(@"%@",tourStringElement.TourWebsite);
        // -----------------------------------------
        
        [tourListingsList addObject:currTour];
        [section addObject:currTour];
        
    }
        
    NSDictionary *sectionDict = @{@"Tours": section};
    [tourListingTable addObject:sectionDict];

}

// *** MAP METHODS ****

// *** MAP METHODS ****

-(MKAnnotationView *) mapView:(MKMapView *)mapViewAroundMe viewForAnnotation:(id<MKAnnotation>)annotation 
{
    
    MKPinAnnotationView *MyPin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"current"];     
    MyPin.pinColor = MKPinAnnotationColorRed;
    
    MyPin.draggable = NO;
    MyPin.highlighted = YES;
    MyPin.animatesDrop = TRUE;
    MyPin.canShowCallout = NO;
    
    if (annotation == mapViewAroundMe.userLocation) {
        return nil;
    }
    //MyPin.image = [UIImage imageNamed:@"Map-Marker-Marker-Outside-Azure-256.png"];
    //MyPin.annotation = annotation;
    
    return MyPin;
}


-(void)mapView:(MKMapView *)mapViewSelect didSelectAnnotationView:(MKPinAnnotationView *)view
{
    NSLog(@"didSelectAnnotationView");
    DetailView.hidden = FALSE;
    view.pinColor = MKPinAnnotationColorGreen;
    
    if ([view.annotation isKindOfClass:[Listing class]] )
    {
        //Title
        TitleLabel.text = view.annotation.title;
        
        //Address
        AddressLabel.text = ((Listing *) view.annotation).address;
        
        //Start Date
        NSDateFormatter *startDateFormat = [[NSDateFormatter alloc] init];
        [startDateFormat setDateFormat:@"EEEE','MMMM d'.' KK:mma"];
        NSString *startDateString = [startDateFormat stringFromDate:((Listing *) view.annotation).startDate];
        StartDateLabel.text = startDateString;
        
        //Detail Image    
        DetailImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:(((Listing *) view.annotation).imageFilenames)[0]]]];
    }
    
}


-(void)mapView:(MKMapView *)mapViewDeSelect didDeselectAnnotationView:(MKPinAnnotationView *)view
{
    NSLog(@"didDeselectAnnotationView");
    DetailView.hidden = TRUE;
    view.pinColor = MKPinAnnotationColorRed;
}

// *** END MAP METHODS

// *** TABLE METHODS ***

- (void)pullToRefreshViewShouldRefresh:(PullToRefreshView *)view;
{
    [self reloadTableData];
    
    //[self performSelectorInBackground:@selector(reloadTableData) withObject:nil];
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
    
    self->tableView.contentOffset = CGPointMake(0, -65);
    [pull setState:PullToRefreshViewStateLoading];
    [self reloadTableData];
    //[self performSelectorInBackground:@selector(reloadTableData) withObject:nil];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [tourListingTable count];
}

- (NSInteger)tableView:(UITableView *)listingTableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *dictionary = tourListingTable[section];
    NSArray *array = dictionary[@"Tours"];
    int rowCount;
    if(self.isFiltered)
        rowCount = filteredTableData.count;
    else
        rowCount = [array count];
    
    return rowCount;

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 103;
}

-(UITableViewCell *)tableView:(UITableView *)listingTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"tourCell";
    UITableViewCell *cell = (UITableViewCell *) [listingTableView dequeueReusableCellWithIdentifier:cellIdentifier];

    NSDictionary *dictionary = tourListingTable[indexPath.section];
    NSArray *array = dictionary[@"Tours"];
    
    Tour *cellValue;
    if(isFiltered)
        cellValue = filteredTableData[indexPath.row];
    else
        cellValue = array[indexPath.row];

    if(cell == nil) 
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
         
    UIImageView *cellImage = (UIImageView *)[cell viewWithTag:4];
    if (!cellValue.TourIcon)
    {
        if (self->tableView.dragging == NO && self->tableView.decelerating == NO)
        {
            [self startIconDownload:cellValue forIndexPath:indexPath];
        }
        // if a download is deferred or in progress, return a placeholder image
        cellImage.image = [UIImage imageNamed:@"Placeholder.png"];
    }
    else
    {
        cellImage.image = cellValue.TourIcon;
    }

    UILabel *cellHeading = (UILabel *)[cell viewWithTag:1];
    [cellHeading setText: cellValue.TourName];
    
    UILabel *cellSubtitle = (UILabel *)[cell viewWithTag:2];
    [cellSubtitle setText: [cellValue.TourWebsite absoluteString]];

    UILabel *cellDetail = (UILabel *)[cell viewWithTag:3];
    [cellDetail setText: cellValue.TourDetail];
        
    return cell;    
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
        
        for (Tour* tourSearch in tourListingsList)
        {
            NSRange nameRange = [tourSearch.TourName rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange descriptionRange = [tourSearch.TourDetail rangeOfString:text options:NSCaseInsensitiveSearch];
            if(nameRange.location != NSNotFound || descriptionRange.location != NSNotFound)
            {
                [filteredTableData addObject:tourSearch];
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
    NSDictionary *dictionary = tourListingTable[indexPath.section];
    NSArray *array = dictionary[@"Tours"];
    Tour* selectedTour;
    
    if(isFiltered)
    {
        selectedTour = filteredTableData[indexPath.row];
    }
    else
    {
        selectedTour = array[indexPath.row];
    }
    
    
    
    //BlabberStoryViewController *listingView = [self.storyboard instantiateViewControllerWithIdentifier:@"BlabberStoryViewController"]; // News Detail Page
    //listingView.currentListing = selectedNews;
    //[self.navigationController pushViewController:listingView animated:YES];
    NSLog(@"Button");
}


// *** END TABLE METHODS

// Switch View Method

-(IBAction)SwitchView {
    
    // Will need to insert program view sequence.
    
    //Button to switch between Map and Table view
    NSArray *viewArray = tour.subviews; //Gathers an arrary of 'view' in the 'aroundMe' stack in order.
    if (viewArray[1] == mapWindow) // change to table view
    {
        // Main Window Animation
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:tour cache:YES];
        [tour bringSubviewToFront:tableView];
        [UIView commitAnimations];
        
        // Navigation Bar Animation
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:navView cache:YES];
        [navView bringSubviewToFront:switchTableView];
        [UIView commitAnimations];
    } 
    else if (viewArray[1] == tableView) // change to mapview
    {
        // Main Window Animation
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:tour cache:YES];        
        [tour bringSubviewToFront:mapWindow];
        [UIView commitAnimations];
        
        // Navigation Bar Animation
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:navView cache:YES];
        [navView bringSubviewToFront:switchMapView];
        [UIView commitAnimations];
        [self setupMap];
    }
    
}

// END Switch View Method

- (void)viewDidUnload
{
    [self setSearchBar:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// --- XML Delegate Classes ----

-(void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    
    if ([elementName isEqualToString:@"Tours"])
    {
        self.tourListString = [[NSMutableArray alloc] init];
    }
    else if ([elementName isEqualToString:@"Tour"])
    {
        tourList = [[TourString alloc] init];
        tourList.TourID = [attributeDict[@"TourID"] stringValue];
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
    if ([elementName isEqualToString:@"Tours"])
    {
        return;
    }
    
    if([elementName isEqualToString:@"Tour"])
    {
        [self.tourListString addObject:tourList];
        tourList = nil;
    }
    else
    {
        [tourList setValue:currentElementValue forKey:elementName];
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


- (void)startIconDownload:(Tour *)tourCurrent forIndexPath:(NSIndexPath *)indexPath
{
    ToursIconDownloader *iconDownloader = imageDownloadsInProgress[indexPath];
    if (iconDownloader == nil)
    {
        iconDownloader = [[ToursIconDownloader alloc] init];
        iconDownloader.tour = tourCurrent;
        iconDownloader.indexPathInTableView = indexPath;
        iconDownloader.delegate = self;
        imageDownloadsInProgress[indexPath] = iconDownloader;
        [iconDownloader startDownload];
    }
}

// this method is used in case the user scrolled into a set of cells that don't have their app icons yet
- (void)loadImagesForOnscreenRows
{
    if ([tourListingsList count] > 0)
    {
        NSArray *visiblePaths = [tableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            Tour *tourCurrent = (self.tourListingsList)[indexPath.row];
            
            if (!tourCurrent.TourIcon) // avoid the app icon download if the app already has an icon
            {
                [self startIconDownload:tourCurrent forIndexPath:indexPath];
            }
        }
    }
}

// called by our ImageDownloader when an icon is ready to be displayed
- (void)appImageDidLoad:(NSIndexPath *)indexPath
{
    ToursIconDownloader *iconDownloader = imageDownloadsInProgress[indexPath];
    if (iconDownloader != nil)
    {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
        
        // Display the newly loaded image
        UIImageView *cellImage = (UIImageView *)[cell viewWithTag:4];
        cellImage.image = iconDownloader.tour.TourIcon;
    }
    
    // Remove the IconDownloader from the in progress list.
    // This will result in it being deallocated.
    [imageDownloadsInProgress removeObjectForKey:indexPath];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:@"contentOffset"];
}
@end