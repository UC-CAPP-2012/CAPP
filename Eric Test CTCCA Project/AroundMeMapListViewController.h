//
//  MapListViewController.h
//  Eric Test CTCCA Project
//
//  Created by CTCCA on 7/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "ListingViewController.h"
#import "ListingString.h"

@interface AroundMeMapListViewController : UIViewController<NSXMLParserDelegate,MKMapViewDelegate,UITableViewDelegate,UITableViewDataSource>{
    
    IBOutlet UIView *aroundMe;
    IBOutlet UIView *mapWindow;
    IBOutlet MKMapView *mapView;
    IBOutlet UITableView *tableView;
    
    IBOutlet UIView *loadView;
    
    IBOutlet UIView *DetailView;
    IBOutlet UIImageView *DetailImage;
    IBOutlet UILabel *TitleLabel;
    IBOutlet UILabel *StartDateLabel;
    IBOutlet UILabel *AddressLabel;
    
    IBOutlet UIButton *ListingViewButton;
    
    IBOutlet UIView *navView;
    IBOutlet UIView *switchMapView;
    IBOutlet UIView *switchTableView;
    
    ListingString *theList;
    NSMutableString *currentElementValue;
    
    float x1;
    float x2;
    float y1;
    float y2;
    
}

@property(nonatomic, strong)NSMutableArray *listingTable, *listingsList, *listingsListString;
@property(weak, nonatomic)NSArray *listingsTableDataSource;
-(void)setupArray;
-(void)setupMap;


@end
