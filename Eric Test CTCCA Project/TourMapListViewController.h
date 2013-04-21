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
#import "TourDetailedViewController.h"
#import "Tour.h"
#import "TourString.h"
#import <MapKit/MapKit.h>
#import "QuartzCore/QuartzCore.h"
#import <EventKitUI/EventKitUI.h>
#import "ToursIconDownloader.h"
#import "PullToRefreshView.h"

@interface TourMapListViewController : UIViewController<MKMapViewDelegate,UITableViewDelegate,UITableViewDataSource, NSXMLParserDelegate,EKEventEditViewDelegate, TourIconDownloaderDelegate, PullToRefreshViewDelegate>{
    
    IBOutlet UIView *tour;
    IBOutlet UITableView *tableView;
    
    
    IBOutlet UIView *loadView;
    
    
    IBOutlet UIButton *listingViewButton;
    TourString *tourList;
    NSMutableString *currentElementValue;
    NSMutableDictionary *imageDownloadsInProgress;  // the set of IconDownloader objects for each news
    
}
@property BOOL refreshing;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSMutableArray* filteredTableData;
@property (nonatomic, assign) bool isFiltered;

@property(nonatomic, strong) NSMutableArray *tourListingTable,*tourListingsList,*tourListString;
@property (strong, nonatomic) Tour *currentTour;
@property (nonatomic, strong) NSMutableDictionary *imageDownloadsInProgress;

- (void)appImageDidLoad:(NSIndexPath *)indexPath;
-(void)setupArray;

@end
