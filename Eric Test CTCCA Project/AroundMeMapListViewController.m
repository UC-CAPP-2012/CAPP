//
//  MapListViewController.m
//  Eric Test CTCCA Project
//
//  Created by CTCCA on 7/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AroundMeMapListViewController.h"
#import "Listing.h"
#import "ListingString.h"
#import "SaveToFavorites.h"
#import "SearchArray.h"
#import "SideSwipeTableViewCell.h"
#import "AppDelegate.h"
#define USE_GESTURE_RECOGNIZERS YES
#define BOUNCE_PIXELS 5.0
#define PUSH_STYLE_ANIMATION NO

@interface AroundMeMapListViewController (PrivateStuff)
- (void) addSwipeViewTo:(UITableViewCell*)cell direction:(UISwipeGestureRecognizerDirection)direction;
- (void) setupGestureRecognizers;
- (void) swipe:(UISwipeGestureRecognizer *)recognizer direction:(UISwipeGestureRecognizerDirection)direction;

@end

bool errorMsgShown;
@implementation AroundMeMapListViewController
PullToRefreshView *pull;
@synthesize currSel,sortSel, typeListingTable, costListingTable, suburbListingTable;
@synthesize listingTable,listingsTableDataSource,listingsList,listingsListString, filteredTableData;
@synthesize sideSwipeView, sideSwipeCell, sideSwipeDirection, animatingSideSwipe;
@synthesize isFiltered;
@synthesize sortHeaders1,sortHeaders2,sortHeaders3,sortHeaders4, refreshing;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
// *** Initialisation ***

-(void)viewDidAppear:(BOOL)animated
{
    if([listingsList count]==0){
        [self segmentedButton:self];
        [self setupArray];
        [self setupMap];
    }
    
    [loadView removeFromSuperview];
}

-(void)viewWillAppear:(BOOL)animated{
    if([listingsList count]==0){
        tableView.contentOffset = CGPointMake(0, searchBar.frame.size.height);
    }
}


- (void)viewDidLoad
{
    self.navigationItem.title = @"around me";
    DetailView.hidden = TRUE;
    DetailView.backgroundColor = [UIColor clearColor];
    switchTableView.hidden=true;
    switchMapView.hidden=false;
    segmentControll.hidden=TRUE;
    errorMsgShown = NO;
    currSel=0;
    Cost = [[NSMutableArray alloc] init];
    [Cost addObject:@"Free"];
    [Cost addObject:@"$"];
    [Cost addObject:@"$$"];
    [Cost addObject:@"$$$"];
    [Cost addObject:@"$$$$"];
    [Cost addObject:@"$$$$$"];
    [super viewDidLoad];
    pull = [[PullToRefreshView alloc] initWithScrollView:(UIScrollView *) tableView];
    [pull setDelegate:self];
    self.sideSwipeView = [[UIView alloc] initWithFrame:CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y, tableView.frame.size.width, tableView.rowHeight)];
    [self setupSideSwipeView];
    [self setupGestureRecognizers];
    [tableView addSubview:pull];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(foregroundRefresh:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    
	// Do any additional setup after loading the view.
    
}

- (void)pullToRefreshViewShouldRefresh:(PullToRefreshView *)view;
{
    
    tableView.contentOffset = CGPointMake(0, -65);
    [pull setState:PullToRefreshViewStateLoading];
    
    // [self reloadTableData];
    
    [self performSelectorInBackground:@selector(reloadTableData) withObject:nil];
}

-(void) reloadTableData
{
    
    // call to reload your data
    if (segmentControll.selectedSegmentIndex == 0) {
        sortSel = 0;
        NSLog(@"Button1");
    }
    if (segmentControll.selectedSegmentIndex == 1) {
        sortSel = 1;
        NSLog(@"Button2");
    }
    if (segmentControll.selectedSegmentIndex == 2) {
        sortSel = 2;
        NSLog(@"Button3");
    }
    if (segmentControll.selectedSegmentIndex == 3) {
        sortSel = 3;
        NSLog(@"Button4");
    }
    
    [self setupArrayRefresh];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.listingsList = listingsList;
    
    [tableView reloadData];
    [pull finishedLoading];
}

-(void)foregroundRefresh:(NSNotification *)notification
{
    
    //self->tableView.contentOffset = CGPointMake(0, -65);
    //[pull setState:PullToRefreshViewStateLoading];
    //[self reloadTableData];
    //[self performSelectorInBackground:@selector(reloadTableData) withObject:nil];
}


- (void) setupSideSwipeView
{
    // Add the background pattern
    // self.sideSwipeView.backgroundColor = [UIColor colorWithRed:0.0 green:0.8 blue:0.0 alpha:0.5];
    // Overlay a shadow image that adds a subtle darker drop shadow around the edges
    UIImage* shadow = [UIImage imageNamed:@"inner-shadow.png"];
    UIImageView* shadowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(tableView.frame.origin.x, 0, tableView.frame.size.width, tableView.rowHeight)];
    shadowImageView.alpha = 0.2;
    shadowImageView.image = shadow;
    shadowImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.sideSwipeView addSubview:shadowImageView];
    
    
}

- (BOOL) gestureRecognizersSupported
{
    if (!USE_GESTURE_RECOGNIZERS) return NO;
    
    // Apple's docs: Although this class was publicly available starting with iOS 3.2, it was in development a short period prior to that
    // check if it responds to the selector locationInView:. This method was not added to the class until iOS 3.2.
    return [[[UISwipeGestureRecognizer alloc] init] respondsToSelector:@selector(locationInView:)];
}

- (void) setupGestureRecognizers
{
    // Do nothing under 3.x
    if (![self gestureRecognizersSupported]) return;
    
    // Setup a right swipe gesture recognizer
    UISwipeGestureRecognizer* rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
    rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [tableView addGestureRecognizer:rightSwipeGestureRecognizer];
    
    // Setup a left swipe gesture recognizer
    UISwipeGestureRecognizer* leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
    leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [tableView addGestureRecognizer:leftSwipeGestureRecognizer];
}

// Called when a left swipe occurred
- (void)swipeLeft:(UISwipeGestureRecognizer *)recognizer
{
    [self swipe:recognizer direction:UISwipeGestureRecognizerDirectionLeft];
}

// Called when a right swipe ocurred
- (void)swipeRight:(UISwipeGestureRecognizer *)recognizer
{
    [self swipe:recognizer direction:UISwipeGestureRecognizerDirectionRight];
}

// Handle a left or right swipe
- (void)swipe:(UISwipeGestureRecognizer *)recognizer direction:(UISwipeGestureRecognizerDirection)direction
{
    if (recognizer && recognizer.state == UIGestureRecognizerStateEnded)
    {
        // Get the table view cell where the swipe occured
        CGPoint location = [recognizer locationInView:tableView];
        NSIndexPath* indexPath = [tableView indexPathForRowAtPoint:location];
        UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        
        // If we are already showing the swipe view, remove it
        if (cell.frame.origin.x != 0)
        {
            [self removeSideSwipeView:YES];
            return;
        }
        
        // Make sure we are starting out with the side swipe view and cell in the proper location
        [self removeSideSwipeView:NO];
        
        // If this isn't the cell that already has thew side swipe view and we aren't in the middle of animating
        // then start animating in the the side swipe view
        if (cell!= sideSwipeCell && !animatingSideSwipe)
            [self addSwipeViewTo:cell direction:direction];
    }
}

//-(void)mapView:(MKMapView *)mapViewAroundMe didUpdateUserLocation:(MKUserLocation *)userLocation
//{
//    //region.center.longitude = 149.128668;
//    //region.center.latitude = -35.281150;
//
//    NSLog(@" %f",userLocation.location.coordinate.latitude);
//    NSLog(@" %f",userLocation.location.coordinate.longitude);
//
//    MKCoordinateRegion region = {{0.0, 0.0}, {0.0,0.0}};
//    region.center.latitude = userLocation.location.coordinate.latitude;
//    region.center.longitude = userLocation.location.coordinate.longitude;
//    region.span.latitudeDelta = 0.05f; // Zoom Settings
//    region.span.longitudeDelta = 0.05f; // Zoom Settings
//    [mapViewAroundMe setRegion:region animated:YES];
//
//    x1 = userLocation.location.coordinate.latitude + 0.05f;
//    x2 = userLocation.location.coordinate.latitude - 0.05f;
//    y1 = userLocation.location.coordinate.longitude  + 0.05f;
//    y2 = userLocation.location.coordinate.longitude  - 0.05f;
//}



- (IBAction)currentUserLocation:(id)sender {
    //region.center.longitude = 149.128668;
    //region.center.latitude = -35.281150;
    MKUserLocation *userLocation = mapView.userLocation;
    NSLog(@" %f",userLocation.location.coordinate.latitude);
    NSLog(@" %f",userLocation.location.coordinate.longitude);
    
    MKCoordinateRegion region = {{0.0, 0.0}, {0.0,0.0}};
    region.center.latitude = userLocation.location.coordinate.latitude;
    region.center.longitude = userLocation.location.coordinate.longitude;
    region.span.latitudeDelta = 0.05f; // Zoom Settings
    region.span.longitudeDelta = 0.05f; // Zoom Settings
    [mapView setRegion:region animated:YES];
    //
    //    x1 = userLocation.location.coordinate.latitude + 0.05f;
    //    x2 = userLocation.location.coordinate.latitude - 0.05f;
    //    y1 = userLocation.location.coordinate.longitude  + 0.05f;
    //    y2 = userLocation.location.coordinate.longitude  - 0.05f;
}


-(void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"error =%@", error);
}

// *** MAP VIEW Setup ***
-(void) setupMap
{
    [mapView setMapType:MKMapTypeStandard];
    [mapView setZoomEnabled:YES];
    [mapView setScrollEnabled:YES];
    [mapView setDelegate:self];
    mapView.userTrackingMode = YES;
    mapView.showsUserLocation = YES;
    
    //Center Map on area location
    //    MKUserLocation *userLocation = mapView.userLocation;
    //    MKCoordinateRegion region = {{0.0, 0.0}, {0.0,0.0}};
    //    region.center.latitude = userLocation.location.coordinate.latitude;
    //    region.center.longitude = userLocation.location.coordinate.longitude;
    //    region.span.latitudeDelta = 0.15f; // Zoom Settings
    //    region.span.longitudeDelta = 0.25f; // Zoom Settings
    //
    //    [mapView setRegion:region animated:YES];
}

// *** DATA CONNECTION ***

-(void)setupArray // Connection to DataSource
{
    [mapView removeAnnotations:mapView.annotations];
    //[listingsListString removeAllObjects];
    [listingsList removeAllObjects];
    [listingTable removeAllObjects];
    listingsList = [[NSMutableArray alloc] init]; //Complete List of Listings
    listingTable = [[NSMutableArray alloc] init]; //List Displayed in the Table
    typeListingTable = [[NSMutableArray alloc] init]; //List Displayed in the Table
    costListingTable = [[NSMutableArray alloc] init]; //List Displayed in the Table
    suburbListingTable = [[NSMutableArray alloc] init]; //List Displayed in the Table
    sortHeaders1 = [[NSMutableArray alloc] init]; //No Headers
    sortHeaders2 = [[NSMutableArray alloc] init]; //Distinct Type Headers
    sortHeaders3 = [[NSMutableArray alloc] init]; //Distinct Rating Headers
    sortHeaders4 = [[NSMutableArray alloc] init]; //Distinct Price Headers
    [listingTable removeAllObjects]; // Clear Table
    [typeListingTable removeAllObjects]; // Clear Table
    [costListingTable removeAllObjects]; // Clear Table
    [suburbListingTable removeAllObjects]; // Clear Table
    NSMutableArray *section = [[NSMutableArray alloc] init];
    //The strings to send to the webserver.
    
    
    
    //NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"AroundMe.php.xml"];
    //NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    //NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:data];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    listingsList= appDelegate.listingsList;
    //
    
    if([listingsList count]==0){
        [NSThread detachNewThreadSelector:@selector(threadStartAnimating:) toTarget:self withObject:nil];
        
        listingsList = [[NSMutableArray alloc] init];
        NSDate *todaysDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *dateStrToday = [dateFormatter stringFromDate:todaysDate];
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
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                            message:@"Something went wrong. Please make sure you are connected to the internet."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
            if(errorMsgShown==NO){
                [alert show];
                errorMsgShown = YES;
            }
            NSLog(@"did not work!");
        }
        
        
        
        
        for (ListingString *listingStringElement in listingsListString) {
            
            Listing *currListing = [[Listing alloc] init];
            
            // ListingID , Title , SubTitle
            
            currListing.listingID = [listingStringElement.ItemID stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            currListing.listingID = [currListing.listingID stringByReplacingOccurrencesOfString:@"\t" withString:@""];
            currListing.title = [listingStringElement.ItemName stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            currListing.title = [currListing.title stringByReplacingOccurrencesOfString:@"\t" withString:@""];
            
            // Placemarker
            
            CLLocationCoordinate2D tempPlacemarker;
            
            NSString *tempLat = [listingStringElement.Latitude stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            tempLat = [tempLat stringByReplacingOccurrencesOfString:@"\t" withString:@""];
            double latDouble =[tempLat doubleValue];
            tempPlacemarker.latitude = latDouble;
            
            NSString *tempLong = [listingStringElement.Longitude stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            tempLong = [tempLong stringByReplacingOccurrencesOfString:@"\t" withString:@""];
            double lonDouble =[tempLong doubleValue];
            tempPlacemarker.longitude = lonDouble;
            
            currListing.coordinate = tempPlacemarker;
            
            //Sort and Filter Types
            
            currListing.listingType = [listingStringElement.ListingType stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            currListing.listingType = [currListing.listingType stringByReplacingOccurrencesOfString:@"\t" withString:@""];
            currListing.areaID = [listingStringElement.AreaID stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            currListing.areaID = [currListing.areaID stringByReplacingOccurrencesOfString:@"\t" withString:@""];
            currListing.costType =[listingStringElement.Cost stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            currListing.costType =[currListing.costType stringByReplacingOccurrencesOfString:@"\t" withString:@""];
            currListing.subType = [listingStringElement.SubtypeName stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            currListing.subType = [currListing.subType stringByReplacingOccurrencesOfString:@"\t" withString:@""];
            
            // Address
            
            currListing.address = [listingStringElement.Address stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            currListing.address = [currListing.address stringByReplacingOccurrencesOfString:@"\t" withString:@""];
            currListing.majorRegionName = [listingStringElement.MajorRegionName stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            currListing.majorRegionName = [currListing.majorRegionName stringByReplacingOccurrencesOfString:@"\t" withString:@""];
            currListing.phone = [listingStringElement.Phone stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            currListing.phone = [currListing.phone stringByReplacingOccurrencesOfString:@"\t" withString:@""];
            currListing.email = [listingStringElement.Email stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            currListing.email = [currListing.email stringByReplacingOccurrencesOfString:@"\t" withString:@""];
            currListing.suburb = [listingStringElement.Suburb stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            currListing.suburb = [currListing.suburb stringByReplacingOccurrencesOfString:@"\t" withString:@""];
            currListing.openingHours = [listingStringElement.OpeningHours stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            currListing.openingHours = [currListing.openingHours stringByReplacingOccurrencesOfString:@"\t" withString:@""];
            
            // Listing View details
            
            currListing.description = [listingStringElement.Details stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            currListing.description = [currListing.description stringByReplacingOccurrencesOfString:@"\t" withString:@""];
            currListing.imageFilenames = [listingStringElement.ImageURL componentsSeparatedByString:@","];
            currListing.videoURL = [NSURL URLWithString:[[[listingStringElement.VideoURL stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@"\t" withString:@""] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            currListing.websiteURL = [NSURL URLWithString:[[[[listingStringElement.Website stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@"\t" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            currListing.audioURL = [NSURL URLWithString:[[[listingStringElement.AudioURL stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@"\t" withString:@""] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            // Start Date
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            // Start Date
            listingStringElement.StartDate = [listingStringElement.StartDate stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            listingStringElement.StartDate = [listingStringElement.StartDate stringByReplacingOccurrencesOfString:@"\t" withString:@""];
            NSDate *startDate = [dateFormatter dateFromString:listingStringElement.StartDate];
            currListing.startDate = startDate;
            
            // End Date
            listingStringElement.EndDate = [listingStringElement.EndDate stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            listingStringElement.EndDate = [listingStringElement.EndDate stringByReplacingOccurrencesOfString:@"\t" withString:@""];
            NSDate *endDate = [dateFormatter dateFromString:listingStringElement.EndDate];
            currListing.endDate = endDate;
            // ** CHECKS ------------------------
            NSLog(@"%@",listingStringElement.ItemName);
            NSLog(@"%@",listingStringElement.Latitude);
            NSLog(@"%@",listingStringElement.Longitude);
            NSLog(@"%f",latDouble);
            NSLog(@"%f",lonDouble);
            NSLog(@"%@",listingStringElement.ItemID);
            NSLog(@"%@",listingStringElement.ListingType);
            NSLog(@"%@",listingStringElement.AreaID);
            NSLog(@"%@",listingStringElement.Cost);
            NSLog(@"%@",listingStringElement.SubtypeName);
            NSLog(@"%@",listingStringElement.Suburb);    //suburb
            NSLog(@"%@",listingStringElement.Postcode);  //postcode
            NSLog(@"%@",listingStringElement.StateID);   //stateID
            NSLog(@"%@",currListing.address);
            NSLog(@"%@",listingStringElement.Details);
            NSLog(@"%@",listingStringElement.ImageURL);
            NSLog(@"%@",listingStringElement.VideoURL);
            NSLog(@"%@",listingStringElement.StartDate);
            NSLog(@"%@",listingStringElement.EndDate);
            NSLog(@"%@",listingStringElement.Website);
            
            // -----------------------------------------
            
            [listingsList addObject:currListing];
            
            [mapView addAnnotation:currListing];
            
            
            Listing *tempListing = currListing;
            NSString *subType = tempListing.subType;
            if(![sortHeaders2 containsObject:subType])
            {
                [sortHeaders2 addObject:subType];
                NSLog(@"%@", subType);
            }
            
            NSString *cost = tempListing.costType;
            if(![sortHeaders3 containsObject:cost])
            {
                [sortHeaders3 addObject:cost];
                NSLog(@"%@", cost);
            }
            
            NSString *suburb = tempListing.suburb;
            if(![sortHeaders4 containsObject:suburb])
            {
                [sortHeaders4 addObject:suburb];
                NSLog(@"%@", suburb);
            }
            
            
            [section addObject:currListing];
            
        }
        appDelegate.listingsList = listingsList;
        NSDictionary *sectionDict = @{@"AroundMe": section};
        [listingTable addObject:sectionDict];
        
        // ---------------------------
        
        // --- SORT 1 Headers ---- // NAME
        
        [sortHeaders1 addObject:@"All"];
        
        // -----------------------
        
        
        [sortHeaders2 sortUsingSelector:@selector(compare:)];
        
        
        
        [sortHeaders3 sortUsingSelector:@selector(compare:)];
        
        
        
        [sortHeaders4 sortUsingSelector:@selector(compare:)];
        
        // -----------------------
        
        if([listingsList count]>0){
            
            for (int i =0; i < [sortHeaders2 count]; i++){
                NSMutableArray *section2 = [[NSMutableArray alloc] init];
                NSString *currSortHeader = sortHeaders2[i];
                for (Listing *listingListListing in listingsList)
                {
                    NSString *type = listingListListing.subType;
                    
                    if ([type isEqualToString:currSortHeader])
                    {
                        [section2 addObject:listingListListing];
                    }
                }
                NSDictionary *sectionDict2 = @{@"AroundMe": section2};
                [typeListingTable addObject:sectionDict2];
                
            }
            
            for (int i =0; i < [sortHeaders3 count]; i++){
                NSMutableArray *section3 = [[NSMutableArray alloc] init];
                NSString *currSortHeader = sortHeaders3[i];
                for (Listing *listingListListing in listingsList)
                {
                    NSString *type = listingListListing.costType;
                    
                    if ([type isEqualToString:currSortHeader])
                    {
                        [section3 addObject:listingListListing];
                    }
                }
                NSDictionary *sectionDict3 = @{@"AroundMe": section3};
                [costListingTable addObject:sectionDict3];
                
            }
            
            for (int i =0; i < [sortHeaders4 count]; i++){
                NSMutableArray *section4 = [[NSMutableArray alloc] init];
                NSString *currSortHeader = sortHeaders4[i];
                for (Listing *listingListListing in listingsList)
                {
                    NSString *type = listingListListing.suburb;
                    
                    if ([type isEqualToString:currSortHeader])
                    {
                        [section4 addObject:listingListListing];
                    }
                }
                NSDictionary *sectionDict4 = @{@"AroundMe": section4};
                [suburbListingTable addObject:sectionDict4];
                
            }
            
            NSLog(@"%i",[listingTable count]);
            NSLog(@"%i",[typeListingTable count]);
            NSLog(@"%i",[costListingTable count]);
            NSLog(@"%i",[suburbListingTable count]);
        }
        
    }else{
        NSMutableArray *list = appDelegate.listingsList;
        for(int i =0; i<[list count]; i++){
            Listing *listing = (Listing *) list[i];
            [mapView addAnnotation:listing];
            
            Listing *tempListing = listing;
            NSString *subType = tempListing.subType;
            if(![sortHeaders2 containsObject:subType])
            {
                [sortHeaders2 addObject:subType];
                NSLog(@"%@", subType);
            }
            
            NSString *cost = tempListing.costType;
            if(![sortHeaders3 containsObject:cost])
            {
                [sortHeaders3 addObject:cost];
                NSLog(@"%@", cost);
            }
            
            NSString *suburb = tempListing.suburb;
            if(![sortHeaders4 containsObject:suburb])
            {
                [sortHeaders4 addObject:suburb];
                NSLog(@"%@", suburb);
            }
            
            
            [section addObject:listing];
        }
        
        NSDictionary *sectionDict = @{@"AroundMe": section};
        [listingTable addObject:sectionDict];
        
        // ---------------------------
        
        // --- SORT 1 Headers ---- // NAME
        
        [sortHeaders1 addObject:@"All"];
        
        // -----------------------
        
        
        [sortHeaders2 sortUsingSelector:@selector(compare:)];
        
        
        
        [sortHeaders3 sortUsingSelector:@selector(compare:)];
        
        
        
        [sortHeaders4 sortUsingSelector:@selector(compare:)];
        
        // -----------------------
        
        if([listingsList count]>0){
            
            for (int i =0; i < [sortHeaders2 count]; i++){
                NSMutableArray *section2 = [[NSMutableArray alloc] init];
                NSString *currSortHeader = sortHeaders2[i];
                for (Listing *listingListListing in listingsList)
                {
                    NSString *type = listingListListing.subType;
                    
                    if ([type isEqualToString:currSortHeader])
                    {
                        [section2 addObject:listingListListing];
                    }
                }
                NSDictionary *sectionDict2 = @{@"AroundMe": section2};
                [typeListingTable addObject:sectionDict2];
                
            }
            
            for (int i =0; i < [sortHeaders3 count]; i++){
                NSMutableArray *section3 = [[NSMutableArray alloc] init];
                NSString *currSortHeader = sortHeaders3[i];
                for (Listing *listingListListing in listingsList)
                {
                    NSString *type = listingListListing.costType;
                    
                    if ([type isEqualToString:currSortHeader])
                    {
                        [section3 addObject:listingListListing];
                    }
                }
                NSDictionary *sectionDict3 = @{@"AroundMe": section3};
                [costListingTable addObject:sectionDict3];
                
            }
            
            for (int i =0; i < [sortHeaders4 count]; i++){
                NSMutableArray *section4 = [[NSMutableArray alloc] init];
                NSString *currSortHeader = sortHeaders4[i];
                for (Listing *listingListListing in listingsList)
                {
                    NSString *type = listingListListing.suburb;
                    
                    if ([type isEqualToString:currSortHeader])
                    {
                        [section4 addObject:listingListListing];
                    }
                }
                NSDictionary *sectionDict4 = @{@"AroundMe": section4};
                [suburbListingTable addObject:sectionDict4];
                
            }
            
            NSLog(@"%i",[listingTable count]);
            NSLog(@"%i",[typeListingTable count]);
            NSLog(@"%i",[costListingTable count]);
            NSLog(@"%i",[suburbListingTable count]);
        }
        
    }
    [tableView reloadData];
    
}

-(void)setupArrayRefresh // Connection to DataSource
{
    refreshing = TRUE;
    [mapView removeAnnotations:mapView.annotations];
    [listingsList removeAllObjects];
    [listingTable removeAllObjects];
    [NSThread detachNewThreadSelector:@selector(threadStartAnimating:) toTarget:self withObject:nil];
    
    //[listingsListString removeAllObjects];
    
    listingsList = [[NSMutableArray alloc] init]; //Complete List of Listings
    listingTable = [[NSMutableArray alloc] init]; //List Displayed in the Table
    typeListingTable = [[NSMutableArray alloc] init]; //List Displayed in the Table
    costListingTable = [[NSMutableArray alloc] init]; //List Displayed in the Table
    suburbListingTable = [[NSMutableArray alloc] init]; //List Displayed in the Table
    sortHeaders1 = [[NSMutableArray alloc] init]; //No Headers
    sortHeaders2 = [[NSMutableArray alloc] init]; //Distinct Type Headers
    sortHeaders3 = [[NSMutableArray alloc] init]; //Distinct Rating Headers
    sortHeaders4 = [[NSMutableArray alloc] init]; //Distinct Price Headers
    [listingTable removeAllObjects]; // Clear Table
    [typeListingTable removeAllObjects]; // Clear Table
    [costListingTable removeAllObjects]; // Clear Table
    [suburbListingTable removeAllObjects]; // Clear Table
    NSMutableArray *section = [[NSMutableArray alloc] init];
    //The strings to send to the webserver.
    
    
    
    //NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"AroundMe.php.xml"];
    //NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    //NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:data];
    NSDate *todaysDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStrToday = [dateFormatter stringFromDate:todaysDate];
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                        message:@"Something went wrong. Please make sure you are connected to the internet."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        if(errorMsgShown==NO){
            [alert show];
            errorMsgShown = YES;
        }
        NSLog(@"did not work!");
    }
    
    
    
    
    for (ListingString *listingStringElement in listingsListString) {
        
        Listing *currListing = [[Listing alloc] init];
        
        // ListingID , Title , SubTitle
        
        currListing.listingID = [listingStringElement.ItemID stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        currListing.listingID = [currListing.listingID stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        currListing.title = [listingStringElement.ItemName stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        currListing.title = [currListing.title stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        
        // Placemarker
        
        CLLocationCoordinate2D tempPlacemarker;
        
        NSString *tempLat = [listingStringElement.Latitude stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        tempLat = [tempLat stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        double latDouble =[tempLat doubleValue];
        tempPlacemarker.latitude = latDouble;
        
        NSString *tempLong = [listingStringElement.Longitude stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        tempLong = [tempLong stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        double lonDouble =[tempLong doubleValue];
        tempPlacemarker.longitude = lonDouble;
        
        currListing.coordinate = tempPlacemarker;
        
        //Sort and Filter Types
        
        currListing.listingType = [listingStringElement.ListingType stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        currListing.listingType = [currListing.listingType stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        currListing.areaID = [listingStringElement.AreaID stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        currListing.areaID = [currListing.areaID stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        currListing.costType =[listingStringElement.Cost stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        currListing.costType =[currListing.costType stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        currListing.subType = [listingStringElement.SubtypeName stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        currListing.subType = [currListing.subType stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        
        // Address
        
        currListing.address = [listingStringElement.Address stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        currListing.address = [currListing.address stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        currListing.majorRegionName = [listingStringElement.MajorRegionName stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        currListing.majorRegionName = [currListing.majorRegionName stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        currListing.phone = [listingStringElement.Phone stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        currListing.phone = [currListing.phone stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        currListing.email = [listingStringElement.Email stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        currListing.email = [currListing.email stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        currListing.suburb = [listingStringElement.Suburb stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        currListing.suburb = [currListing.suburb stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        currListing.openingHours = [listingStringElement.OpeningHours stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        currListing.openingHours = [currListing.openingHours stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        
        // Listing View details
        
        currListing.description = [listingStringElement.Details stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        currListing.description = [currListing.description stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        currListing.imageFilenames = [listingStringElement.ImageURL componentsSeparatedByString:@","];
        currListing.videoURL = [NSURL URLWithString:[[[listingStringElement.VideoURL stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@"\t" withString:@""] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        currListing.websiteURL = [NSURL URLWithString:[[[[listingStringElement.Website stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@"\t" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        currListing.audioURL = [NSURL URLWithString:[[[listingStringElement.AudioURL stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@"\t" withString:@""] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        // Start Date
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        // Start Date
        listingStringElement.StartDate = [listingStringElement.StartDate stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        listingStringElement.StartDate = [listingStringElement.StartDate stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        NSDate *startDate = [dateFormatter dateFromString:listingStringElement.StartDate];
        currListing.startDate = startDate;
        
        // End Date
        listingStringElement.EndDate = [listingStringElement.EndDate stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        listingStringElement.EndDate = [listingStringElement.EndDate stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        NSDate *endDate = [dateFormatter dateFromString:listingStringElement.EndDate];
        currListing.endDate = endDate;
        // ** CHECKS ------------------------
        NSLog(@"%@",listingStringElement.ItemName);
        NSLog(@"%@",listingStringElement.Latitude);
        NSLog(@"%@",listingStringElement.Longitude);
        NSLog(@"%f",latDouble);
        NSLog(@"%f",lonDouble);
        NSLog(@"%@",listingStringElement.ItemID);
        NSLog(@"%@",listingStringElement.ListingType);
        NSLog(@"%@",listingStringElement.AreaID);
        NSLog(@"%@",listingStringElement.Cost);
        NSLog(@"%@",listingStringElement.SubtypeName);
        NSLog(@"%@",listingStringElement.Suburb);    //suburb
        NSLog(@"%@",listingStringElement.Postcode);  //postcode
        NSLog(@"%@",listingStringElement.StateID);   //stateID
        NSLog(@"%@",currListing.address);
        NSLog(@"%@",listingStringElement.Details);
        NSLog(@"%@",listingStringElement.ImageURL);
        NSLog(@"%@",listingStringElement.VideoURL);
        NSLog(@"%@",listingStringElement.StartDate);
        NSLog(@"%@",listingStringElement.EndDate);
        NSLog(@"%@",listingStringElement.Website);
        
        // -----------------------------------------
        [mapView addAnnotation:currListing];
        [listingsList addObject:currListing];
        
        
        Listing *tempListing = currListing;
        NSString *subType = tempListing.subType;
        if(![sortHeaders2 containsObject:subType])
        {
            [sortHeaders2 addObject:subType];
            NSLog(@"%@", subType);
        }
        
        NSString *cost = tempListing.costType;
        if(![sortHeaders3 containsObject:cost])
        {
            [sortHeaders3 addObject:cost];
            NSLog(@"%@", cost);
        }
        
        NSString *suburb = tempListing.suburb;
        if(![sortHeaders4 containsObject:suburb])
        {
            [sortHeaders4 addObject:suburb];
            NSLog(@"%@", suburb);
        }
        
        
        [section addObject:currListing];
        
    }
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.listingsList = listingsList;
    NSDictionary *sectionDict = @{@"AroundMe": section};
    [listingTable addObject:sectionDict];
    
    // ---------------------------
    
    // --- SORT 1 Headers ---- // NAME
    
    [sortHeaders1 addObject:@"All"];
    
    // -----------------------
    
    
    [sortHeaders2 sortUsingSelector:@selector(compare:)];
    
    
    
    [sortHeaders3 sortUsingSelector:@selector(compare:)];
    
    
    
    [sortHeaders4 sortUsingSelector:@selector(compare:)];
    
    // -----------------------
    
    if([listingsList count]>0){
        
        for (int i =0; i < [sortHeaders2 count]; i++){
            NSMutableArray *section2 = [[NSMutableArray alloc] init];
            NSString *currSortHeader = sortHeaders2[i];
            for (Listing *listingListListing in listingsList)
            {
                NSString *type = listingListListing.subType;
                
                if ([type isEqualToString:currSortHeader])
                {
                    [section2 addObject:listingListListing];
                }
            }
            NSDictionary *sectionDict2 = @{@"AroundMe": section2};
            [typeListingTable addObject:sectionDict2];
            
        }
        
        for (int i =0; i < [sortHeaders3 count]; i++){
            NSMutableArray *section3 = [[NSMutableArray alloc] init];
            NSString *currSortHeader = sortHeaders3[i];
            for (Listing *listingListListing in listingsList)
            {
                NSString *type = listingListListing.costType;
                
                if ([type isEqualToString:currSortHeader])
                {
                    [section3 addObject:listingListListing];
                }
            }
            NSDictionary *sectionDict3 = @{@"AroundMe": section3};
            [costListingTable addObject:sectionDict3];
            
        }
        
        for (int i =0; i < [sortHeaders4 count]; i++){
            NSMutableArray *section4 = [[NSMutableArray alloc] init];
            NSString *currSortHeader = sortHeaders4[i];
            for (Listing *listingListListing in listingsList)
            {
                NSString *type = listingListListing.suburb;
                
                if ([type isEqualToString:currSortHeader])
                {
                    [section4 addObject:listingListListing];
                }
            }
            NSDictionary *sectionDict4 = @{@"AroundMe": section4};
            [suburbListingTable addObject:sectionDict4];
            
        }
        
        NSLog(@"%i",[listingTable count]);
        NSLog(@"%i",[typeListingTable count]);
        NSLog(@"%i",[costListingTable count]);
        NSLog(@"%i",[suburbListingTable count]);
    }
    refreshing = NO;
    [tableView reloadData];
    
}


// *** MAP METHODS ****
-(MKAnnotationView *) mapView:(MKMapView *)mapViewAroundMe viewForAnnotation:(id<MKAnnotation>)annotation
{
    
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"current"];// get a dequeued view for the annotation like a tableview
    
    if (annotationView == nil)
    {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"current"];
    }
    annotationView.annotation = annotation;
    annotationView.canShowCallout = YES; // show the grey popup with location etc
    UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    if ([annotation isKindOfClass:[Listing class]] )
    {
        Listing *current = ((Listing *) annotation);
        for (int i = 0; i < [listingsList count]; i++) {
            Listing *currentListing = listingsList[i];
            if ([currentListing.listingID isEqualToString:current.listingID]) {
                rightButton.tag = i;
            }
        }
        
        [rightButton addTarget:self action:@selector(ListingView:) forControlEvents:UIControlEventTouchUpInside];
        
        annotationView.rightCalloutAccessoryView = rightButton;
    }
    annotationView.image = [UIImage imageNamed:@"map_marker.png"];
    
    annotationView.draggable = NO;
    //annotationView.highlighted = YES;
    //annotationView.animatesDrop = TRUE;
    //annotationView.canShowCallout = NO;
    
    if (annotation == mapViewAroundMe.userLocation) {
        return nil;
    }
    //MyPin.image = [UIImage imageNamed:@"Map-Marker-Marker-Outside-Azure-256.png"];
    //annotationView.annotation = annotation;
    
    return annotationView;
}



-(void)mapView:(MKMapView *)mapViewSelect didSelectAnnotationView:(MKPinAnnotationView *)view
{
    if (view.annotation == mapViewSelect.userLocation) {
        return;
    }
    NSLog(@"didSelectAnnotationView");
    DetailView.hidden = FALSE;
    view.pinColor = MKPinAnnotationColorGreen;
    view.image = [UIImage imageNamed:@"map_marker_green.png"];
    
    if ([view.annotation isKindOfClass:[Listing class]] )
    {
        //Title
        TitleLabel.text = view.annotation.title;
        
        //Address
        AddressLabel.text = ((Listing *) view.annotation).address;
        //
        //        //Start Date
        //        NSDateFormatter *startDateFormat = [[NSDateFormatter alloc] init];
        //        [startDateFormat setDateFormat:@"EEEE','MMMM d'.' KK:mma"];
        //        NSString *startDateString = [startDateFormat stringFromDate:((Listing *) view.annotation).startDate];
        StartDateLabel.text =  ((Listing *) view.annotation).subType;
        // StartDateLabel.text = @"";
        
        //Detail Image
        NSString *imageString = [(((Listing *) view.annotation).imageFilenames)[0] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        DetailImage.image =[UIImage imageNamed:@"Placeholder.png"];
        dispatch_queue_t concurrentQueue =
        dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
        dispatch_async(concurrentQueue, ^(void){
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageString]]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                DetailImage.image = image;
            });
        });
        
        NSLog(@"%@",(((Listing *) view.annotation).imageFilenames)[0]);
        
        //Button Press
        
        NSString *listingID = ((Listing *) view.annotation).listingID;
        for (int i = 0; i < [listingsList count]; i++) {
            Listing *currentListing = listingsList[i];
            if ([currentListing.listingID isEqualToString:listingID]) {
                ListingViewButton.tag = i;
            }
        }
        [ListingViewButton addTarget:self action:@selector(ListingView:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}


-(void)mapView:(MKMapView *)mapViewDeSelect didDeselectAnnotationView:(MKPinAnnotationView *)view
{
    if (view.annotation == mapViewDeSelect.userLocation) {
        return;
    }
    NSLog(@"didDeselectAnnotationView");
    DetailView.hidden = TRUE;
    view.pinColor = MKPinAnnotationColorRed;
    view.image = [UIImage imageNamed:@"map_marker.png"];
}

-(void)ListingView:(id)sender  // Control for Map View Button to Listing Detail View
{
    ListingViewController *listingView = [self.storyboard instantiateViewControllerWithIdentifier:@"ListingViewController"]; // Listing Detail Page
    NSInteger selectedIndex = ((UIButton*)sender).tag;
    Listing *selectedListing = listingsList[selectedIndex];
    listingView.currentListing = selectedListing;
    [self.navigationController pushViewController:listingView animated:YES];
    NSLog(@"%@",selectedListing.listingID);
}

-(void)addFavourite:(id)sender  // Control for Map View Button to Listing Detail View
{
    NSInteger selectedIndex = ((UIButton*)sender).tag;
    
    Listing *selectedListing = listingsList[selectedIndex];
    NSString *cutString = [selectedListing.listingID stringByReplacingOccurrencesOfString:@" " withString:@""];
    [SaveToFavorites saveToFavorites:cutString];
    
    NSLog(@"%@",cutString);
    NSLog(@"Button Favourite");
    
    
    //((UIButton*)sender).imageView.image = [UIImage imageNamed:@"thumbs_down@2x.png"];
    [((UIButton*)sender) setImage:nil forState:UIControlStateNormal];
    [((UIButton*)sender) setImage:nil forState:UIControlStateSelected];
    [((UIButton*)sender) setImage:[UIImage imageNamed:@"thumbs_down@2x.png"] forState:UIControlStateNormal];
    [((UIButton*)sender) setImage:[UIImage imageNamed:@"thumbs_down@2x.png"] forState:UIControlStateSelected];
    //    [((UIButton*)sender) setBackgroundImage:[UIImage imageNamed:@"thumbs_down@2x.png"] forState:UIControlStateApplication];
    //    [((UIButton*)sender) setBackgroundImage:[UIImage imageNamed:@"thumbs_down@2x.png"] forState:UIControlStateDisabled];
    //    [((UIButton*)sender) setBackgroundImage:[UIImage imageNamed:@"thumbs_down@2x.png"] forState:UIControlStateHighlighted];
    //    [((UIButton*)sender) setBackgroundImage:[UIImage imageNamed:@"thumbs_down@2x.png"] forState:UIControlStateReserved];
    [((UIButton*)sender) addTarget:self action:@selector(unfavourite:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)unfavourite:(id)sender
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    //2) Create the full file path by appending the desired file name
    NSString *yourArrayFileName = [documentsDirectory stringByAppendingPathComponent:@"example.dat"];
    NSInteger selectedIndex = ((UIButton*)sender).tag;
    Listing *selectedListing = listingsList[selectedIndex];
    favData = [[NSMutableArray alloc] initWithContentsOfFile: yourArrayFileName];
    for(int i = 0; i<[favData count]; i++){
        if([favData[i] isEqualToString:[selectedListing.listingID stringByReplacingOccurrencesOfString:@" " withString:@""]]){
            [favData removeObjectAtIndex:i];
        }
    }
    [favData writeToFile:yourArrayFileName atomically:YES];
    [((UIButton*)sender) setImage:nil forState:UIControlStateNormal];
    [((UIButton*)sender) setImage:nil forState:UIControlStateSelected];
    [((UIButton*)sender) setImage:[UIImage imageNamed:@"thumbs_up@2x.png"] forState:UIControlStateNormal];
    [((UIButton*)sender) setImage:[UIImage imageNamed:@"thumbs_up@2x.png"] forState:UIControlStateSelected];
    //    [((UIButton*)sender) setBackgroundImage:[UIImage imageNamed:@"Favourites_Icon_Small.png"] forState:UIControlStateApplication];
    //    [((UIButton*)sender) setBackgroundImage:[UIImage imageNamed:@"Favourites_Icon_Small.png"] forState:UIControlStateDisabled];
    //    [((UIButton*)sender) setBackgroundImage:[UIImage imageNamed:@"Favourites_Icon_Small.png"] forState:UIControlStateHighlighted];
    //    [((UIButton*)sender) setBackgroundImage:[UIImage imageNamed:@"Favourites_Icon_Small.png"] forState:UIControlStateReserved];
    //((UIButton*)sender).imageView.image = [UIImage imageNamed:@"Favourites_Icon_Small.png"];
    [((UIButton*)sender) addTarget:self action:@selector(addFavourite:) forControlEvents:UIControlEventTouchUpInside];
    
    
}


// *** END MAP METHODS

// *** TABLE METHODS ***

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(isFiltered){
        return 1;
    }
    else{
        if (sortSel == 0) { // allphabetically.
            return [listingTable count];
        }
        else if (sortSel == 1) { //Type
            return [typeListingTable count];
            
        }
        else if (sortSel == 2) {  //Price
            
            return [costListingTable count];
        }
        else { // Suburb
            return [suburbListingTable count];
        }
        
    }
}
- (NSInteger)tableView:(UITableView *)listingTableView numberOfRowsInSection:(NSInteger)section
{
    if(self.isFiltered){
        return filteredTableData.count;
    }
    else{
        NSDictionary *dictionary;
        if (sortSel == 0) { // allphabetically.
            dictionary= listingTable[section];
        }
        else if (sortSel == 1) { //Type
            dictionary= typeListingTable[section];
        }
        else if (sortSel == 2) {  //Price
            dictionary= costListingTable[section];
        }
        else { // Suburb
            dictionary= suburbListingTable[section];
        }
        
        NSArray *array = dictionary[@"AroundMe"];
        return [array count];
    }
}


-(UIView *)tableView:(UITableView *)tableViewHeader viewForHeaderInSection:(NSInteger)section
{
    NSMutableArray *sectionHeaders = [[NSMutableArray alloc] init];
    NSString *title = nil;
    [sectionHeaders removeAllObjects];
    if(isFiltered){
        NSMutableArray *header= [[NSMutableArray alloc] init];
        [header addObject:@"Search Results"];
        sectionHeaders = [NSArray arrayWithArray:header];
    }
    else{
        if (sortSel == 0) { // allphabetically.
            sectionHeaders = [NSArray arrayWithArray:sortHeaders1];
        }
        else if (sortSel == 1) { //Type
            for(NSString *header in sortHeaders2)
            {
                [sectionHeaders addObject:header];
            }
            
        }
        else if (sortSel == 2) {  //Price
            
            for(NSString *header in sortHeaders3)
            {
                [sectionHeaders addObject: [Cost objectAtIndex:[header intValue]]];
            }
        }
        else if (sortSel == 3) { // Suburb
            for(NSString *header in sortHeaders4)
            {
                [sectionHeaders addObject:header];
            }
        }
    }
    UIView *headerView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableViewHeader.bounds.size.width, tableViewHeader.bounds.size.height)];
    [headerView setBackgroundColor:[UIColor colorWithRed:0.23 green:0.70 blue:0.44 alpha:1]];
    UILabel *headerTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableViewHeader.bounds.size.width - 10, 20)];
    
    for (int i = 0; i < [sectionHeaders count]; i++) {
        if (section == i)
        {
            NSString *currHeaders = sectionHeaders[i];
            title = currHeaders;
        }
        
    }
    
    
    headerTitle.text = title;
    
    headerTitle.textColor = [UIColor whiteColor];
    headerTitle.backgroundColor = [UIColor clearColor];
    [headerView addSubview:headerTitle];
    
    return headerView;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)listingTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"aroundMeCell";
    SideSwipeTableViewCell *cell = (SideSwipeTableViewCell*)[listingTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
        cell = [[SideSwipeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    if(refreshing==NO){
        
        Listing *currListing;
        if(isFiltered)
        {
            currListing = filteredTableData[indexPath.row];
        }
        else
        {
            NSDictionary *dictionary;
            if (sortSel == 0) { // allphabetically.
                dictionary= listingTable[indexPath.section];
            }
            else if (sortSel == 1) { //Type
                dictionary= typeListingTable[indexPath.section];
                
            }
            else if (sortSel == 2) {  //Price
                
                dictionary= costListingTable[indexPath.section];
            }
            else { // Suburb
                dictionary= suburbListingTable[indexPath.section];
            }
            NSArray *array = dictionary[@"AroundMe"];
            currListing= array[indexPath.row];
        }
        
        //UIImage* imageheart = [UIImage imageNamed:@"TabHeartIt.png"];
        //UIImage* imagetrail = [UIImage imageNamed:@"ToursAdd.png"];
        
        //cell.textLabel.text = cellValue;
        //cell.imageView.image = image;
        
        //ContentView
        UIImage* image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",currListing.subType]];
        if(image==NULL){
            image = [UIImage imageNamed:@"star-hollow@2x.png"];
        }
        cell.imageView.image = image;
        
        UILabel *cellHeading = (UILabel *)[cell viewWithTag:2];
        [cellHeading setText: currListing.title];
        
        UILabel *cellSubtype = (UILabel *)[cell viewWithTag:3];
        [cellSubtype setText: currListing.suburb];
        
    }
    return cell;
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
    [searchBar resignFirstResponder];
    
    NSDictionary *dictionary;
    if (sortSel == 0) { // allphabetically.
        dictionary= listingTable[indexPath.section];
    }
    else if (sortSel == 1) { //Type
        dictionary= typeListingTable[indexPath.section];
        
    }
    else if (sortSel == 2) {  //Price
        
        dictionary= costListingTable[indexPath.section];
    }
    else { // Suburb
        dictionary= suburbListingTable[indexPath.section];
    }
    NSArray *array = dictionary[@"AroundMe"];
    Listing *selectedEvent;
    
    if(isFiltered)
    {
        selectedEvent = filteredTableData[indexPath.row];
    }
    else
    {
        selectedEvent = array[indexPath.row];
    }
    
    ListingViewController *listingView = [self.storyboard instantiateViewControllerWithIdentifier:@"ListingViewController"]; // Listing Detail Page
    listingView.currentListing = selectedEvent;
    [self.navigationController pushViewController:listingView animated:YES];
    NSLog(@"Button");
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (void)tableView:(UITableView *)theTableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    // If we are using gestures, then don't do anything
    if ([self gestureRecognizersSupported]) return;
    
    // Get the table view cell where the swipe occured
    UITableViewCell* cell = [theTableView cellForRowAtIndexPath:indexPath];
    
    // Make sure we are starting out with the side swipe view and cell in the proper location
    [self removeSideSwipeView:NO];
    
    // If this isn't the cell that already has thew side swipe view and we aren't in the middle of animating
    // then start animating in the the side swipe view. We don't have access to the direction, so we always assume right
    if (cell!= sideSwipeCell && !animatingSideSwipe)
        [self addSwipeViewTo:cell direction:UISwipeGestureRecognizerDirectionRight];
}

// Apple's docs: To enable the swipe-to-delete feature of table views (wherein a user swipes horizontally across a row to display a Delete button), you must implement the tableView:commitEditingStyle:forRowAtIndexPath: method.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // If we are using gestures, then don't allow editing
    if ([self gestureRecognizersSupported])
        return NO;
    else
        return YES;
}

#pragma mark Adding the side swipe view
- (void) addSwipeViewTo:(UITableViewCell*)cell direction:(UISwipeGestureRecognizerDirection)direction
{
    // Change the frame of the side swipe view to match the cell
    sideSwipeView.frame = cell.frame;
    
    // Add the side swipe view to the table below the cell
    [tableView insertSubview:sideSwipeView belowSubview:cell];
    
    // Remember which cell the side swipe view is displayed on and the swipe direction
    self.sideSwipeCell = cell;
    sideSwipeDirection = direction;
    
    CGRect cellFrame = cell.frame;
    if (PUSH_STYLE_ANIMATION)
    {
        // Move the side swipe view offscreen either to the left or the right depending on the swipe direction
        sideSwipeView.frame = CGRectMake(direction == UISwipeGestureRecognizerDirectionRight ? -cellFrame.size.width : cellFrame.size.width, cellFrame.origin.y, cellFrame.size.width, cellFrame.size.height);
        
        
    }
    else
    {
        // Move the side swipe view to offset 0
        sideSwipeView.frame = CGRectMake(0, cellFrame.origin.y, cellFrame.size.width, cellFrame.size.height);
    }
    
    UIImage* imageheart = [UIImage imageNamed:@"thumbs_up@2x.png"];
    NSIndexPath* indexPath = [tableView indexPathForCell:sideSwipeCell];
    NSDictionary *dictionary;
    if (sortSel == 0) { // allphabetically.
        dictionary= listingTable[indexPath.section];
    }
    else if (sortSel == 1) { //Type
        dictionary= typeListingTable[indexPath.section];
        
    }
    else if (sortSel == 2) {  //Price
        
        dictionary= costListingTable[indexPath.section];
    }
    else { // Suburb
        dictionary= suburbListingTable[indexPath.section];
    }
    
    NSMutableArray *array = dictionary[@"AroundMe"];
    Listing *currListing = array[indexPath.row];
    
    //ContentView
    CGRect Button1Frame = CGRectMake(150, 10, 30, 30);
    UIButton *btnTemp = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btnTemp =[[UIButton alloc] initWithFrame:Button1Frame];
    
    // Make sure the button ends up in the right place when the cell is resized
    btnTemp.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    
    
    for (int i = 0; i < [listingsList count]; i++) {
        Listing *currentListing = listingsList[i];
        if ([currentListing.listingID isEqualToString:currListing.listingID]) {
            btnTemp.tag =i;
        }
    }
    
    
    [btnTemp setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1]];
    
    
    NSString *cutString = [currListing.listingID stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([SearchArray searchArray:cutString]) {
        [btnTemp setImage:nil forState:UIControlStateNormal];
        [btnTemp setImage:nil forState:UIControlStateSelected];
        //btnTemp.imageView.image = [UIImage imageNamed:@"thumbs_down@2x.png"];
        [btnTemp setImage:[UIImage imageNamed:@"thumbs_down@2x.png"] forState:UIControlStateNormal];
        [btnTemp setImage:[UIImage imageNamed:@"thumbs_down@2x.png"] forState:UIControlStateSelected];
        //[btnTemp setBackgroundImage:[UIImage imageNamed:@"thumbs_down@2x.png"] forState:UIControlStateApplication];
        //[btnTemp setBackgroundImage:[UIImage imageNamed:@"thumbs_down@2x.png"] forState:UIControlStateDisabled];
        //[btnTemp setBackgroundImage:[UIImage imageNamed:@"thumbs_down@2x.png"] forState:UIControlStateHighlighted];
        //[btnTemp setBackgroundImage:[UIImage imageNamed:@"thumbs_down@2x.png"] forState:UIControlStateReserved];
        [btnTemp addTarget:self action:@selector(unfavourite:) forControlEvents:UIControlEventTouchUpInside];
    }
    else{
        [btnTemp setImage:nil forState:UIControlStateNormal];
        [btnTemp setImage:nil forState:UIControlStateSelected];
        [btnTemp setImage:imageheart forState:UIControlStateNormal];
        [btnTemp setImage:imageheart forState:UIControlStateSelected];
        //        [btnTemp setBackgroundImage:imageheart forState:UIControlStateApplication];
        //        [btnTemp setBackgroundImage:imageheart forState:UIControlStateHighlighted];
        //        [btnTemp setBackgroundImage:imageheart forState:UIControlStateDisabled];
        //        [btnTemp setBackgroundImage:imageheart forState:UIControlStateReserved];
        [btnTemp addTarget:self action:@selector(addFavourite:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.sideSwipeView addSubview:btnTemp];
    
    
    // Animate in the side swipe view
    animatingSideSwipe = YES;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStopAddingSwipeView:finished:context:)];
    if (PUSH_STYLE_ANIMATION)
    {
        // Move the side swipe view to offset 0
        // While simultaneously moving the cell's frame offscreen
        // The net effect is that the side swipe view is pushing the cell offscreen
        sideSwipeView.frame = CGRectMake(0, cellFrame.origin.y, cellFrame.size.width, cellFrame.size.height);
    }
    cell.frame = CGRectMake(direction == UISwipeGestureRecognizerDirectionRight ? cellFrame.size.width : -cellFrame.size.width, cellFrame.origin.y, cellFrame.size.width, cellFrame.size.height);
    [UIView commitAnimations];
}

// Note that the animation is done
- (void)animationDidStopAddingSwipeView:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    animatingSideSwipe = NO;
}

#pragma mark Removing the side swipe view
// UITableViewDelegate
// When a row is selected, animate the removal of the side swipe view
- (NSIndexPath *)tableView:(UITableView *)theTableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self removeSideSwipeView:YES];
    return indexPath;
}

// UIScrollViewDelegate
// When the table is scrolled, animate the removal of the side swipe view
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self removeSideSwipeView:YES];
}

// When the table is scrolled to the top, remove the side swipe view
- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    [self removeSideSwipeView:NO];
    return YES;
}

// Remove the side swipe view.
// If animated is YES, then the removal is animated using a bounce effect
- (void) removeSideSwipeView:(BOOL)animated
{
    // Make sure we have a cell where the side swipe view appears and that we aren't in the middle of animating
    if (!sideSwipeCell || animatingSideSwipe) return;
    
    if (animated)
    {
        // The first step in a bounce animation is to move the side swipe view a bit offscreen
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        if (sideSwipeDirection == UISwipeGestureRecognizerDirectionRight)
        {
            if (PUSH_STYLE_ANIMATION)
                sideSwipeView.frame = CGRectMake(-sideSwipeView.frame.size.width + BOUNCE_PIXELS,sideSwipeView.frame.origin.y,sideSwipeView.frame.size.width, sideSwipeView.frame.size.height);
            sideSwipeCell.frame = CGRectMake(BOUNCE_PIXELS, sideSwipeCell.frame.origin.y, sideSwipeCell.frame.size.width, sideSwipeCell.frame.size.height);
        }
        else
        {
            if (PUSH_STYLE_ANIMATION)
                sideSwipeView.frame = CGRectMake(sideSwipeView.frame.size.width - BOUNCE_PIXELS,sideSwipeView.frame.origin.y,sideSwipeView.frame.size.width, sideSwipeView.frame.size.height);
            sideSwipeCell.frame = CGRectMake(-BOUNCE_PIXELS, sideSwipeCell.frame.origin.y, sideSwipeCell.frame.size.width, sideSwipeCell.frame.size.height);
        }
        animatingSideSwipe = YES;
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationDidStopOne:finished:context:)];
        [UIView commitAnimations];
    }
    else
    {
        [sideSwipeView removeFromSuperview];
        sideSwipeCell.frame = CGRectMake(0,sideSwipeCell.frame.origin.y,sideSwipeCell.frame.size.width, sideSwipeCell.frame.size.height);
        self.sideSwipeCell = nil;
    }
}

#pragma mark Bounce animation when removing the side swipe view
// The next step in a bounce animation is to move the side swipe view a bit on screen
- (void)animationDidStopOne:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    if (sideSwipeDirection == UISwipeGestureRecognizerDirectionRight)
    {
        if (PUSH_STYLE_ANIMATION)
            sideSwipeView.frame = CGRectMake(-sideSwipeView.frame.size.width + BOUNCE_PIXELS*2,sideSwipeView.frame.origin.y,sideSwipeView.frame.size.width, sideSwipeView.frame.size.height);
        sideSwipeCell.frame = CGRectMake(BOUNCE_PIXELS*2, sideSwipeCell.frame.origin.y, sideSwipeCell.frame.size.width, sideSwipeCell.frame.size.height);
    }
    else
    {
        if (PUSH_STYLE_ANIMATION)
            sideSwipeView.frame = CGRectMake(sideSwipeView.frame.size.width - BOUNCE_PIXELS*2,sideSwipeView.frame.origin.y,sideSwipeView.frame.size.width, sideSwipeView.frame.size.height);
        sideSwipeCell.frame = CGRectMake(-BOUNCE_PIXELS*2, sideSwipeCell.frame.origin.y, sideSwipeCell.frame.size.width, sideSwipeCell.frame.size.height);
    }
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStopTwo:finished:context:)];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView commitAnimations];
}

// The final step in a bounce animation is to move the side swipe completely offscreen
- (void)animationDidStopTwo:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    [UIView commitAnimations];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    if (sideSwipeDirection == UISwipeGestureRecognizerDirectionRight)
    {
        if (PUSH_STYLE_ANIMATION)
            sideSwipeView.frame = CGRectMake(-sideSwipeView.frame.size.width ,sideSwipeView.frame.origin.y,sideSwipeView.frame.size.width, sideSwipeView.frame.size.height);
        sideSwipeCell.frame = CGRectMake(0, sideSwipeCell.frame.origin.y, sideSwipeCell.frame.size.width, sideSwipeCell.frame.size.height);
    }
    else
    {
        if (PUSH_STYLE_ANIMATION)
            sideSwipeView.frame = CGRectMake(sideSwipeView.frame.size.width ,sideSwipeView.frame.origin.y,sideSwipeView.frame.size.width, sideSwipeView.frame.size.height);
        sideSwipeCell.frame = CGRectMake(0, sideSwipeCell.frame.origin.y, sideSwipeCell.frame.size.width, sideSwipeCell.frame.size.height);
    }
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStopThree:finished:context:)];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView commitAnimations];
}

// When the bounce animation is completed, remove the side swipe view and reset some state
- (void)animationDidStopThree:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    animatingSideSwipe = NO;
    self.sideSwipeCell = nil;
    [sideSwipeView removeFromSuperview];
}


// *** END TABLE METHODS

// Switch View Method

-(IBAction)SwitchView {
    
    // Also I haven't primed the array, yet it still works?
    
    //Button to switch between Map and Table view
    NSArray *viewArray = aroundMe.subviews; //Gathers an arrary of 'view' in the 'aroundMe' stack in order.
    if (viewArray[1] == mapWindow) // change to table view
    {
        // Main Window Animation
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:aroundMe cache:YES];
        segmentControll.hidden=FALSE;
        [aroundMe bringSubviewToFront:tableView];
        [UIView commitAnimations];
        
        // Navigation Bar Animation
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:navView cache:YES];
        switchTableView.hidden=false;
        switchMapView.hidden=true;
        
        [navView bringSubviewToFront:switchTableView];
        [UIView commitAnimations];
        
    }
    else if (viewArray[1] == tableView) // change to mapview
    {
        // Main Window Animation
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:aroundMe cache:YES];
        segmentControll.hidden=TRUE;
        [aroundMe bringSubviewToFront:mapWindow];
        [UIView commitAnimations];
        
        // Navigation Bar Animation
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:navView cache:YES];
        
        switchTableView.hidden=true;
        switchMapView.hidden=false;
        
        [navView bringSubviewToFront:switchMapView];
        [UIView commitAnimations];
        
    }
    
}

// END Switch View Method

-(void)searchBar:(UISearchBar*)searchBarUI textDidChange:(NSString*)text
{
    if(text.length == 0)
    {
        isFiltered = FALSE;
        [searchBarUI resignFirstResponder];
    }
    else
    {
        isFiltered = true;
        filteredTableData = [[NSMutableArray alloc] init];
        
        for (Listing* listingSearch in listingsList)
        {
            NSRange nameRange = [listingSearch.title rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange suburbRange = [listingSearch.suburb rangeOfString:text options:NSCaseInsensitiveSearch];
            
            if(nameRange.location != NSNotFound || suburbRange.location!=NSNotFound)
            {
                [filteredTableData addObject:listingSearch];
            }
        }
    }
    
    [tableView reloadData];
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





- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) threadStartAnimating:(id)data{
    loadView.hidden = false;
}


- (IBAction)segmentedButton:(id)sender {
    if (segmentControll.selectedSegmentIndex == 0) {
        sortSel = 0;
        NSLog(@"Button1");
    }
    if (segmentControll.selectedSegmentIndex == 1) {
        sortSel = 1;
        NSLog(@"Button2");
    }
    if (segmentControll.selectedSegmentIndex == 2) {
        sortSel = 2;
        NSLog(@"Button3");
    }
    if (segmentControll.selectedSegmentIndex == 3) {
        sortSel = 3;
        NSLog(@"Button4");
    }
    [tableView reloadData];
}
@end
