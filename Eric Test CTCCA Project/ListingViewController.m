//
//  ListingViewController.m
//  Eric Test CTCCA Project
//
//  Created by CTCCA on 16/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

//From the Listing ID - Contact the Database then populate outlets.
//Will require picture control.
//And 3 Text Fields.
// + Picture/s
// + Geo Co-ordinate for map view.

#import "ListingViewController.h"
#import "TourMapListRouteViewController.h"
#import <EventKitUI/EventKitUI.h>
#import <EventKit/EventKit.h>
#import "SaveToFavorites.h"
#import "Listing.h"
#import "SearchArray.h"

@interface ListingViewController ()
@end

@implementation ListingViewController
@synthesize listingID,listingTitle, listingsList, listingsListString;
@synthesize currentListing;

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
    
    NSString *cutString = [currentListing.listingID stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([SearchArray searchArray:cutString]) {
        favButton.image = [UIImage imageNamed:@"73-radar"];
    }
    [self segmentButton:self];
}

-(void)viewWillAppear:(BOOL)animated
{
    
    
    
}

- (void)viewDidLoad
{
    
    //Set a activity indicator in here. untill viewDidAppear procs.
    DetailView.hidden = TRUE;
    DetailView.backgroundColor = [UIColor clearColor];
    
    [super setTitle:currentListing.title];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)setupMap
{
    
    //Map Settings
    [mapView setMapType:MKMapTypeStandard];
    [mapView setZoomEnabled:YES];
    [mapView setScrollEnabled:YES];
    [mapView setDelegate:self];
    
    //Center Map on users location;
    //CLLocationCoordinate2D zoomLocation;
    MKCoordinateRegion region = {{0.0, 0.0}, {0.0,0.0}};
    //region.center.latitude = -35.281150; //mapView.userLocation.location.coordinate.latitude;
    //region.center.longitude = 149.128668; //mapView.userLocation.location.coordinate.longitude;
    region.center = currentListing.coordinate;
    region.span.latitudeDelta = 0.05f; // Zoom Settings
    region.span.longitudeDelta = 0.05f; // Zoom Settings
    [mapView setRegion:region animated:YES];
    
}

-(void) setupArray
{
    NSLog(@"%@",listingID);
    //Select * from ListingElements where listingID = listing ID
    [mapView removeAnnotations:mapView.annotations];   
    
    currentListing = self.currentListing;
    [mapView addAnnotation:self.currentListing];
    pageControl.numberOfPages = [currentListing.imageFilenames count];    
}

-(void) setupPictures
{
	scrollView.clipsToBounds = NO;
	scrollView.pagingEnabled = YES;
	scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
	
	CGFloat contentOffset = 0.0f;
    
	for (int i = 0; i < [currentListing.imageFilenames count]; i++) {
		CGRect imageViewFrame = CGRectMake(contentOffset, 0.0f, scrollView.frame.size.width, scrollView.frame.size.height);
        
        NSString *imageString = [(currentListing.imageFilenames)[i] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
		UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageViewFrame];
        
        dispatch_queue_t concurrentQueue =
        dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
        dispatch_async(concurrentQueue, ^(void){
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageString]]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                imageView.image = image;
                loadView.hidden = YES;
            });
        });
		//imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.contentMode = UIViewContentModeCenter;
        
		[scrollView addSubview:imageView];
        
		contentOffset += imageViewFrame.size.width;
		scrollView.contentSize = CGSizeMake(contentOffset, scrollView.frame.size.height);
	}
    //[scrollView reloadInputViews];
}

-(IBAction)segmentButton:(id)sender{
    
    if (segmentController.selectedSegmentIndex == 0) {
        infoBox.text = currentListing.details;
    }
    if (segmentController.selectedSegmentIndex == 1) {
        infoBox.text =currentListing.description;
    }
    if (segmentController.selectedSegmentIndex == 2) {
        infoBox.text =currentListing.review;
    }
    [self setupArray];
    [self setupPictures];
}

// *** MAP METHODS ****

-(MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation 
{
    MKPinAnnotationView *MyPin=[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"current"];     
    MyPin.pinColor = MKPinAnnotationColorRed;
    
    MyPin.draggable = NO;
    MyPin.highlighted = YES;
    MyPin.animatesDrop = TRUE;
    MyPin.canShowCallout = noErr;
    
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
        NSString *startDateString = [startDateFormat stringFromDate:((Listing *) view.annotation).startDate];
        StartDateLabel.text = startDateString;
        
        //Detail Image    
        NSString *imageString = [(((Listing *) view.annotation).imageFilenames)[0] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        DetailImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageString]]];
        NSLog(@"%@",(((Listing *) view.annotation).imageFilenames)[0]); 
        
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

// ** Picture Scroll Methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)sender {
    CGFloat pageWidth = self->scrollView.frame.size.width;
    int page = floor((self->scrollView.contentOffset.x - pageWidth /2) / pageWidth) + 1;
    self->pageControl.currentPage = page;
}

-(IBAction)addToCalendar:(id)sender{
    //Event Store Object
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    EKEvent *event = [EKEvent eventWithEventStore:eventStore];
    EKEventEditViewController *controller = [[EKEventEditViewController alloc] init];
    
    event.title=currentListing.title;
    event.location=currentListing.address;
    if (currentListing.listingType == @"Event") {
        event.startDate = currentListing.startDate;
        event.endDate = currentListing.endDate;
    }
    controller.event = event;
    controller.eventStore = eventStore;
    controller.editViewDelegate = self;
    
    [self presentModalViewController: controller animated:YES];
    
}

- (void)eventEditViewController:(EKEventEditViewController *)controller didCompleteWithAction:(EKEventEditViewAction)action
{
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction)viewWebsite:(id)sender
{
    ListingWebViewController *webView= [self.storyboard instantiateViewControllerWithIdentifier:@"ListingWebView"]; // Listing Detail Page
    webView.Website = currentListing.videoURL;
    [self.navigationController pushViewController:webView animated:YES];
    NSLog(@"Button");
}

-(IBAction)shareWebsite:(id)sender
{
    ListingWebViewController *webView= [self.storyboard instantiateViewControllerWithIdentifier:@"ListingWebView"]; // Listing Detail Page
    NSString *facebookShare = @"http://www.facebook.com/share.php?u=";
    NSString *website = [currentListing.websiteURL absoluteString];
    NSString *shareWebsite = [NSString stringWithFormat:@"%@%@",facebookShare,website];
    webView.Website = [NSURL URLWithString:shareWebsite];
    
    [self.navigationController pushViewController:webView animated:YES];
    NSLog(@"Button");
}

-(IBAction)addToFavourties:(id)sender
{
    NSString *cutString = [currentListing.listingID stringByReplacingOccurrencesOfString:@" " withString:@""];
    [SaveToFavorites saveToFavorites:cutString];
    
    favButton.image = [UIImage imageNamed:@"73-radar"];
    NSLog(@"%@",cutString);
    NSLog(@"Button Favourite");
}

-(IBAction)startTour:(id)sender
{
    TourMapListRouteViewController *tourView= [self.storyboard instantiateViewControllerWithIdentifier:@"TourMapListRouteViewController"]; // Listing Detail Page
    [self.navigationController pushViewController:tourView animated:YES];
    NSLog(@"Button");
}

-(IBAction)changePage{
    CGRect frame;
    frame.origin.x = self->scrollView.frame.size.width *self->pageControl.currentPage;
    frame.origin.y = 0;
    frame.size = self->scrollView.frame.size;
    [self->scrollView scrollRectToVisible:frame animated:YES];
    
}

-(IBAction)SwitchView {
    
    // Also I haven't primed the array, yet it still works?
    
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
        [self setupMap];
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
