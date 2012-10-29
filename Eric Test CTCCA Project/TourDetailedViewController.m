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
    if([listingsList count]==0){
        [self setupItineraryTable];
    }
    [itineraryList reloadData];
    [self setupPictures];
}

- (void)viewDidLoad
{
    [super setTitle:currentTour.TourName];
    
    Cost = [[NSMutableArray alloc] init];
    [Cost addObject:@"Free"];
    [Cost addObject:@"$"];
    [Cost addObject:@"$$"];
    [Cost addObject:@"$$$"];
    [Cost addObject:@"$$$$"];
    [Cost addObject:@"$$$$$"];

    
    switchTableView.hidden=false;
    switchMapView.hidden=true;
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
        NSString *content = [NSString stringWithFormat:@"<h3 style='color: #1b4583;'>%@</h3><strong style='color: #1b4583;'>Cost:</strong> %@<p><strong style='color: #1b4583;'>Tour Agent:</strong> %@</p><p><strong style='color: #1b4583;'>Description</strong>%@</p>", currentTour.TourName, [Cost objectAtIndex:[currentTour.TourCost intValue]],currentTour.TourAgent, [currentTour.TourDetail stringByReplacingOccurrencesOfString:@"\n" withString:@"<br/>"]];
        NSLog(@"%@",currentTour.TourDetail);
        [infoBox loadHTMLString:content baseURL:nil];
        infoBox.scrollView.showsHorizontalScrollIndicator=FALSE;
        
        
    }
    if (segmentController.selectedSegmentIndex == 1) {
        [detailedView bringSubviewToFront:itineraryList];
    }
    pageControl.currentPage=0;
    [self setupArray];
    

}

// *** DATA CONNECTION ***

-(void)setupItineraryTable // Connection to DataSource
{
    [mapView removeAnnotations:mapView.annotations];
    [listingsListString removeAllObjects];
    [listingsList removeAllObjects];
    [listingTable removeAllObjects];
    
    //The strings to send to the webserver.
    
    
//    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"AroundMe.php.xml"];
//    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
//    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:data];
    dispatch_queue_t concurrentQueue =
    dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(concurrentQueue, ^(void){
    //NSString * urlString = [NSString stringWithFormat:@"http://itp2012.com/CMS/IPHONE/subscribe.php?Name=%@&Postcode=%@&Email=%@&Subscribe=%@", x1,x2,y1,y2];
    NSString *urlString = [NSString stringWithFormat:@"http://imaginecup.ise.canberra.edu.au/PhpScripts/TourLocations.php?tour=%@",currentTour.TourID];
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
        [alert show];

        NSLog(@"did not work!");
    }
    
    listingsList = [[NSMutableArray alloc] init];
    
    for (ListingString *listingStringElement in listingsListString) {
        
        Listing *currListing = [[Listing alloc] init];
        
        // ListingID , Title , SubTitle
        
        currListing.listingID = [listingStringElement.ItemID stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        currListing.listingID = [currListing.listingID stringByReplacingOccurrencesOfString:@"t" withString:@""];
        currListing.title = [listingStringElement.ItemName stringByReplacingOccurrencesOfString:@"\n" withString:@""];

        
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
        currListing.subType = [listingStringElement.SubtypeName stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
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
        currListing.videoURL = [NSURL URLWithString:[listingStringElement.VideoURL stringByReplacingOccurrencesOfString:@"\n" withString:@""]];
        currListing.websiteURL = [NSURL URLWithString:[listingStringElement.Website stringByReplacingOccurrencesOfString:@"\n" withString:@""]];
        currListing.audioURL = [NSURL URLWithString:[listingStringElement.AudioURL stringByReplacingOccurrencesOfString:@"\n" withString:@""]];
        
        // Start Date
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd/MM/yyyy"];
        // Start Date
        listingStringElement.StartDate = [listingStringElement.StartDate stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        NSDate *startDate = [dateFormatter dateFromString:listingStringElement.StartDate];
        currListing.startDate = startDate;
        
        // End Date
        listingStringElement.EndDate = [listingStringElement.EndDate stringByReplacingOccurrencesOfString:@"\n" withString:@""];
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
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
    listingTable = [[NSMutableArray alloc] init];
    NSMutableArray *section = [[NSMutableArray alloc] initWithArray:listingsList];
    NSDictionary *sectionDict = @{@"Itinenary": section};
    [listingTable addObject:sectionDict];
    [itineraryList reloadData];
    });
    });
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
    
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"current"];// get a dequeued view for the annotation like a tableview
    
    if (annotationView == nil)
    {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"current"];
    }
    annotationView.annotation = annotation;
    annotationView.canShowCallout = YES; // show the grey popup with location etc
    UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    ///[rightButton addTarget:self action:@selector(showDetails:) forControlEvents:UIControlEventTouchUpInside];
    annotationView.rightCalloutAccessoryView = rightButton;
    
    annotationView.image = [UIImage imageNamed:@"map_marker.png"];
    
    annotationView.draggable = NO;
    //annotationView.highlighted = YES;
    //annotationView.animatesDrop = TRUE;
    //annotationView.canShowCallout = NO;
    
    if (annotation == mapViewAroundMe.userLocation) {
        return nil;
    }
    //MyPin.image = [UIImage imageNamed:@"Map-Marker-Marker-Outside-Azure-256.png"];
    //MyPin.annotation = annotation;
    
    return annotationView;
}


-(void)mapView:(MKMapView *)mapViewSelect didSelectAnnotationView:(MKPinAnnotationView *)view
{
    NSLog(@"didSelectAnnotationView");
    DetailView.hidden = FALSE;
    view.pinColor = MKPinAnnotationColorGreen;
    view.image = [UIImage imageNamed:@"map_marker_green.png"];
    if ([view.annotation isKindOfClass:[Listing class]] )
    {
        //Title
        TitleLabel.text = view.annotation.title;
        
        //Address
        DetailLabel.text = ((Listing *) view.annotation).address;
        
        //Start Date
        //        NSDateFormatter *startDateFormat = [[NSDateFormatter alloc] init];
        //        [startDateFormat setDateFormat:@"EEEE','MMMM d'.' KK:mma"];
        //        NSString *startDateString = [startDateFormat stringFromDate:((Listing *) view.annotation).startDate];
        AddressLabel.text = ((Listing *) view.annotation).subType;
        
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
    view.image = [UIImage imageNamed:@"map_marker.png"];
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
        switchTableView.hidden=false;
        switchMapView.hidden=true;
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
        switchTableView.hidden=true;
        switchMapView.hidden=false;

        [navView bringSubviewToFront:switchMapView];
        [UIView commitAnimations];
        [self setupMap];
        
    }

}

- (IBAction)goHome:(id)sender {
    NavigationViewController *eventView = [self.storyboard instantiateViewControllerWithIdentifier:@"NavigationViewController"];
    eventView.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;//UIModalTransitionStyleCoverVertical; UIModalTransitionStyleFlipHorizontal;//
    
    [self presentModalViewController:eventView animated:YES];
}

- (IBAction)startTour:(id)sender {
    TourRoutesViewController *tourRoutesView = [self.storyboard instantiateViewControllerWithIdentifier:@"TourRoutesViewController"]; // Listing Detail Page
    tourRoutesView.listingsList = listingsList;
    tourRoutesView.tourName = [self title];
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
