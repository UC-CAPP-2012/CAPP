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

@interface ExploreFilterViewController ()

@end

@implementation ExploreFilterViewController

//Passed from previous controller.
@synthesize typeName,typeID;
@synthesize areaFilter;
@synthesize listingsDataSource,listingTable, listingsList,listingsListString;
@synthesize sortHeaders1,sortHeaders2,sortHeaders3,sortHeaders4;
@synthesize currSel,sortSel;
@synthesize areaID;
@synthesize sortID;
@synthesize mapDefault, listDefault;

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
    [self setupArea]; //Area Filter
    [self setupMap]; //Map View Pan
    [self setupArray]; //Listings
    [tableView reloadData];
    [self segmentButton:self];
     loadView.hidden = YES;
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
                                   
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
-(void)setStartView
{
    if (mapDefault == YES) {
        [exploreView bringSubviewToFront:mapWindow];
        [navView bringSubviewToFront:switchMapView];    }
    if (listDefault == YES) {
        [exploreView bringSubviewToFront:tableView];
        [navView bringSubviewToFront:switchTableView];    }
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
    currArea = [areaFilter objectAtIndex:currSel];
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
    currArea = [areaFilter objectAtIndex:currSel];
    
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
    
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"AroundMe.php.xml"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:data];
    
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
        
        currListing.address = [NSString stringWithFormat:@"%@ ,%@ %@ %@ %@",listingStringElement.UnitNumber,listingStringElement.StreetName, listingStringElement.StreetType, listingStringElement.Suburb,listingStringElement.Postcode];//,listingStringElement.StateID];
        currListing.address = [currListing.address stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
        
        // Listing View details
        
        currListing.details = [listingStringElement.Details stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        currListing.description = [listingStringElement.Description stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        currListing.review = [listingStringElement.Review stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        currListing.imageFilenames = [listingStringElement.ImageURL componentsSeparatedByString:@","];
        //currListing.videoURL = [[NSURL alloc] initWithString:listingStringElement.videoURL];
        //currListing.websiteURL = [[NSURL alloc] initWithString:listingStringElement.websiteURL];
        
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
        NSLog(@"%@",listingStringElement.UnitNumber); //unitnumber
        NSLog(@"%@",listingStringElement.StreetName); //streetname
        NSLog(@"%@",listingStringElement.StreetType); //streettype
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
        
    }
    
    
    // ** Table View Population
    
    // ---------------------------
    
    // --- SORT 1 Headers ----
    
    [sortHeaders1 addObject:@"TBA"];
    
    // -----------------------

    
    // --- Sort 2 Headers ---- // SubType
    
    for (int i = 0; i < [listingsList count]; i++) {
        Listing *tempListing = [listingsList objectAtIndex:i];
        NSString *subType = tempListing.subType;
        if(![sortHeaders2 containsObject:subType])
        {
            [sortHeaders2 addObject:subType];
            NSLog(@"%@", subType);
        }
    }
    
    [sortHeaders2 sortUsingSelector:@selector(compare:)];
    
    //}
    
    //--- SORT 3 Headers -----    //Rating
    
    for (int i = 0; i < [listingsList count]; i++) {
        Listing *tempListing = [listingsList objectAtIndex:i];
        NSString *ratingType = tempListing.ratingType;
        if(![sortHeaders3 containsObject:ratingType])
        {
            [sortHeaders3 addObject:ratingType];
            NSLog(@"%@", ratingType);
        }
    }
    
    [sortHeaders3 sortUsingSelector:@selector(compare:)];
    
    //--- SORT 4 Headers ----- // Costs

    for (int i = 0; i < [listingsList count]; i++) {
        Listing *tempListing = [listingsList objectAtIndex:i];
        NSString *costType = tempListing.costType;
        if(![sortHeaders4 containsObject:costType])
        {
            [sortHeaders4 addObject:costType];
            NSLog(@"%@", costType);
        }
    }
    
    [sortHeaders4 sortUsingSelector:@selector(compare:)];
        
    // -----------------------
    
    
    if (sortSel == 0) 
    {
        [listingTable removeAllObjects]; // Clear Table
        NSMutableArray *section = [[NSMutableArray alloc] init];
        for (Listing *listingListListing in listingsList)
        {
            [section addObject:listingListListing]; 
        }
        
        NSDictionary *sectionDict = [NSDictionary dictionaryWithObject:section forKey:@"Explore"];
        [listingTable addObject:sectionDict];
    }
    
    if (sortSel == 1) 
    {
        [listingTable removeAllObjects];
        for (int i = 0; i < [sortHeaders2 count]; i++)
        {
            NSMutableArray *section = [[NSMutableArray alloc] init];
            NSString *currSortHeader = [sortHeaders2 objectAtIndex:i];
            for (Listing *listingListListing in listingsList) 
            {
                if ([listingListListing.subType isEqualToString:currSortHeader]) 
                {
                    [section addObject:listingListListing];
                }
            }
            NSDictionary *sectionDict = [NSDictionary dictionaryWithObject:section forKey:@"Explore"];
            [listingTable addObject:sectionDict];
        }
    }
    
    if (sortSel == 2) 
    {
        [listingTable removeAllObjects];
        [listingTable removeAllObjects];
        for (int i = 0; i < [sortHeaders3 count]; i++)
        {
            NSMutableArray *section = [[NSMutableArray alloc] init];
            NSString *currSortHeader = [sortHeaders3 objectAtIndex:i];
            for (Listing *listingListListing in listingsList) 
            {
                if ([listingListListing.ratingType isEqualToString:currSortHeader]) 
                {
                    [section addObject:listingListListing];
                }
            }
            NSDictionary *sectionDict = [NSDictionary dictionaryWithObject:section forKey:@"Explore"];
            [listingTable addObject:sectionDict];
        }   
    }
    
    if (sortSel == 3) 
    {
        for (int i = 0; i < [sortHeaders4 count]; i++)
        {
            NSMutableArray *section = [[NSMutableArray alloc] init];
            NSString *currSortHeader = [sortHeaders4 objectAtIndex:i];
            for (Listing *listingListListing in listingsList) 
            {
                if ([listingListListing.costType isEqualToString:currSortHeader]) 
                {
                    [section addObject:listingListListing];
                }
            }
            NSDictionary *sectionDict = [NSDictionary dictionaryWithObject:section forKey:@"Explore"];
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
        //StartDateLabel.text = startDateString;
        StartDateLabel.text = @"";
        
        //Detail Image    
        NSString *imageString = [[((Listing *) view.annotation).imageFilenames objectAtIndex:0] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        DetailImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageString]]];
        NSLog(@"%@",[((Listing *) view.annotation).imageFilenames objectAtIndex:0]); 
        
        //Button Press
        
        NSString *listingID = ((Listing *) view.annotation).listingID;
        for (int i = 0; i < [listingsList count]; i++) {
            Listing *currentListing = [listingsList objectAtIndex:i];
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

-(void)button:(id)sender  // Control for Map View Button to Listing Detail View   
{      
    ListingViewController *listingView = [self.storyboard instantiateViewControllerWithIdentifier:@"ListingViewController"]; // Listing Detail Page
    listingView.listingTitle =((UIButton*)sender).currentTitle;
    [self.navigationController pushViewController:listingView animated:YES];
    NSLog(@"Button");
    
}
// ---- END MAP METHODS ----

// ---- TABLE METHODS ----

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [listingTable count];
}

- (NSInteger)tableView:(UITableView *)listingTableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *dictionary = [listingTable objectAtIndex:section];
    NSArray *array = [dictionary objectForKey:@"Explore"];
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
            NSString *currHeaders = [sectionHeaders objectAtIndex:i];
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
    UITableViewCell *cell = (UITableViewCell *) [listingTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) 
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSDictionary *dictionary = [listingTable objectAtIndex:indexPath.section];
    NSMutableArray *array = [dictionary objectForKey:@"Explore"];
    Listing *currListing = [array objectAtIndex:indexPath.row];
    NSString *cellValue = currListing.title;
    
    
    UIImage* imageheart = [UIImage imageNamed:@"TabHeartIt.png"];
    UIImage* imagetrail = [UIImage imageNamed:@"ToursAdd.png"];
    
    //cell.textLabel.text = cellValue;
    //cell.imageView.image = image;
    
    //ContentView
    
    CGRect Label1Frame = CGRectMake(5, 10, 240, 25);
    CGRect Label2Frame = CGRectMake(5, 33, 240, 25);
    CGRect Button1Frame = CGRectMake(250, 20, 20, 20);
    
    UILabel *lblTemp;
    UIButton *btnTemp;
    
    lblTemp = [[UILabel alloc] initWithFrame:Label1Frame];
    lblTemp.text = cellValue;
    [cell.contentView addSubview:lblTemp];
    
    lblTemp = [[UILabel alloc] initWithFrame:Label2Frame];
    lblTemp.text = currListing.subtitle;
    lblTemp.font = [UIFont systemFontOfSize:14];
    [cell.contentView addSubview:lblTemp];
    
    btnTemp =[[UIButton alloc] initWithFrame:Button1Frame];
    [btnTemp setImage:imageheart forState:UIControlStateNormal];
    
    [cell.contentView addSubview:btnTemp];
    
    //Accessory View
    CGRect Button2Frame = CGRectMake(0, 0, 20, 20);    
    UIButton *btnTemp2;
    
    btnTemp2 =[[UIButton alloc] initWithFrame:Button2Frame];
    [btnTemp2 setImage:imagetrail forState:UIControlStateNormal];
    [cell setAccessoryView:btnTemp2];

    
    NSString *listingID = currListing.listingID;
    for (int i = 0; i < [listingsList count]; i++) {
        Listing *currentListing = [listingsList objectAtIndex:i];
        if ([currentListing.listingID isEqualToString:listingID]) {
            btnTemp.tag =i;
            btnTemp2.tag = i;
        }
    }
    
    NSString *cutString = [currListing.listingID stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([SearchArray searchArray:cutString]) {
        [btnTemp setEnabled:FALSE];
    }
    
    [btnTemp addTarget:self action:@selector(addFavourite:) forControlEvents:UIControlEventTouchUpInside];
    [btnTemp2 addTarget:self action:@selector(addToTrail:) forControlEvents:UIControlEventTouchUpInside];

    
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

-(void)ListingView:(id)sender  // Control for Map View Button to Listing Detail View   
{      
    ListingViewController *listingView = [self.storyboard instantiateViewControllerWithIdentifier:@"ListingViewController"]; // Listing Detail Page
    NSInteger selectedIndex = ((UIButton*)sender).tag;
    Listing *selectedListing = [listingsList objectAtIndex:selectedIndex];
    listingView.listingID = selectedListing.listingID;
    NSLog(@"%@",selectedListing.listingID);
    listingView.listingTitle = selectedListing.title;
    [self.navigationController pushViewController:listingView animated:YES];

}

-(void)addFavourite:(id)sender  // Control for Map View Button to Listing Detail View   
{      
    NSInteger selectedIndex = ((UIButton*)sender).tag;
    ((UIButton*)sender).enabled = FALSE;
    Listing *selectedListing = [listingsList objectAtIndex:selectedIndex];
    
    NSString *cutString = [selectedListing.listingID stringByReplacingOccurrencesOfString:@" " withString:@""];
    [SaveToFavorites saveToFavorites:cutString];
    
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
    NSDictionary *dictionary = [listingTable objectAtIndex:indexPath.section];
    NSArray *array = [dictionary objectForKey:@"Explore"];
    Listing *selectedEvent = [array objectAtIndex:indexPath.row];

    ListingViewController *listingView = [self.storyboard instantiateViewControllerWithIdentifier:@"ListingViewController"]; // Listing Detail Page
    listingView.listingTitle = selectedEvent.title;
    listingView.listingID = selectedEvent.listingID;
    [self.navigationController pushViewController:listingView animated:YES];
    NSLog(@"Button");
}

// ---- END TABLE METHODS ----

// ---- Buttons ----

-(IBAction)SwitchView {
    
    //Button to switch between Map and Table view
    NSArray *viewArray = exploreView.subviews; //Gathers an arrary of 'view' in the 'aroundMe' stack in order.
    if ([viewArray objectAtIndex:1] == mapWindow) // change to table view
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
    else if ([viewArray objectAtIndex:1] == tableWindow) // change to mapview
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
    currArea = [areaFilter objectAtIndex:currSel];

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
    currArea = [areaFilter objectAtIndex:currSel];
    
    areaID = currArea.areaID;
    areaLabel.text = currArea.areaName; 
    
    [self setupArray];
    [self setupMap];
    
}
-(IBAction)segmentButton:(id)sender{
    
    if (segmentController.selectedSegmentIndex == 0) {
        sortSel = 0;
        [self setupArray];
        NSLog(@"Button1");
    }
    if (segmentController.selectedSegmentIndex == 1) {
        sortSel = 1;
        [self setupArray];
        NSLog(@"Button2");
    }
    if (segmentController.selectedSegmentIndex == 2) {
        sortSel = 2;
        [self setupArray];
        NSLog(@"Button3");
    }
    if (segmentController.selectedSegmentIndex == 3) {
        sortSel = 3;
        [self setupArray];
        NSLog(@"Button4");
    }
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
        theList.listingID = [[attributeDict objectForKey:@"listingID"] stringValue];
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
