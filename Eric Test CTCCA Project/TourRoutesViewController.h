//
//  TourRoutesViewController.h
//  Eric Test CTCCA Project
//
//  Created by CTCCA on 13/10/12.
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "AFNetworking.h"
#import <CoreLocation/CoreLocation.h>
#import "ListingViewController.h"
@interface TourRoutesViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate>{
    // the data representing the route points.
	NSMutableArray* _path;
    IBOutlet UILabel *DetailTitle;
    IBOutlet UIImageView *DetailImage;
    IBOutlet UIView *DetailView;
    IBOutlet UILabel *DetailSubtype;
    IBOutlet UIButton *DetailButton;
    IBOutlet UILabel *DetailAddress;
}

@property (nonatomic, strong) IBOutlet MKMapView* mapView;
@property(nonatomic, strong)NSMutableArray *listingsList;
@property (nonatomic, retain) NSMutableArray* path;
@property (strong, nonatomic) IBOutlet CLLocationManager *locationManager;
@property (strong, nonatomic) IBOutlet CLGeocoder *geoCoder;

@end
