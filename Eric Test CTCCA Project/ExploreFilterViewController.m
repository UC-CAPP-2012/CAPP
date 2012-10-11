//
//  ExploreFilterViewController.m
//  Eric Test CTCCA Project
//
//  Created by CTCCA on 16/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ExploreFilterViewController.h"
#import "Listing.h"
#import "AreaClass.h"
#import "AreaClassString.h"
#import "MainTypeClass.h"
#import "AreaClassString.h"
#import "SaveToFavorites.h"
#import "SearchArray.h"
#import "SideSwipeTableViewCell.h"
#define USE_GESTURE_RECOGNIZERS YES
#define BOUNCE_PIXELS 5.0
#define PUSH_STYLE_ANIMATION NO

@interface ExploreFilterViewController (PrivateStuff)
- (void) addSwipeViewTo:(UITableViewCell*)cell direction:(UISwipeGestureRecognizerDirection)direction;
- (void) setupGestureRecognizers;
- (void) swipe:(UISwipeGestureRecognizer *)recognizer direction:(UISwipeGestureRecognizerDirection)direction;
@end

@implementation ExploreFilterViewController
PullToRefreshView *pull;
//Passed from previous controller.
@synthesize typeName,typeID;
@synthesize areaFilter;
@synthesize listingsDataSource,listingTable, listingsList,listingsListString;
@synthesize sortHeaders1,sortHeaders2,sortHeaders3,sortHeaders4;
@synthesize currSel,sortSel;
@synthesize areaID;
@synthesize sortID;
@synthesize mapDefault, listDefault;
@synthesize sideSwipeView, sideSwipeCell, sideSwipeDirection, animatingSideSwipe;
// --- Initialisation --

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
    [self segmentButton:self];
    [loadView removeFromSuperview];
}

- (void)viewWillAppear:(BOOL)animated
{
      
}

- (void)viewDidLoad
{
    //Set Title
    self.navigationItem.title = typeName;
    
    //Initialise variables
    
    [self setStartView]; //List or Map selected from last view.
    
    //Top Label Formating - Replace with images when provided.
    areaLabel.layer.borderColor = [UIColor blackColor].CGColor;
    areaLabel.layer.borderWidth = 1.0;
    
    nextArea.layer.borderColor = [UIColor blackColor].CGColor;
    nextArea.layer.borderWidth = 1.0;
    
    previousArea.layer.borderColor = [UIColor blackColor].CGColor;
    previousArea.layer.borderWidth = 1.0;
    
    DetailView.hidden = TRUE;
    DetailView.backgroundColor = [UIColor clearColor];
    
    animatingSideSwipe = NO;
    self.sideSwipeView = [[UIView alloc] initWithFrame:CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y, tableView.frame.size.width, tableView.rowHeight)];
    [self setupSideSwipeView];
    [self setupGestureRecognizers];
    
    [super viewDidLoad];
    pull = [[PullToRefreshView alloc] initWithScrollView:(UIScrollView *) self->tableView];
    [pull setDelegate:self];
    [self->tableView addSubview:pull];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(foregroundRefresh:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
	// Do any additional setup after loading the view.
}

- (void) setupSideSwipeView
{
    // Add the background pattern
    self.sideSwipeView.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"dotted-pattern.png"]];
    
    // Overlay a shadow image that adds a subtle darker drop shadow around the edges
    UIImage* shadow = [UIImage imageNamed:@"inner-shadow.png"];
    UIImageView* shadowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(tableView.frame.origin.x, 0, tableView.frame.size.width, tableView.rowHeight)];
    shadowImageView.alpha = 0.6;
    shadowImageView.image = shadow;
    shadowImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.sideSwipeView addSubview:shadowImageView];
    
    
}

-(void)setStartView
{
    [self setupArea]; //Area Filter
    if (mapDefault == YES) {
        [exploreView bringSubviewToFront:mapWindow];
        [navView bringSubviewToFront:switchMapView];    
        [self setupMap]; //Map View Pan
    }
    if (listDefault == YES) {
        [exploreView bringSubviewToFront:tableView];
        [navView bringSubviewToFront:switchTableView];
        
    }
    
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

- (void)pullToRefreshViewShouldRefresh:(PullToRefreshView *)view;
{
    [self reloadTableData];
    //[self performSelectorInBackground:@selector(reloadTableData) withObject:nil];
}

-(void) reloadTableData
{
    // call to reload your data
    [self segmentButton:self];
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



-(void)setupArea
{
    
    areaFilter = [[NSMutableArray alloc] init];
    
    //Area 1
    AreaClass *area1 = [[AreaClass alloc] init];
    area1.areaID = @"1";
    area1.areaName =@"Civic";
    CLLocationCoordinate2D areaCoordinate;
    areaCoordinate.latitude = -35.281150;
    areaCoordinate.longitude = 149.128668;      
    area1.areaCoordinate = areaCoordinate;
    area1.spanLat = 0.05f;
    area1.spanLong = 0.05f;
    [areaFilter addObject:area1];
    
    //Area 2
    
    AreaClass *area2 = [[AreaClass alloc] init];
    area2.areaID = @"2";
    area2.areaName =@"Gungahlin";
    CLLocationCoordinate2D areaCoordinate2;
    areaCoordinate2.latitude = -35.18471;
    areaCoordinate2.longitude = 149.13254;      
    area2.areaCoordinate = areaCoordinate2;
    area2.spanLat = 0.05f;
    area2.spanLong = 0.05f;    
    [areaFilter addObject:area2];
    
    AreaClass *area3 = [[AreaClass alloc] init];
    area3.areaID = @"3";
    area3.areaName =@"Belconnen";
    CLLocationCoordinate2D areaCoordinate3;
    areaCoordinate3.latitude = -35.23746;
    areaCoordinate3.longitude = 149.06725;      
    area3.areaCoordinate = areaCoordinate3;
    area3.spanLat = 0.05f;
    area3.spanLong = 0.05f;    
    [areaFilter addObject:area3];
    
    AreaClass *area4 = [[AreaClass alloc] init];
    area4.areaID = @"4";
    area4.areaName =@"Tuggeranong";
    CLLocationCoordinate2D areaCoordinate4;
    areaCoordinate4.latitude = -35.41849;
    areaCoordinate4.longitude = 149.06825;      
    area4.areaCoordinate = areaCoordinate4;
    area4.spanLat = 0.05f;
    area4.spanLong = 0.05f;    
    [areaFilter addObject:area4];
    
    AreaClass *area5 = [[AreaClass alloc] init];
    area5.areaID = @"5";
    area5.areaName =@"Woden";
    CLLocationCoordinate2D areaCoordinate5;
    areaCoordinate5.latitude = -35.34700;
    areaCoordinate5.longitude = 149.08568;      
    area5.areaCoordinate = areaCoordinate5;
    area5.spanLat = 0.05f;
    area5.spanLong = 0.05f;    
    [areaFilter addObject:area5];
    
    AreaClass *area6 = [[AreaClass alloc] init];
    area6.areaID = @"6";
    area6.areaName =@"Queanbeyan";
    CLLocationCoordinate2D areaCoordinate6;
    areaCoordinate6.latitude = -35.35492;
    areaCoordinate6.longitude = 149.23125;      
    area6.areaCoordinate = areaCoordinate6;
    area6.spanLat = 0.05f;
    area6.spanLong = 0.05f;    
    [areaFilter addObject:area6];
    
    //------------------------------------------
    
    //initialise title and current selection.  
    currSel = 0;
    previousArea.hidden=TRUE;
    AreaClass *currArea;
    currArea = areaFilter[currSel];
    areaLabel.text = currArea.areaName; 
    
}

// --- END Initialisation --

// -- Datasource -- 

-(void)setupMap
{    
    
    //Map Settings
    [mapView setMapType:MKMapTypeStandard];
    [mapView setZoomEnabled:YES];
    [mapView setScrollEnabled:YES];
    [mapView setDelegate:self];
    
    AreaClass *currArea;
    currArea = areaFilter[currSel];
    
    //Center Map on area location
    MKCoordinateRegion region = {{0.0, 0.0}, {0.0,0.0}};
    region.center = [currArea areaCoordinate];
    region.span.latitudeDelta = [currArea spanLat]; // Zoom Settings
    region.span.longitudeDelta = [currArea spanLong]; // Zoom Settings
    
    [mapView setRegion:region animated:YES];
    
}
-(void) setupArray // Connection to DataSource
{ 
    [mapView removeAnnotations:mapView.annotations];   
    NSXMLParser *xmlParser;
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"AroundMe.php.xml"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    xmlParser = [[NSXMLParser alloc] initWithData:data];
    
    //NSString * urlString = [NSString stringWithFormat:@"http://itp2012.com/CMS/IPHONE/subscribe.php?Name=%@&Postcode=%@&Email=%@&Subscribe=%@", x1,x2,y1,y2];
    //NSString *urlString = [NSString stringWithFormat:@"http://www.itp2012.com/CMS/IPHONE/AroundMe.php?x1=-36&x2=-34&y1=150&y2=149"];
    //NSURL *url = [[NSURL alloc] initWithString:urlString];
    //NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    
    [xmlParser setDelegate:self];
    BOOL worked = [xmlParser parse];
    
    if(worked) {
        NSLog(@"Amount %i", [listingsListString count]);
    }
    else 
    {
        NSLog(@"did not work!");
    }
    
    //This needs to be set via the filter and sorter.    
    listingsList = [[NSMutableArray alloc] init]; //Complete List of Listings
    listingTable = [[NSMutableArray alloc] init]; //List Displayed in the Table
    sortHeaders1 = [[NSMutableArray alloc] init]; //No Headers
    sortHeaders2 = [[NSMutableArray alloc] init]; //Distinct Type Headers
    sortHeaders3 = [[NSMutableArray alloc] init]; //Distinct Rating Headers
    sortHeaders4 = [[NSMutableArray alloc] init]; //Distinct Price Headers
    [listingTable removeAllObjects]; // Clear Table
    for (ListingString *listingStringElement in listingsListString) {
        
        Listing *currListing = [[Listing alloc] init];
        
        // ListingID , Title , SubTitle
        
        currListing.listingID = [listingStringElement.ListingID stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        currListing.listingID = [currListing.listingID stringByReplacingOccurrencesOfString:@"" withString:@""]; 
        currListing.title = [listingStringElement.ListingName stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        currListing.subtitle = [listingStringElement.Subtitle stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
        // Placemarker
        
        CLLocationCoordinate2D tempPlacemarker;  
        
        NSString *tempLat = [listingStringElement.Latitude stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        double latDouble =[tempLat doubleValue];
        tempPlacemarker.latitude = latDouble;
        
        NSString *tempLong = [listingStringElement.Longitude stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        double lonDouble =[tempLong doubleValue];
        tempPlacemarker.longitude = lonDouble; 
        
        currListing.coordinate = tempPlacemarker;
        
        //Sort and Filter Types
        
        currListing.listingType = [listingStringElement.ListingType stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        currListing.areaID = [listingStringElement.AreaID stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        currListing.costType =[listingStringElement.CostType stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        currListing.ratingType = [listingStringElement.RatingType stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        currListing.subType = [listingStringElement.SubType stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
        // Address
        
        currListing.address = [listingStringElement.Address stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
        
        // Listing View details
        
        currListing.details = [listingStringElement.Details stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        currListing.description = [listingStringElement.Description stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        currListing.review = [listingStringElement.Review stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        currListing.imageFilenames = [listingStringElement.ImageURL componentsSeparatedByString:@","];
        
        NSString *urlTemp = [listingStringElement.VideoURL stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        NSString *videoUrlString = [[NSString stringWithFormat:urlTemp] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *webUrlTemp = [listingStringElement.WebsiteURL stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        NSString *webUrlString = [[NSString stringWithFormat:webUrlTemp] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        currListing.videoURL = [NSURL URLWithString:videoUrlString];
        currListing.websiteURL = [NSURL URLWithString:webUrlString];
        
        // Start Date
        
        listingStringElement.startDay = [listingStringElement.StartDay stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        listingStringElement.startMonth = [listingStringElement.StartMonth stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        listingStringElement.startYear = [listingStringElement.StartYear stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        listingStringElement.startMinute = [listingStringElement.StartMinute stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        listingStringElement.startHour = [listingStringElement.StartHour stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
        int startDay =[listingStringElement.StartDay intValue];
        int startMonth =[listingStringElement.StartMonth intValue];
        int startYear =[listingStringElement.StartYear intValue];
        int startMinute =[listingStringElement.StartMinute intValue];
        int startHour =[listingStringElement.StartHour intValue];
        
        NSDateComponents *startcomps = [[NSDateComponents alloc] init];
        [startcomps setDay:startDay];
        [startcomps setMonth:startMonth];
        [startcomps setYear:startYear];
        [startcomps setHour:startHour];
        [startcomps setMinute:startMinute];
        NSCalendar *gregorianStart = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDate *startDate = [gregorianStart dateFromComponents:startcomps];  
        currListing.startDate = startDate;
        
        // End Date
        
        listingStringElement.endDay = [listingStringElement.EndDay stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        listingStringElement.endMonth = [listingStringElement.EndMonth stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        listingStringElement.endYear = [listingStringElement.EndYear stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        listingStringElement.endMinute = [listingStringElement.EndMinute stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        listingStringElement.endHour = [listingStringElement.EndHour stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
        int endDay =[listingStringElement.EndDay intValue];
        int endMonth =[listingStringElement.EndMonth intValue];
        int endYear =[listingStringElement.EndYear intValue];
        int endMinute =[listingStringElement.EndMinute intValue];
        int endHour =[listingStringElement.EndHour intValue];
        
        NSDateComponents *endcomps = [[NSDateComponents alloc] init];
        [endcomps setDay:endDay];
        [endcomps setMonth:endMonth];
        [endcomps setYear:endYear];
        [endcomps setHour:endHour];
        [endcomps setMinute:endMinute];
        NSCalendar *endgregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDate *endDate = [endgregorian dateFromComponents:endcomps];  
        currListing.endDate = endDate;
        
        
        // ** CHECKS ------------------------
        NSLog(@"%@",listingStringElement.ListingName);
        NSLog(@"%@",listingStringElement.Subtitle);
        NSLog(@"%@",listingStringElement.Latitude);
        NSLog(@"%@",listingStringElement.Longitude);
        NSLog(@"%f",latDouble);
        NSLog(@"%f",lonDouble);
        NSLog(@"%@",listingStringElement.ListingID);
        NSLog(@"%@",listingStringElement.ListingType);
        NSLog(@"%@",listingStringElement.AreaID);
        NSLog(@"%@",listingStringElement.CostType);
        NSLog(@"%@",listingStringElement.RatingType);
        NSLog(@"%@",listingStringElement.SubType);
        NSLog(@"%@",listingStringElement.Suburb);    //suburb
        NSLog(@"%@",listingStringElement.Postcode);  //postcode
        NSLog(@"%@",listingStringElement.StateID);   //stateID
        NSLog(@"%@",currListing.address);
        NSLog(@"%@",listingStringElement.Details);
        NSLog(@"%@",listingStringElement.Description);
        NSLog(@"%@",listingStringElement.Review);
        NSLog(@"%@",listingStringElement.ImageURL);
        NSLog(@"%@",listingStringElement.VideoURL);
        NSLog(@"%@",listingStringElement.StartDay);
        NSLog(@"%@",listingStringElement.StartMonth);
        NSLog(@"%@",listingStringElement.StartYear);
        NSLog(@"%@",listingStringElement.StartMinute);
        NSLog(@"%@",listingStringElement.StartHour);
        NSLog(@"%@",listingStringElement.EndDay);
        NSLog(@"%@",listingStringElement.EndMonth);
        NSLog(@"%@",listingStringElement.EndYear);
        NSLog(@"%@",listingStringElement.WebsiteURL);
        NSLog(@"%@",listingStringElement.EndMinute);
        NSLog(@"%@",listingStringElement.EndHour);
        
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
        
        NSString *ratingType = tempListing.ratingType;
        if(![sortHeaders3 containsObject:ratingType])
        {
            [sortHeaders3 addObject:ratingType];
            NSLog(@"%@", ratingType);
        }
        
        NSString *costType = tempListing.costType;
        if(![sortHeaders4 containsObject:costType])
        {
            [sortHeaders4 addObject:costType];
            NSLog(@"%@", costType);
        }
        
        
    }
    
    
    // ** Table View Population
    
    // ---------------------------
    
    // --- SORT 1 Headers ----
    
    [sortHeaders1 addObject:@"TBA"];
    
    // -----------------------
    
    
    [sortHeaders2 sortUsingSelector:@selector(compare:)];
    
    [sortHeaders3 sortUsingSelector:@selector(compare:)];
    
    [sortHeaders4 sortUsingSelector:@selector(compare:)];
    
    // -----------------------
    
    NSMutableArray *section = [[NSMutableArray alloc] init];
    if (sortSel == 0) 
    {
        
        
        for (Listing *listingListListing in listingsList)
        {
            [section addObject:listingListListing]; 
        }
        
        NSDictionary *sectionDict = @{@"Explore": section};
        [listingTable addObject:sectionDict];
    }
    else{
        int count;
        if(sortSel ==1){
            count = [sortHeaders2 count];
        }else if(sortSel == 2){
            count = [sortHeaders3 count];
        }else if(sortSel == 3){
            count = [sortHeaders4 count];
        }
        
        for (int i = 0; i < count; i++)
        {
            
            
            for (Listing *listingListListing in listingsList) 
            {
                NSString *currSortHeader;
                NSString *type;
                if(sortSel ==1){
                    currSortHeader = sortHeaders2[i];
                    type = listingListListing.subType;
                }else if(sortSel == 2){
                    currSortHeader = sortHeaders3[i];
                    type = listingListListing.ratingType;
                }else if(sortSel == 3){
                    currSortHeader = sortHeaders4[i];
                    type = listingListListing.costType;
                }
                
                if ([type isEqualToString:currSortHeader]) 
                {
                    [section addObject:listingListListing];
                }
                
            }
            NSDictionary *sectionDict = @{@"Explore": section};
            [listingTable addObject:sectionDict];
        }
        
    }
    
    [tableView reloadData];
}

// -- END Datasource -- 

// ---- MAP METHODS ----

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
        NSString *imageString = [(((Listing *) view.annotation).imageFilenames)[0] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        DetailImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageString]]];
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
    NSLog(@"didDeselectAnnotationView");
    DetailView.hidden = TRUE;
    view.pinColor = MKPinAnnotationColorRed;
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
// ---- END MAP METHODS ----

// ---- TABLE METHODS ----

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [listingTable count];
}

- (NSInteger)tableView:(UITableView *)listingTableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *dictionary = listingTable[section];
    NSArray *array = dictionary[@"Explore"];
    return [array count];
}

-(UIView *)tableView:(UITableView *)tableViewHeader viewForHeaderInSection:(NSInteger)section
{
    NSMutableArray *sectionHeaders = [[NSMutableArray alloc] init];
    NSString *title = nil;
    
    if (sortSel == 0) { // allphabetically.
        [sectionHeaders removeAllObjects];
        sectionHeaders = [NSArray arrayWithArray:sortHeaders1];
    }
    if (sortSel == 1) { //Type - the Curly one
        [sectionHeaders removeAllObjects];        
        for(NSString *header in sortHeaders2)
        {
            [sectionHeaders addObject:header];
        }
        
    }
    if (sortSel == 2) {  //Rating
        [sectionHeaders removeAllObjects];
        
        for(NSString *header in sortHeaders3)
        {
            [sectionHeaders addObject:header];
        }
    }
    if (sortSel == 3) { // Price
        [sectionHeaders removeAllObjects];        
        for(NSString *header in sortHeaders4)
        {
            [sectionHeaders addObject:header];
        }
    }
    
    UIView *headerView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableViewHeader.bounds.size.width, tableViewHeader.bounds.size.height)];
    [headerView setBackgroundColor:[UIColor yellowColor]];
    UILabel *headerTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableViewHeader.bounds.size.width - 10, 20)];
    
    for (int i = 0; i < [sectionHeaders count]; i++) {
        if (section == i) {
            NSString *currHeaders = sectionHeaders[i];
            title = currHeaders;
        }
    }
    
    headerTitle.text = title;
    headerTitle.textColor = [UIColor blackColor];
    headerTitle.backgroundColor = [UIColor clearColor];
    [headerView addSubview:headerTitle];
    
    return headerView;
}

-(UITableViewCell *)tableView:(UITableView *)listingTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"exploreCell";
    SideSwipeTableViewCell *cell = (SideSwipeTableViewCell*)[listingTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
        cell = [[SideSwipeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    
    NSDictionary *dictionary = listingTable[indexPath.section];
    NSMutableArray *array = dictionary[@"Explore"];
    Listing *currListing = array[indexPath.row];
    NSString *cellValue = currListing.title;
    
    //UIImage* imageheart = [UIImage imageNamed:@"TabHeartIt.png"];
    //UIImage* imagetrail = [UIImage imageNamed:@"ToursAdd.png"];
    
    //cell.textLabel.text = cellValue;
    //cell.imageView.image = image;
    
    //ContentView
    UIImage* image = [UIImage imageNamed:@"star-hollow@2x.png"];
    cell.imageView.image = image;
    
    CGRect Label1Frame = CGRectMake(70, 10, 240, 25);
    CGRect Label2Frame = CGRectMake(70, 33, 240, 25);
    //CGRect Button1Frame = CGRectMake(250, 20, 20, 20);
    
    UILabel *lblTemp;
    //UIButton *btnTemp;
    
    lblTemp = [[UILabel alloc] initWithFrame:Label1Frame];
    lblTemp.text = cellValue;
    [cell.contentView addSubview:lblTemp];
    
    lblTemp = [[UILabel alloc] initWithFrame:Label2Frame];
    lblTemp.text = currListing.subtitle;
    lblTemp.font = [UIFont systemFontOfSize:14];
    [cell.contentView addSubview:lblTemp];
    

    return cell;    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
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
    
    UIImage* imageheart = [UIImage imageNamed:@"TabHeartIt.png"];
    UIImage* imagetrail = [UIImage imageNamed:@"ToursAdd.png"];
    NSIndexPath* indexPath = [tableView indexPathForCell:sideSwipeCell];
    NSDictionary *dictionary = listingTable[indexPath.section];
    NSMutableArray *array = dictionary[@"Explore"];
    Listing *currListing = array[indexPath.row];
    NSString *listingID = currListing.listingID;
    
    //ContentView   
    
    CGRect Button1Frame = CGRectMake(200, 15, 30, 30);
    
    UIButton *btnTemp = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btnTemp =[[UIButton alloc] initWithFrame:Button1Frame];
    [btnTemp setImage:imageheart forState:UIControlStateNormal];
    // Make sure the button ends up in the right place when the cell is resized
    btnTemp.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    
    [self.sideSwipeView addSubview:btnTemp];
    
    //Accessory View
    CGRect Button2Frame = CGRectMake(100, 15, 30, 30);    
    UIButton *btnTemp2 = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btnTemp2 =[[UIButton alloc] initWithFrame:Button2Frame];
    [btnTemp2 setImage:imagetrail forState:UIControlStateNormal];
    // Make sure the button ends up in the right place when the cell is resized
    btnTemp2.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    
    for (int i = 0; i < [listingsList count]; i++) {
        Listing *currentListing = listingsList[i];
        if ([currentListing.listingID isEqualToString:listingID]) {
            btnTemp.tag =i;
            btnTemp2.tag = i;
        }
    }
    
    NSString *cutString = [currListing.listingID stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([SearchArray searchArray:cutString]) {
        [btnTemp setEnabled:FALSE];
    }
    // Add the button to the side swipe view
    [self.sideSwipeView addSubview:btnTemp2];
    
    
    [btnTemp addTarget:self action:@selector(addFavourite:) forControlEvents:UIControlEventTouchUpInside];
    [btnTemp2 addTarget:self action:@selector(addToTrail:) forControlEvents:UIControlEventTouchUpInside];
    
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



-(void)addFavourite:(id)sender  // Control for Map View Button to Listing Detail View   
{      
    NSInteger selectedIndex = ((UIButton*)sender).tag;
    ((UIButton*)sender).enabled = FALSE;
    Listing *selectedListing = listingsList[selectedIndex];
    
    NSString *cutString = [selectedListing.listingID stringByReplacingOccurrencesOfString:@" " withString:@""];
    [SaveToFavorites saveToFavorites:cutString];
    [self removeSideSwipeView:YES];

    NSLog(@"%@",cutString);
    NSLog(@"Button Favourite");
    
}

-(void)addToTrail:(id)sender  // Control for Map View Button to Listing Detail View   
{      
    //NSInteger selectedIndex = ((UIButton*)sender).tag;
    //Listing *selectedListing = [listingsList objectAtIndex:selectedIndex];
    //NSLog(selectedListing.listingID);
    NSLog(@"Button Trail");
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath // Control for Map View Button to Listing Detail View  
{
    NSDictionary *dictionary = listingTable[indexPath.section];
    NSArray *array = dictionary[@"Explore"];
    Listing *selectedEvent = array[indexPath.row];
    
    ListingViewController *listingView = [self.storyboard instantiateViewControllerWithIdentifier:@"ListingViewController"]; // Listing Detail Page
    listingView.currentListing = selectedEvent;
    [self.navigationController pushViewController:listingView animated:YES];
    NSLog(@"Button");
}

// ---- END TABLE METHODS ----

// ---- Buttons ----

-(IBAction)SwitchView {
    
    //Button to switch between Map and Table view
    NSArray *viewArray = exploreView.subviews; //Gathers an arrary of 'view' in the 'aroundMe' stack in order.
    if (viewArray[1] == mapWindow) // change to table view
    {
        // Main Window Animation
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:exploreView cache:YES];
        [exploreView bringSubviewToFront:tableWindow];
        [UIView commitAnimations];
        
        // Navigation Bar Animation
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:navView cache:YES];
        [navView bringSubviewToFront:switchTableView];
        [UIView commitAnimations];
    } 
    else if (viewArray[1] == tableWindow) // change to mapview
    {
        // Main Window Animation
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:exploreView cache:YES];        
        [exploreView bringSubviewToFront:mapWindow];
        [UIView commitAnimations];
        
        // Navigation Bar Animation
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:navView cache:YES];
        [navView bringSubviewToFront:switchMapView];
        [UIView commitAnimations];
        
    }
    
}
-(IBAction)nextArea:(id)sender{
    previousArea.hidden=FALSE;
    currSel = currSel + 1;
    if (currSel == areaFilter.count-1)
    {
        nextArea.hidden=TRUE;
    }
    
    AreaClass *currArea;
    currArea = areaFilter[currSel];
    
    areaID = currArea.areaID;
    areaLabel.text = currArea.areaName; 
    
    [self setupArray];
    [self setupMap];
    
}
-(IBAction)previousArea:(id)sender{
    nextArea.hidden=FALSE;
    currSel = currSel - 1;
    if (currSel == 0)
    {
        previousArea.hidden=TRUE;
    }
    
    AreaClass *currArea;
    currArea = areaFilter[currSel];
    
    areaID = currArea.areaID;
    areaLabel.text = currArea.areaName; 
    
    [self setupArray];
    [self setupMap];
    
}
-(IBAction)segmentButton:(id)sender{
    
    if (segmentController.selectedSegmentIndex == 0) {
        sortSel = 0;
        NSLog(@"Button1");
    }
    else if (segmentController.selectedSegmentIndex == 1) {
        sortSel = 1;
        NSLog(@"Button2");
    }
    else if (segmentController.selectedSegmentIndex == 2) {
        sortSel = 2;
        NSLog(@"Button3");
    }
    else {
        sortSel = 3;
        NSLog(@"Button4");
    }
    [self setupArray];
}

// ---- END Buttons ----

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
        theList.listingID = [attributeDict[@"listingID"] stringValue];
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

-(void)dealloc{
    [self->tableView removeObserver:pull forKeyPath:@"contentOffset"];
}

// View Unload Methods

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// END View Unload Methods
@end
