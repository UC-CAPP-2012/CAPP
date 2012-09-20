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


@interface AroundMeMapListViewController ()

@end

@implementation AroundMeMapListViewController
@synthesize listingTable,listingsTableDataSource,listingsList,listingsListString;


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
    [self setupArray];
    [tableView reloadData];
    loadView.hidden = YES;
}

- (void)viewDidLoad
{
    self.navigationItem.title = @"Around Me";
    DetailView.hidden = TRUE;
    DetailView.backgroundColor = [UIColor clearColor];
    
    [self setupMap];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
}
-(void)mapView:(MKMapView *)mapViewAroundMe didUpdateUserLocation:(MKUserLocation *)userLocation
{
    //region.center.longitude = 149.128668; 
    //region.center.latitude = -35.281150; 
    
    NSLog(@" %f",userLocation.location.coordinate.latitude);
    NSLog(@" %f",userLocation.location.coordinate.longitude);
    
    MKCoordinateRegion region = {{0.0, 0.0}, {0.0,0.0}};
    region.center.latitude = userLocation.location.coordinate.latitude;
    region.center.longitude = userLocation.location.coordinate.longitude;
    region.span.latitudeDelta = 0.05f; // Zoom Settings
    region.span.longitudeDelta = 0.05f; // Zoom Settings
    [mapViewAroundMe setRegion:region animated:YES];
    
    x1 = userLocation.location.coordinate.latitude + 0.05f;
    x2 = userLocation.location.coordinate.latitude - 0.05f;
    y1 = userLocation.location.coordinate.longitude  + 0.05f;
    y2 = userLocation.location.coordinate.longitude  - 0.05f;
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
}

// *** DATA CONNECTION ***

-(void)setupArray // Connection to DataSource
{ 
    [mapView removeAnnotations:mapView.annotations];
    [listingsListString removeAllObjects];
    [listingsList removeAllObjects];
    [listingTable removeAllObjects];

    //The strings to send to the webserver.

    
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
    
    listingsList = [[NSMutableArray alloc] init];
    
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
        
        currListing.address = [NSString stringWithFormat:@"%@ ,%@ %@ %@",listingStringElement.UnitNumber,listingStringElement.StreetName, listingStringElement.StreetType, listingStringElement.Suburb,listingStringElement.Postcode]; //,listingStringElement.StateID];
        currListing.address = [currListing.address stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
        
        // Listing View details
        
        currListing.details = [listingStringElement.Details stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        currListing.description = [listingStringElement.description stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        currListing.review = [listingStringElement.Review stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        currListing.imageFilenames = [listingStringElement.ImageURL componentsSeparatedByString:@","];
        //currListing.videoURL = [[NSURL alloc] initWithString:listingStringElement.VideoURL];
        //currListing.websiteURL = [[NSURL alloc] initWithString:listingStringElement.WebsiteURL];
        
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
        NSLog(@"%@",listingStringElement.WebsiteURL);
        NSLog(@"%@",listingStringElement.StartDay);
        NSLog(@"%@",listingStringElement.StartMonth);
        NSLog(@"%@",listingStringElement.StartYear);
        NSLog(@"%@",listingStringElement.StartMinute);
        NSLog(@"%@",listingStringElement.StartHour);
        NSLog(@"%@",listingStringElement.EndDay);
        NSLog(@"%@",listingStringElement.EndMonth);
        NSLog(@"%@",listingStringElement.EndYear);
        NSLog(@"%@",listingStringElement.EndMinute);
        NSLog(@"%@",listingStringElement.EndHour);
        
        // -----------------------------------------
        
        [listingsList addObject:currListing];
        [mapView addAnnotation:currListing];
    }
    

    listingTable = [[NSMutableArray alloc] init];
    NSMutableArray *section = [[NSMutableArray alloc] initWithArray:listingsList];
    NSDictionary *sectionDict = [NSDictionary dictionaryWithObject:section forKey:@"AroundMe"];
    [listingTable addObject:sectionDict];
    [tableView reloadData];
    
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
    if (view.annotation == mapViewSelect.userLocation) {
        return;
    }
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
        //NSString *startDateString = [startDateFormat stringFromDate:((Listing *) view.annotation).startDate];
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
    if (view.annotation == mapViewDeSelect.userLocation) {
        return;
    }
    NSLog(@"didDeselectAnnotationView");
    DetailView.hidden = TRUE;
    view.pinColor = MKPinAnnotationColorRed;
}

-(void)ListingView:(id)sender  // Control for Map View Button to Listing Detail View   
{      
    ListingViewController *listingView = [self.storyboard instantiateViewControllerWithIdentifier:@"ListingViewController"]; // Listing Detail Page
    NSInteger selectedIndex = ((UIButton*)sender).tag;
    ((UIButton*)sender).enabled = FALSE;
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
    NSInteger selectedIndex = ((UIButton*)sender).tag;
    Listing *selectedListing = [listingsList objectAtIndex:selectedIndex];
    NSLog(@"%@",selectedListing.listingID);
    NSLog(@"Button Trail");
}

// *** END MAP METHODS

// *** TABLE METHODS ***

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [listingTable count];
}
- (NSInteger)tableView:(UITableView *)listingTableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *dictionary = [listingTable objectAtIndex:section];
    NSArray *array = [dictionary objectForKey:@"AroundMe"];
    return [array count];
}
-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return@"Around Me Listings";
    }
    else {
        return@"";
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)listingTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"aroundMeCell";
    UITableViewCell *cell = (UITableViewCell *) [listingTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) 
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSDictionary *dictionary = [listingTable objectAtIndex:indexPath.section];
    NSMutableArray *array = [dictionary objectForKey:@"AroundMe"];
    Listing *currListing = [array objectAtIndex:indexPath.row];
    NSString *cellTitle = currListing.title;
    
    UIImage* imageFavourites = [UIImage imageNamed:@"TabHeartIt.png"];
    UIImage* imageTrail = [UIImage imageNamed:@"ToursAdd.png"];
    //ContentView
    CGRect Label1Frame = CGRectMake(5, 10, 240, 25);
    CGRect Label2Frame = CGRectMake(5, 33, 240, 25);
    CGRect Button1Frame = CGRectMake(250, 20, 20, 20);
    
    UILabel *lblTemp;
    UIButton *btnTemp;
    
    lblTemp = [[UILabel alloc] initWithFrame:Label1Frame];
    lblTemp.text = cellTitle;
    [cell.contentView addSubview:lblTemp];
    
    lblTemp = [[UILabel alloc] initWithFrame:Label2Frame];
    lblTemp.text = currListing.subtitle; //No data passed from XML - Need Max to pass you this.
    [cell.contentView addSubview:lblTemp];
    
    btnTemp =[[UIButton alloc] initWithFrame:Button1Frame];
    [btnTemp setImage:imageFavourites forState:UIControlStateNormal];
    [cell.contentView addSubview:btnTemp];
    
    //Accessory View
    CGRect Button2Frame = CGRectMake(0, 0, 20, 20);    
    UIButton *btnTemp2;
    
    btnTemp2 =[[UIButton alloc] initWithFrame:Button2Frame];
    [btnTemp2 setImage:imageTrail forState:UIControlStateNormal];
    
    NSString *listingID = currListing.listingID;
    for (int i = 0; i < [listingsList count]; i++) {
        Listing *currentListing = [listingsList objectAtIndex:i];
        if ([currentListing.listingID isEqualToString:listingID]) {
            btnTemp.tag =i;
            btnTemp2.tag = i;
        }
    }
    
    for (int i = 0; i < [listingsList count]; i++) {
        Listing *currentListing = [listingsList objectAtIndex:i];
        if ([currentListing.listingID isEqualToString:listingID]) {
            btnTemp.tag =i;
            btnTemp2.tag = i;
        }
    }
    // Disable the Add to Favourites button if already in favourites.
    NSString *cutString = [currListing.listingID stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([SearchArray searchArray:cutString]) {
        [btnTemp setEnabled:FALSE];
        NSLog(@"Found");
    }
    
    [btnTemp addTarget:self action:@selector(addFavourite:) forControlEvents:UIControlEventTouchUpInside];
    [btnTemp2 addTarget:self action:@selector(addToTrail:) forControlEvents:UIControlEventTouchUpInside];
    [cell setAccessoryView:btnTemp2];
    
    return cell;    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath //Table Row to Listing.
{    
    NSDictionary *dictionary = [listingTable objectAtIndex:indexPath.section];
    NSArray *array = [dictionary objectForKey:@"AroundMe"];
    Listing *selectedEvent = [array objectAtIndex:indexPath.row];
    
    ListingViewController *listingView = [self.storyboard instantiateViewControllerWithIdentifier:@"ListingViewController"]; // Listing Detail Page
    listingView.listingTitle = selectedEvent.title;
    listingView.listingID = selectedEvent.listingID;
    [self.navigationController pushViewController:listingView animated:YES];
}

// *** END TABLE METHODS

// Switch View Method

-(IBAction)SwitchView {
    
    // Also I haven't primed the array, yet it still works?
    
    //Button to switch between Map and Table view
    NSArray *viewArray = aroundMe.subviews; //Gathers an arrary of 'view' in the 'aroundMe' stack in order.
    if ([viewArray objectAtIndex:1] == mapWindow) // change to table view
    {
        // Main Window Animation
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:aroundMe cache:YES];
        [aroundMe bringSubviewToFront:tableView];
        [UIView commitAnimations];
        
        // Navigation Bar Animation
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:navView cache:YES];
        [navView bringSubviewToFront:switchTableView];
        [UIView commitAnimations];
    } 
    else if ([viewArray objectAtIndex:1] == tableView) // change to mapview
    {
        // Main Window Animation
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:aroundMe cache:YES];        
        [aroundMe bringSubviewToFront:mapWindow];
        [UIView commitAnimations];
        
        // Navigation Bar Animation
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:navView cache:YES];
        [navView bringSubviewToFront:switchMapView];
        [UIView commitAnimations];
        
    }
    
}

// END Switch View Method

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
