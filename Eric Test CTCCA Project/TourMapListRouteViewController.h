//
//  TourMapListRouteViewController.h
//  Eric Test CTCCA Project
//
//  Created by CTCCA on 25/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "ListingViewController.h"

@interface TourMapListRouteViewController : UIViewController<MKMapViewDelegate,UITableViewDelegate,UITableViewDataSource>{
    
    IBOutlet UIView *tourRoute;
    IBOutlet MKMapView *mapView;
    IBOutlet UIView *mapWindow;
    IBOutlet UITableView *tableView;
    
    //Navigation Bar Outlets
    IBOutlet UIView *navView;
    IBOutlet UIView *switchMapView;
    IBOutlet UIView *switchTableView;
    
    IBOutlet UIView *loadView;
    
    //Information Box
    IBOutlet UIView *DetailView;
    IBOutlet UIImageView *DetailImage;
    IBOutlet UILabel *TitleLabel;
    IBOutlet UILabel *StartDateLabel;
    IBOutlet UILabel *AddressLabel;
    
}

@property(nonatomic)NSMutableArray *listingTable;
@property(nonatomic)NSArray *listingsTableDataSource;

-(void)setupArray;
-(void)setupMap;

@end
