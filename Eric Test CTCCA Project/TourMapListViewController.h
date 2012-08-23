//
//  AreaMapListViewController.h
//  Eric Test CTCCA Project
//
//  Created by CTCCA on 11/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

//  Class Header needs to be corrected with 'tours'

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "ListingViewController.h"


@interface TourMapListViewController : UIViewController<MKMapViewDelegate,UITableViewDelegate,UITableViewDataSource>{

IBOutlet UIView *tour;
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
@property(weak, nonatomic)NSArray *listingsTableDataSource;

-(void)setupArray;
-(void)setupMap;

@end
