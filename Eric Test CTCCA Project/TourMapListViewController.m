//
//  AreaMapListViewController.m
//  Eric Test CTCCA Project
//
//  Created by CTCCA on 11/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TourMapListViewController.h"
#import "Listing.h"

@interface TourMapListViewController ()

@end

@implementation TourMapListViewController
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
    // ** Map View Population

    // ** Map View Population
    CLLocationCoordinate2D placemarker;
    placemarker.latitude = -35.281150;
    placemarker.longitude = 149.128668;    
    
    Listing *ann = [[Listing alloc] init];
    ann.title = @"Tour 1";
    ann.subtitle = @"Tour subtitle";
    ann.coordinate = placemarker;
    ann.imageFilenames = [NSArray arrayWithObjects:@"http://i681.photobucket.com/albums/vv173/kandisdesign/Kandis/240x110.png", nil];
    
    //Add Placemarker to map
    [mapView addAnnotation:ann];
    // ** Table View Population
    

    
    NSArray *firstSection = [NSArray arrayWithObjects:@"Tour 1", @"Tour 2", nil];
    NSDictionary *firstSectionDict = [NSDictionary dictionaryWithObject:firstSection forKey:@"Tours"];
    
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
        DetailImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[((Listing *) view.annotation).imageFilenames objectAtIndex:0]]]];
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
    static NSString *cellIdentifier = @"tourCell";
    UITableViewCell *cell = (UITableViewCell *) [listingTableView dequeueReusableCellWithIdentifier:cellIdentifier];

    NSDictionary *dictionary = [listingTable objectAtIndex:indexPath.row];
    NSArray *array = [dictionary objectForKey:@"Tours"];
    NSString *cellValue = [array objectAtIndex:indexPath.row];
    
    if(cell == nil) 
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    UIImage* image = [UIImage imageNamed:@"splash.png"];
         
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
    lblTemp.text = @"tour subtitle";
    [cell.contentView addSubview:lblTemp];
        
    return cell;    
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath //Table Row to Listing.
{    
    //ListingViewController *listingView = [self.storyboard instantiateViewControllerWithIdentifier:@"ListingViewController"]; // Listing Detail Page
    //listingView.listingTitle = [listingsTableDataSource objectAtIndex:indexPath.row];
    //[self.navigationController pushViewController:listingView animated:YES];
    NSLog(@"Button");
}

// *** END TABLE METHODS

// Switch View Method

-(IBAction)SwitchView {
    
    // Will need to insert program view sequence.
    
    //Button to switch between Map and Table view
    NSArray *viewArray = tour.subviews; //Gathers an arrary of 'view' in the 'aroundMe' stack in order.
    if ([viewArray objectAtIndex:1] == mapWindow) // change to table view
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
    else if ([viewArray objectAtIndex:1] == tableView) // change to mapview
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