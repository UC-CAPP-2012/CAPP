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
#import "Tour.h"
#import "TourString.h"
#import <MapKit/MapKit.h>
#import "QuartzCore/QuartzCore.h"
#import <EventKitUI/EventKitUI.h>
#import "ToursIconDownloader.h"
#import "PullToRefreshView.h"

@interface TourMapListViewController : UIViewController<MKMapViewDelegate,UITableViewDelegate,UITableViewDataSource, NSXMLParserDelegate,EKEventEditViewDelegate, IconDownloaderDelegate, PullToRefreshViewDelegate>{

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
    
    TourString *tourList;
    NSMutableString *currentElementValue;
    NSMutableDictionary *imageDownloadsInProgress;  // the set of IconDownloader objects for each news
    
}

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSMutableArray* filteredTableData;
@property (nonatomic, assign) bool isFiltered;

@property(nonatomic, strong) NSMutableArray *tourListingTable,*tourListingsList,*tourListString;
@property (strong, nonatomic) Tour *currentTour;
@property (nonatomic, strong) NSMutableDictionary *imageDownloadsInProgress;

- (void)appImageDidLoad:(NSIndexPath *)indexPath;
-(void)setupArray;
-(void)setupMap;

@end
