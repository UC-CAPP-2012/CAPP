//
//  TourRoutesViewController.m
//  Eric Test CTCCA Project
//
//  Created by CTCCA on 13/10/12.
//
//

#import "TourRoutesViewController.h"
#import "NVPolylineAnnotationView.h"
#import "Listing.h"

@interface TourRoutesViewController ()

@end

@implementation TourRoutesViewController
@synthesize mapView = _mapView;
@synthesize path = _path;
CLLocationManager *locationManager;
CLGeocoder *geocoder;
NSString *currentDestination;
@synthesize listingsList;

- (void)viewDidLoad
{
    Listing *firstLocation = listingsList[0];
    currentDestination = firstLocation.address;
    [_mapView removeAnnotations:_mapView.annotations];
	locationManager = [[CLLocationManager alloc] init];
    geocoder = [[CLGeocoder alloc] init];
	_mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)] ;
	[_mapView setDelegate:self];
	[self.view addSubview:_mapView];
    _mapView.showsUserLocation=TRUE;
    _mapView.showsUserLocation = YES;
    locationManager.delegate=self;
    for(int a =0; a<listingsList.count;a++){
        [_mapView addAnnotation:listingsList[a]];
    }
    
    
    [_mapView setMapType:MKMapTypeStandard];
    [_mapView setZoomEnabled:YES];
    [_mapView setScrollEnabled:YES];
    [_mapView setDelegate:self];
    
    //Center Map on users location;
    //CLLocationCoordinate2D zoomLocation;
    MKCoordinateRegion region = {{0.0, 0.0}, {0.0,0.0}};
    region.center.latitude = -35.281150; //mapView.userLocation.location.coordinate.latitude;
    region.center.longitude = 149.128668; //mapView.userLocation.location.coordinate.longitude;
    region.span.latitudeDelta = 0.15f; // Zoom Settings
    region.span.longitudeDelta = 0.25f; // Zoom Settings
    [_mapView setRegion:region animated:YES];
        //Get user location
    [locationManager startUpdatingLocation];
    [super viewDidLoad];
}

-(void)mapView:(MKMapView *)mapViewSelect didSelectAnnotationView:(MKPinAnnotationView *)view
{
    NSLog(@"didSelectAnnotationView");
   // DetailView.hidden = FALSE;
    view.pinColor = MKPinAnnotationColorGreen;
    currentDestination = [(Listing *)view.annotation init].address;
    [locationManager startUpdatingLocation];
    for(id<MKOverlay> overlayToRemove in _mapView.overlays){
        if([overlayToRemove isKindOfClass:[MKPolyline class]]){
            [_mapView removeOverlay:overlayToRemove];
        }
    }
//    if ([view.annotation isKindOfClass:[Listing class]] )
//    {
//        Listing *selected = [(Listing *)view.annotation init];
//        //Title
//        TitleLabel.text = view.annotation.title;
//        
//        //Address
//        AddressLabel.text = ((Listing *) view.annotation).address;
//        
//        //Start Date
//        NSDateFormatter *startDateFormat = [[NSDateFormatter alloc] init];
//        [startDateFormat setDateFormat:@"EEEE','MMMM d'.' KK:mma"];
//        NSString *startDateString = [startDateFormat stringFromDate:((Listing *) view.annotation).startDate];
//        StartDateLabel.text = startDateString;
//        
//        //Detail Image
//        NSString *imageString = [(((Listing *) view.annotation).imageFilenames)[0] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//        DetailImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageString]]];
//        NSLog(@"%@",(((Listing *) view.annotation).imageFilenames)[0]);
//        
//        NSString *listingID = ((Listing *) view.annotation).listingID;
//        for (int i = 0; i < [listingsList count]; i++) {
//            Listing *currentListing = listingsList[i];
//            if ([currentListing.listingID isEqualToString:listingID]) {
//                ListingViewButton.tag = i;
//            }
//        }
//        [ListingViewButton addTarget:self action:@selector(ListingView:) forControlEvents:UIControlEventTouchUpInside];
//    }
    
}


-(void)mapView:(MKMapView *)mapViewDeSelect didDeselectAnnotationView:(MKPinAnnotationView *)view
{
    NSLog(@"didDeselectAnnotationView");
    //DetailView.hidden = TRUE;
    view.pinColor = MKPinAnnotationColorRed;
}


- (void)parseResponse:(NSDictionary *)response {
    NSArray *routes = [response objectForKey:@"routes"];
    NSDictionary *route = [routes lastObject];
    if (route) {
        NSString *overviewPolyline = [[route objectForKey: @"overview_polyline"] objectForKey:@"points"];
        _path = [self decodePolyLine:overviewPolyline];
    }
}

- (void)viewDidUnload
{
    [self setLocationManager:nil];
    [self setGeoCoder:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    //Geocoding Block
    [self.geoCoder reverseGeocodeLocation: locationManager.location completionHandler:
     ^(NSArray *placemarks, NSError *error) {
         [locationManager stopUpdatingLocation];
         //Get nearby address
         CLPlacemark *placemark = [placemarks objectAtIndex:0];
         
         //String to hold address
         NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
         
         //Print the location to console
         NSLog(@"I am currently at %@",locatedAt);
         
         AFHTTPClient *_httpClient = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:@"http://maps.googleapis.com/"]];
         [_httpClient registerHTTPOperationClass: [AFJSONRequestOperation class]];
         [_httpClient setDefaultHeader:@"Accept" value:@"application/json"];
         
         
         //NSLog(@"%@", placemark.country);
         
         NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
         [parameters setObject:[NSString stringWithFormat:@"%@", [locatedAt stringByReplacingOccurrencesOfString:@" " withString:@"+"]] forKey:@"origin"];
         [parameters setObject:[NSString stringWithFormat:@"%@", [currentDestination stringByReplacingOccurrencesOfString:@" " withString:@"+"]] forKey:@"destination"];
         [parameters setObject:@"true" forKey:@"sensor"];
         
         NSMutableURLRequest *request = [_httpClient requestWithMethod:@"GET" path: @"maps/api/directions/json" parameters:parameters];
         request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
         
         AFHTTPRequestOperation *operation = [_httpClient HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id response) {
             NSInteger statusCode = operation.response.statusCode;
             if (statusCode == 200) {
                 [self parseResponse:response];
                 NSInteger numberOfSteps = _path.count;
                 
                 CLLocationCoordinate2D coordinates[numberOfSteps];
                 for (NSInteger index = 0; index < numberOfSteps; index++) {
                     CLLocation *location = [_path objectAtIndex:index];
                     CLLocationCoordinate2D coordinate = location.coordinate;
                     coordinates[index] = coordinate;
                 }
                 
                 MKPolyline *polyLine = [MKPolyline polylineWithCoordinates:coordinates count:numberOfSteps];
                 [_mapView addOverlay:polyLine];
             } else {
                 
             }
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) { }];
         
         [_httpClient enqueueHTTPRequestOperation:operation];
     }];

    
    

}


-(NSMutableArray *)decodePolyLine:(NSString *)encodedStr {
    NSMutableString *encoded = [[NSMutableString alloc] initWithCapacity:[encodedStr length]];
    [encoded appendString:encodedStr];
    [encoded replaceOccurrencesOfString:@"\\\\" withString:@"\\"
                                options:NSLiteralSearch
                                  range:NSMakeRange(0, [encoded length])];
    NSInteger len = [encoded length];
    NSInteger index = 0;
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSInteger lat=0;
    NSInteger lng=0;
    while (index < len) {
        NSInteger b;
        NSInteger shift = 0;
        NSInteger result = 0;
        do {
            b = [encoded characterAtIndex:index++] - 63;
            result |= (b & 0x1f) << shift;
            shift += 5;
        } while (b >= 0x20);
        NSInteger dlat = ((result & 1) ? ~(result >> 1) : (result >> 1));
        lat += dlat;
        shift = 0;
        result = 0;
        do {
            b = [encoded characterAtIndex:index++] - 63;
            result |= (b & 0x1f) << shift;
            shift += 5;
        } while (b >= 0x20);
        NSInteger dlng = ((result & 1) ? ~(result >> 1) : (result >> 1));
        lng += dlng;
        NSNumber *latitude = [[NSNumber alloc] initWithFloat:lat * 1e-5];
        NSNumber *longitude = [[NSNumber alloc] initWithFloat:lng * 1e-5];
        
        CLLocation *location = [[CLLocation alloc] initWithLatitude:[latitude floatValue] longitude:[longitude floatValue]];
        [array addObject:location];
    }
    
    return array;
}


- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
    MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:overlay];
    polylineView.strokeColor = [UIColor redColor];
    polylineView.lineWidth = 3.0;
    
    return polylineView;
}

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
    
    if ([annotation isKindOfClass:[NVPolylineAnnotation class]]) {
		return [[NVPolylineAnnotationView alloc] initWithAnnotation:annotation mapView:_mapView] ;
	}
    
    
    return MyPin;
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


// END MAP METHODS




@end
