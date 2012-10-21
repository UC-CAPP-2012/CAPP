//
//  TourDetailedViewController.m
//  Eric Test CTCCA Project
//
//  Created by CTCCA on 13/10/12.
//
//

#import "TourDetailedViewController.h"
#import <EventKitUI/EventKitUI.h>
#import <EventKit/EventKit.h>
#import "Listing.h"
#import "MainTypeClass.h"

@interface TourDetailedViewController ()

@end

@implementation TourDetailedViewController
@synthesize currentTour;
@synthesize listing,listingsDataSource,listingTable, listingsList,listingsListString;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
    [self segmentButton:self];
    [self setupItineraryTable];
}

- (void)viewDidLoad
{
    [super setTitle:currentTour.TourName];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changePaged:(id)sender {
    CGRect frame;
    frame.origin.x = self->scrollView.frame.size.width *self->pageControl.currentPage;
    frame.origin.y = 0;
    frame.size = self->scrollView.frame.size;
    [self->scrollView scrollRectToVisible:frame animated:YES];
}

- (IBAction)segmentButton:(id)sender {
    

    if (segmentController.selectedSegmentIndex == 0) {
        [detailedView bringSubviewToFront:infoBox];
        [infoBox loadHTMLString:[NSString stringWithFormat:@"<strong style='color: #1b4583;'>Cost:</strong> %@<p><strong style='color: #1b4583;'>Tour Agent:</strong> %@</p><p><strong style='color: #1b4583;'>Phone:</strong>%@</p><p><strong style='color: #1b4583;'>Website:</strong> %@</p><p><strong style='color: #1b4583;'>Email:</strong>%@</p>",currentTour.TourCost,currentTour.TourAgent, currentTour.TourPhone, [currentTour.TourWebsite absoluteString], currentTour.TourEmail] baseURL:nil];
        infoBox.scrollView.showsHorizontalScrollIndicator=FALSE;
        
        
    }
    if (segmentController.selectedSegmentIndex == 1) {
        [detailedView bringSubviewToFront:desciptionView];
        desciptionView.text = currentTour.TourDetail;
    }
    if (segmentController.selectedSegmentIndex == 2) {
        [detailedView bringSubviewToFront:itineraryList];
    }
    pageControl.currentPage=0;
    [self setupArray];
    [self setupPictures];

}

// *** DATA CONNECTION ***

-(void)setupItineraryTable // Connection to DataSource
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
        currListing.costType =[listingStringElement.Cost stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        currListing.subType = [listingStringElement.SubType stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
        // Address
        
        currListing.address = [listingStringElement.Address stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
        currListing.majorRegionName = [listingStringElement.MajorRegionName stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
        currListing.phone = [listingStringElement.Phone stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
        currListing.email = [listingStringElement.Email stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
        currListing.suburb = [listingStringElement.Suburb stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
        currListing.openingHours = [listingStringElement.OpeningHours stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
        
        // Listing View details
        
        currListing.description = [listingStringElement.Details stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        currListing.imageFilenames = [listingStringElement.ImageURL componentsSeparatedByString:@","];
        NSString *urlTemp = [listingStringElement.VideoURL stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        NSString *videoUrlString = [[NSString stringWithFormat:urlTemp] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *webUrlTemp = [listingStringElement.Website stringByReplacingOccurrencesOfString:@"\n" withString:@""];
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
        NSLog(@"%@",listingStringElement.Latitude);
        NSLog(@"%@",listingStringElement.Longitude);
        NSLog(@"%f",latDouble);
        NSLog(@"%f",lonDouble);
        NSLog(@"%@",listingStringElement.ListingID);
        NSLog(@"%@",listingStringElement.ListingType);
        NSLog(@"%@",listingStringElement.AreaID);
        NSLog(@"%@",listingStringElement.Cost);
        NSLog(@"%@",listingStringElement.SubType);
        NSLog(@"%@",listingStringElement.Suburb);    //suburb
        NSLog(@"%@",listingStringElement.Postcode);  //postcode
        NSLog(@"%@",listingStringElement.StateID);   //stateID
        NSLog(@"%@",currListing.address);
        NSLog(@"%@",listingStringElement.Details);
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
        NSLog(@"%@",listingStringElement.Website);
        NSLog(@"%@",listingStringElement.EndMinute);
        NSLog(@"%@",listingStringElement.EndHour);
        
        // -----------------------------------------
        
        [listingsList addObject:currListing];
        
        [mapView addAnnotation:currListing];
    }
    
    
    listingTable = [[NSMutableArray alloc] init];
    NSMutableArray *section = [[NSMutableArray alloc] initWithArray:listingsList];
    NSDictionary *sectionDict = @{@"Itinenary": section};
    [listingTable addObject:sectionDict];
    [itineraryList reloadData];
    
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


-(void) setupArray
{
    NSLog(@"%@",currentTour.TourID);
    //Select * from ListingElements where listingID = listing ID
    //[mapView removeAnnotations:mapView.annotations];
    
    currentTour = self.currentTour;
    //[mapView addAnnotation:self.currentTour];
    pageControl.numberOfPages = [currentTour.ImageFileNames count];
}

-(void) setupPictures
{
	scrollView.clipsToBounds = NO;
	scrollView.pagingEnabled = YES;
	scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
	
	CGFloat contentOffset = 0.0f;
    
	for (int i = 0; i < [currentTour.ImageFileNames count]; i++) {
		CGRect imageViewFrame = CGRectMake(contentOffset, 0.0f, scrollView.frame.size.width, scrollView.frame.size.height);
        
        NSString *imageString = [(currentTour.ImageFileNames)[i] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
		UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageViewFrame];
        
        dispatch_queue_t concurrentQueue =
        dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
        dispatch_async(concurrentQueue, ^(void){
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageString]]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                imageView.image = image;
                imageView.contentMode = UIViewContentModeScaleToFill;
                loadView.hidden = YES;
            });
        });
		//imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        
		[scrollView addSubview:imageView];
        
		contentOffset += imageViewFrame.size.width;
		scrollView.contentSize = CGSizeMake(contentOffset, scrollView.frame.size.height);
	}
    //[scrollView reloadInputViews];
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
        Listing *selected = [(Listing *)view.annotation init];
        //Title
        TitleLabel.text = view.annotation.title;
        
        //Address
        AddressLabel.text = ((Listing *) view.annotation).address;
        DetailLabel.text = ((Listing *) view.annotation).description;
        
        //Detail Image
        NSString *imageString = [(((Listing *) view.annotation).imageFilenames)[0] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        DetailImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageString]]];
        NSLog(@"%@",(((Listing *) view.annotation).imageFilenames)[0]);
        
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

-(void)ListingView:(id)sender  // Control for Map View Button to Listing Detail View
{
    ListingViewController *locationlistingView = [self.storyboard instantiateViewControllerWithIdentifier:@"ListingViewController"]; // Listing Detail Page
    NSInteger selectedIndex = ((UIButton*)sender).tag;
    Listing *selectedListing = listingsList[selectedIndex];
    locationlistingView.currentListing = selectedListing;
    [self.navigationController pushViewController:locationlistingView animated:YES];
    NSLog(@"%@",selectedListing.listingID);
}


-(void)mapView:(MKMapView *)mapViewDeSelect didDeselectAnnotationView:(MKPinAnnotationView *)view
{
    NSLog(@"didDeselectAnnotationView");
    DetailView.hidden = TRUE;
    view.pinColor = MKPinAnnotationColorRed;
}
// END MAP METHODS

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [listingTable count];
}

- (NSInteger)tableView:(UITableView *)listingTableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *dictionary = listingTable[section];
    NSArray *array = dictionary[@"Itinenary"];
    
    return [array count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dictionary = listingTable[indexPath.section];
    NSArray *array = dictionary[@"Itinenary"];
    Listing *selectedEvent = array[indexPath.row];
    
    ListingViewController *listingView = [self.storyboard instantiateViewControllerWithIdentifier:@"ListingViewController"]; // Listing Detail Page
    listingView.currentListing = selectedEvent;
    [self.navigationController pushViewController:listingView animated:YES];
    NSLog(@"Button");
}

-(UITableViewCell *)tableView:(UITableView *)listingTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"itineraryCell";
    
    // Create or reuse a cell
    UITableViewCell *cell = [listingTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *dictionary = listingTable[indexPath.section];
    NSArray *array = dictionary[@"Itinenary"];
    Listing *currListing = array[indexPath.row];

    
    UIImage* image = [UIImage imageNamed:@"star-hollow@2x.png"];
    cell.imageView.image = image;
    
    //ContentView
    UILabel *cellHeading = (UILabel *)[cell viewWithTag:2];
    [cellHeading setText: currListing.title];
    
    UILabel *cellSubtype = (UILabel *)[cell viewWithTag:1];
    [cellSubtype setText: currListing.suburb];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}



-(IBAction)viewWebsite:(id)sender
{
    ListingWebViewController *webView= [self.storyboard instantiateViewControllerWithIdentifier:@"ListingWebView"]; // Listing Detail Page
    webView.Website = currentTour.VideoURL;
    [self.navigationController pushViewController:webView animated:YES];
    NSLog(@"Button");
}

-(IBAction)shareWebsite:(id)sender
{
    ListingWebViewController *webView= [self.storyboard instantiateViewControllerWithIdentifier:@"ListingWebView"]; // Listing Detail Page
    NSString *facebookShare = @"http://www.facebook.com/share.php?u=";
    NSString *website = [currentTour.TourWebsite absoluteString];
    NSString *shareWebsite = [NSString stringWithFormat:@"%@%@",facebookShare,website];
    webView.Website = [NSURL URLWithString:shareWebsite];
    
    [self.navigationController pushViewController:webView animated:YES];
    NSLog(@"Button");
}


- (IBAction)viewNews:(id)sender {
    BlabberViewController *blabberView = [self.storyboard instantiateViewControllerWithIdentifier:@"BlabberViewController"]; // Listing Detail Page
    [self.navigationController pushViewController:blabberView animated:YES];
}

- (IBAction)SwitchView:(id)sender {
    // Also I haven't primed the array, yet it still works - will need to ensure array order by bringing Subview to Front on initialisation.
    
    //Button to switch between Map and Table view
    NSArray *viewArray = listingView.subviews; //Gathers an arrary of 'view' in the 'aroundMe' stack in order.
    if (viewArray[1] == mapWindow) // change to table view
    {
        // Main Window Animation
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:listingView cache:YES];
        [listingView bringSubviewToFront:tableView];
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
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:listingView cache:YES];
        [listingView bringSubviewToFront:mapWindow];
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

- (IBAction)startTour:(id)sender {
    TourRoutesViewController *tourRoutesView = [self.storyboard instantiateViewControllerWithIdentifier:@"TourRoutesViewController"]; // Listing Detail Page
    tourRoutesView.listingsList = listingsList;
    [self.navigationController pushViewController:tourRoutesView animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)sender {
    CGFloat pageWidth = self->scrollView.frame.size.width;
    int page = floor((self->scrollView.contentOffset.x - pageWidth /2) / pageWidth) + 1;
    self->pageControl.currentPage = page;
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



-(void) threadStartAnimating:(id)data{
    loadView.hidden = false;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
}

- (void)eventEditViewController:(EKEventEditViewController *)controller didCompleteWithAction:(EKEventEditViewAction)action
{
    [self dismissModalViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
