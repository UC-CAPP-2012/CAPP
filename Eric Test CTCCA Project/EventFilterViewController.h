//
//  EventFilterViewController.h
//  Eric Test CTCCA Project
//
//  Created by CTCCA on 16/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "QuartzCore/QuartzCore.h"
#import "ListingViewController.h"
#import <EventKitUI/EventKitUI.h>
#import "ListingString.h"
#import "PullToRefreshView.h"

@interface EventFilterViewController : UIViewController<NSXMLParserDelegate,MKMapViewDelegate,UITableViewDelegate,UITableViewDataSource,EKEventEditViewDelegate, PullToRefreshViewDelegate>{
    
    //Main Screen View outlets
    IBOutlet UIView *eventView;
    IBOutlet MKMapView *mapView;
    IBOutlet UIView *mapWindow;
    IBOutlet UITableView *tableView;
    IBOutlet UIView *tableWindow;
    IBOutlet UIView* sideSwipeView;
    UITableViewCell* sideSwipeCell;
    UISwipeGestureRecognizerDirection sideSwipeDirection;
    BOOL animatingSideSwipe;
    IBOutlet UIView *loadView;
    
    //Information Box
    IBOutlet UIView *DetailView;
    IBOutlet UIImageView *DetailImage;
    IBOutlet UILabel *TitleLabel;
    IBOutlet UILabel *StartDateLabel;
    IBOutlet UILabel *AddressLabel;
    
    IBOutlet UIButton *ListingViewButton;
    
    //Navigation Bar View outlets
    IBOutlet UIView *navView;
    IBOutlet UIView *switchMapView;
    IBOutlet UIView *switchTableView;
    
    
    IBOutlet UILabel *dateLabel;
    IBOutlet UIButton *nextMonth;
    IBOutlet UIButton *previousMonth;
    IBOutlet UISegmentedControl *segmentController;
    
    ListingString *theList;
    NSMutableString *currentElementValue;
}

-(IBAction)nextMonth:(id)sender;
-(IBAction)previousMonth:(id)sender;
-(IBAction)segmentButton:(id)sender;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSMutableArray* filteredTableData;
@property (nonatomic, assign) bool isFiltered;

@property(strong, nonatomic)NSMutableDictionary *listing;
@property(strong, nonatomic)NSArray *listingsDataSource;
@property(nonatomic, strong)NSMutableArray *monthFilter, *listingTable,*listingsList, *listingsListString;
@property(nonatomic)NSMutableArray *sortHeaders1,*sortHeaders2,*sortHeaders3,*sortHeaders4;

@property (nonatomic, retain) IBOutlet UIView* sideSwipeView;
@property (nonatomic, retain) UITableViewCell* sideSwipeCell;
@property (nonatomic) UISwipeGestureRecognizerDirection sideSwipeDirection;
@property (nonatomic) BOOL animatingSideSwipe;

- (void) removeSideSwipeView:(BOOL)animated;
- (BOOL) gestureRecognizersSupported;

@property int currSel;
@property int sortSel;

-(void)setupArray;
-(void)setupMap;
@end
