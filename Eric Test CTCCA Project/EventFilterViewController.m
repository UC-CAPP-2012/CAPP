//
//  EventFilterViewController.m
//  Eric Test CTCCA Project
//
//  Created by CTCCA on 16/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EventFilterViewController.h"
#import <EventKitUI/EventKitUI.h>
#import <EventKit/EventKit.h>
#import "Listing.h"
#import "MainTypeClass.h"
#import "SearchArray.h"
#import "SaveToFavorites.h"


@interface EventFilterViewController ()
@end

@implementation EventFilterViewController

@synthesize monthFilter;
@synthesize currSel,sortSel;
@synthesize listing,listingsDataSource,listingTable, listingsList,listingsListString;
@synthesize sortHeaders1,sortHeaders2,sortHeaders3,sortHeaders4;


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
    [mapView removeAnnotations:mapView.annotations];
    [self segmentButton:self];
    [self setupDate];
    [self setupMap];
    [self setupArray];
    [tableView reloadData];

    loadView.hidden = YES;
}

- (void)viewDidLoad
{
    
    self.navigationItem.title =@"Events";
    
    dateLabel.layer.borderColor = [UIColor blackColor].CGColor;
    dateLabel.layer.borderWidth = 1.0;
    
    nextMonth.layer.borderColor = [UIColor blackColor].CGColor;
    nextMonth.layer.borderWidth = 1.0;
    
    previousMonth.layer.borderColor = [UIColor blackColor].CGColor;
    previousMonth.layer.borderWidth = 1.0;
    
    DetailView.hidden = TRUE;
    DetailView.backgroundColor = [UIColor clearColor];

    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void) setupDate
{
    int dateRange = 12; // Date Range of months.
    monthFilter = [[NSMutableArray alloc] init];
    
    NSDate *todaysDate = [NSDate date];    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [dateFormatter setDateFormat:@"MMMM, YYYY"];    
    NSString *dateString = [dateFormatter stringFromDate:todaysDate];
    [monthFilter addObject:dateString];
    
    for (int i = 1; i<=dateRange; i++) 
    {
        NSDate *todaysDate = [NSDate date];
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
        [dateComponents setMonth:i];
        NSDate *addMonth = [gregorian dateByAddingComponents:dateComponents toDate:todaysDate options:0];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
        [dateFormatter setDateFormat:@"MMMM, YYYY"];    
        NSString *dateString = [dateFormatter stringFromDate:addMonth];
        [monthFilter addObject:dateString];
    }
        
    currSel = 0;
    previousMonth.hidden=TRUE;
    dateLabel.text = [monthFilter objectAtIndex:currSel];    
}

-(void) setupArray // Connection to DataSource
{ 
    [NSThread detachNewThreadSelector:@selector(threadStartAnimating:) toTarget:self withObject:nil];
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
    
    // ---------------------------
    
    // --- SORT 1 Headers ---- // NAME
    
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
    
    //--- SORT 3 Headers -----  // This is DATE   
    
    for (int i = 0; i < [listingsList count]; i++) {
        Listing *tempListing = [listingsList objectAtIndex:i];
        NSDate *startDate = tempListing.startDate;
        NSDateFormatter *dayFormat = [[NSDateFormatter alloc] init];
        [dayFormat setDateFormat:@"dd"];
        NSString *dateString = [dayFormat stringFromDate:startDate];
        if(![sortHeaders3 containsObject:dateString])
        {
            [sortHeaders3 addObject:dateString];
            NSLog(@"%@", dateString);
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
        
        NSDictionary *sectionDict = [NSDictionary dictionaryWithObject:section forKey:@"Events"];
        [listingTable addObject:sectionDict];
    }
    
    // -- Sort Header 2 SubType
    
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
            NSDictionary *sectionDict = [NSDictionary dictionaryWithObject:section forKey:@"Events"];
            [listingTable addObject:sectionDict];
        }
    }
    
    if (sortSel == 2) // The Date one.
    {
        [listingTable removeAllObjects];
        for (int i = 0; i < [sortHeaders3 count]; i++)
        {
            NSMutableArray *section = [[NSMutableArray alloc] init];
            NSString *currSortHeader = [sortHeaders3 objectAtIndex:i];
            for (Listing *listingListListing in listingsList) 
            {
                //Do the thing here where you take the start 10 int and compare.
                NSDateFormatter *dayFormat = [[NSDateFormatter alloc] init];
                [dayFormat setDateFormat:@"dd"];
                NSString *dayString = [dayFormat stringFromDate:listingListListing.startDate];

                if ([dayString isEqualToString:currSortHeader]) 
                {
                    [section addObject:listingListListing];
                }
            }
            NSDictionary *sectionDict = [NSDictionary dictionaryWithObject:section forKey:@"Events"];
            [listingTable addObject:sectionDict];
        }   
    }
    
    /// --- Sort Header 4 Cost
    
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
            NSDictionary *sectionDict = [NSDictionary dictionaryWithObject:section forKey:@"Events"];
            [listingTable addObject:sectionDict];
        }    
    }
    
    [tableView reloadData];
    loadView.hidden = TRUE;
}

-(void)setupMap
{
    // NEED TO ADD A RESTRICTION!
    // NEED TO TEST OUTSIDE OF CANBERRA
    
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
    region.span.latitudeDelta = 0.15f; // Zoom Settings
    region.span.longitudeDelta = 0.25f; // Zoom Settings
    [mapView setRegion:region animated:YES];
        
}

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
        NSString *imageString = [[((Listing *) view.annotation).imageFilenames objectAtIndex:0] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        DetailImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageString]]];
        NSLog(@"%@",[((Listing *) view.annotation).imageFilenames objectAtIndex:0]); 
        
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
// END MAP METHODS

// TABLE METHODS
 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [listingTable count];
}

- (NSInteger)tableView:(UITableView *)listingTableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *dictionary = [listingTable objectAtIndex:section];
    NSArray *array = [dictionary objectForKey:@"Events"];
    return [array count];
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    //return @"Test";
//}

-(UIView *)tableView:(UITableView *)tableViewHeader viewForHeaderInSection:(NSInteger)section
{
    NSMutableArray *sectionHeaders = [[NSMutableArray alloc] init];
    NSString *title = nil;
    
    if (sortSel == 0) { // allphabetically.
        [sectionHeaders removeAllObjects];
        sectionHeaders = [NSArray arrayWithArray:sortHeaders1];
    }
    if (sortSel == 1) { //Type
        [sectionHeaders removeAllObjects];        
        for(NSString *header in sortHeaders2)
        {
            [sectionHeaders addObject:header];
        }
        
    }
    if (sortSel == 2) {  //Date
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
            if (section == i) 
            {
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
    static NSString *cellIdentifier = @"eventCell";
    UITableViewCell *cell = (UITableViewCell *) [listingTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) 
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    NSDictionary *dictionary = [listingTable objectAtIndex:indexPath.section];
    NSArray *array = [dictionary objectForKey:@"Events"];
    Listing *currListing = [array objectAtIndex:indexPath.row];
    NSString *cellValue = currListing.title;
    
    //Need to mod this
    NSString *imageString = [[currListing.imageFilenames objectAtIndex:0] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    UIImage* image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageString]]];
    cell.imageView.image = image;
    
    //ContentView
    CGRect Label1Frame = CGRectMake(90, 10, 160, 25);
    CGRect Label2Frame = CGRectMake(90, 33, 160, 25);
    CGRect Button1Frame = CGRectMake(250, 20, 20, 20);
    
    UILabel *lblTemp;
    UIButton *btnTemp;
    
    UIImage* imageTBA = [UIImage imageNamed:@"83-calendar"];
    UIImage* imageCal = [UIImage imageNamed:@"TabHeartIt.png"];
    
    lblTemp = [[UILabel alloc] initWithFrame:Label1Frame];
    lblTemp.text = cellValue;
    [cell.contentView addSubview:lblTemp];
    
    lblTemp = [[UILabel alloc] initWithFrame:Label2Frame];
    lblTemp.text = @"the subtitle";
    [cell.contentView addSubview:lblTemp];
    
    btnTemp =[[UIButton alloc] initWithFrame:Button1Frame];
    [btnTemp setImage:imageCal forState:UIControlStateNormal];
    [cell.contentView addSubview:btnTemp];
    
    //Accessory View
    CGRect Button2Frame = CGRectMake(0, 0, 20, 20);    
    UIButton *btnTemp2;
    
    btnTemp2 =[[UIButton alloc] initWithFrame:Button2Frame];
    [btnTemp2 setImage:imageTBA forState:UIControlStateNormal];
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
    [btnTemp2 addTarget:self action:@selector(addToCalendar:) forControlEvents:UIControlEventTouchUpInside];
    
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
    listingView.listingTitle = selectedListing.title;
    [self.navigationController pushViewController:listingView animated:YES];
    NSLog(@"%@",selectedListing.listingID);
}

-(void)addFavourite:(id)sender  
{      
    NSInteger selectedIndex = ((UIButton*)sender).tag;
    ((UIButton*)sender).enabled = FALSE;
    Listing *selectedListing = [listingsList objectAtIndex:selectedIndex];    
    NSString *cutString = [selectedListing.listingID stringByReplacingOccurrencesOfString:@" " withString:@""];
    [SaveToFavorites saveToFavorites:cutString];
    
    NSLog(@"%@",cutString);
    NSLog(@"Button Favourite");
    
}

-(void)addToCalendar:(id)sender  
{      
    
        NSInteger selectedIndex = ((UIButton*)sender).tag;
        Listing *selectedListing = [listingsList objectAtIndex:selectedIndex];
        //Event Store Object
        EKEventStore *eventStore = [[EKEventStore alloc] init];
        EKEvent *event = [EKEvent eventWithEventStore:eventStore];
        EKEventEditViewController *controller = [[EKEventEditViewController alloc] init];
        
        event.title=selectedListing.title;
        event.location=selectedListing.address;
        if (selectedListing.listingType == @"Event") {
            event.startDate = selectedListing.startDate;
            event.endDate = selectedListing.endDate;
        }
        controller.event = event;
        controller.eventStore = eventStore;
        controller.editViewDelegate = self;
        
        [self presentModalViewController: controller animated:YES];

    NSLog(@"%@",selectedListing.listingID);
    NSLog(@"Button Trail");
}
- (void)eventEditViewController:(EKEventEditViewController *)controller didCompleteWithAction:(EKEventEditViewAction)action
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath // Control for Map View Button to Listing Detail View  
{    
    NSDictionary *dictionary = [listingTable objectAtIndex:indexPath.section];
    NSArray *array = [dictionary objectForKey:@"Events"];
    Listing *selectedEvent = [array objectAtIndex:indexPath.row];
    
    ListingViewController *listingView = [self.storyboard instantiateViewControllerWithIdentifier:@"ListingViewController"]; // Listing Detail Page
    listingView.listingTitle = selectedEvent.title;
    listingView.listingID = selectedEvent.listingID;
    [self.navigationController pushViewController:listingView animated:YES];
    NSLog(@"Button");

}

/// END TABLE METHODS

// Switch View Button

-(IBAction)SwitchView {
    
    // Also I haven't primed the array, yet it still works - will need to ensure array order by bringing Subview to Front on initialisation.
    
    //Button to switch between Map and Table view
    NSArray *viewArray = eventView.subviews; //Gathers an arrary of 'view' in the 'aroundMe' stack in order.
    if ([viewArray objectAtIndex:1] == mapWindow) // change to table view
    {
        // Main Window Animation
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:eventView cache:YES];
        [eventView bringSubviewToFront:tableWindow];
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
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:eventView cache:YES];        
        [eventView bringSubviewToFront:mapWindow];
        [UIView commitAnimations];
        
        // Navigation Bar Animation
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:navView cache:YES];
        [navView bringSubviewToFront:switchMapView];
        [UIView commitAnimations];
        
    }
}

//Filter Buttons.



-(IBAction)nextMonth:(id)sender{
    
    [NSThread detachNewThreadSelector:@selector(threadStartAnimating:) toTarget:self withObject:nil];
    
    previousMonth.hidden=FALSE;
    currSel = currSel + 1;
    if (currSel == monthFilter.count-1)
    {
        nextMonth.hidden=TRUE;
    }
    dateLabel.text = [monthFilter objectAtIndex:currSel];
    [self setupArray];

}
-(IBAction)previousMonth:(id)sender{
    
    [NSThread detachNewThreadSelector:@selector(threadStartAnimating:) toTarget:self withObject:nil];
    
    nextMonth.hidden=FALSE;
    currSel = currSel - 1;
    if (currSel == 0)
    {
        previousMonth.hidden=TRUE;
    }
    dateLabel.text = [monthFilter objectAtIndex:currSel];
    [self setupArray];
    
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

-(void) threadStartAnimating:(id)data{
    loadView.hidden = false;
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

@end
