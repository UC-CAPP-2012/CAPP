//
//  TourMapListRouteViewController.m
//  Eric Test CTCCA Project
//
//  Created by CTCCA on 25/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TourMapListRouteViewController.h"
#import "Listing.h"

@interface TourMapListRouteViewController ()

@end

@implementation TourMapListRouteViewController

@synthesize listingTable,listingsTableDataSource;

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
    [self setupMap];
    [self setupArray];
    [tableView reloadData];
    loadView.hidden = YES;
}

// *** Initialisation ***
- (void)viewDidLoad
{
    
    DetailView.hidden = TRUE;
    DetailView.backgroundColor = [UIColor clearColor];
    
    self.navigationItem.title = @"Tours";
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
    
}

// *** MAP VIEW Setup ***
-(void) setupMap
{
    
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
    
    // *** DUMMY DATA ***
    // ** Map View Population
    CLLocationCoordinate2D placemarker;
    placemarker.latitude = -35.281150;
    placemarker.longitude = 149.128668;    
    
    Listing *ann = [[Listing alloc] init];
    ann.title = @"Title";
    ann.coordinate = placemarker;
    ann.imageFilenames = @[@"http://i681.photobucket.com/albums/vv173/kandisdesign/Kandis/240x110.png"];
    
    //Add Placemarker to map
    [mapView addAnnotation:ann];
    
    
}

// *** DATA CONNECTION ***

-(void) setupArray // Connection to DataSource
{ 
    // ** Map View Population
    CLLocationCoordinate2D placemarker;
    placemarker.latitude = -35.281150;
    placemarker.longitude = 149.128668;    
    
    Listing *ann = [[Listing alloc] init];
    ann.listingID = @"ListingID1";
    ann.title = @"Title";
    ann.coordinate = placemarker;
    
    CLLocationCoordinate2D placemarker2;
    placemarker2.latitude = -35.270000;
    placemarker2.longitude = 149.126000;    
    
    Listing *ann2 = [[Listing alloc] init];
    ann.listingID = @"ListingID2";
    ann2.title = @"Title2";
    ann2.coordinate = placemarker2;
    
    //Add Placemarker to map
    [mapView addAnnotation:ann];
    [mapView addAnnotation:ann2];
    // ** Table View Population
    
    
    
    NSArray *firstSection = @[@"Tour 1", @"Tour 2"];
    NSDictionary *firstSectionDict = @{@"Tours": firstSection};
    
    listingTable = [[NSMutableArray alloc]init];
    [listingTable addObject:firstSectionDict];
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

- (NSInteger)tableView:(UITableView *)listingTableView numberOfRowsInSection:(NSInteger)section
{
    return listingTable.count;
}

-(UITableViewCell *)tableView:(UITableView *)listingTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"tourRouteCell";
    UITableViewCell *cell = (UITableViewCell *) [listingTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSDictionary *dictionary = listingTable[indexPath.row];
    NSArray *array = dictionary[@"Tours"];
    NSString *cellValue = array[indexPath.row];
    
    if(cell == nil) 
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    UIImage* image = [UIImage imageNamed:@"bmf.jpg"];
    
    CGRect imageViewFrame = CGRectMake(10, 10, 80, 80);
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageViewFrame];
    imageView.image = image;
    [cell.contentView addSubview:imageView];
    
    
    CGRect Label1Frame = CGRectMake(100, 10, 290, 25);
    CGRect Label2Frame = CGRectMake(100, 33, 290, 25);
    UILabel *lblTemp;
    
    lblTemp = [[UILabel alloc] initWithFrame:Label1Frame];
    lblTemp.text = cellValue;
    [cell.contentView addSubview:lblTemp];
    
    lblTemp = [[UILabel alloc] initWithFrame:Label2Frame];
    lblTemp.text = @"the subtitle";
    [cell.contentView addSubview:lblTemp];
    
    return cell;    
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath //Table Row to Listing.
{    
    ListingViewController *listingView = [self.storyboard instantiateViewControllerWithIdentifier:@"ListingViewController"]; // Listing Detail Page
    listingView.listingTitle = listingsTableDataSource[indexPath.row];
    [self.navigationController pushViewController:listingView animated:YES];
    NSLog(@"Button");
}

// *** END TABLE METHODS

// Switch View Method

-(IBAction)SwitchView {
    
    // Also I haven't primed the array, yet it still works?
    
    //Button to switch between Map and Table view
    NSArray *viewArray = tourRoute.subviews; //Gathers an arrary of 'view' in the 'aroundMe' stack in order.
    if (viewArray[1] == mapWindow) // change to table view
    {
        // Main Window Animation
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:tourRoute cache:YES];
        [tourRoute bringSubviewToFront:tableView];
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
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:tourRoute cache:YES];        
        [tourRoute bringSubviewToFront:mapWindow];
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