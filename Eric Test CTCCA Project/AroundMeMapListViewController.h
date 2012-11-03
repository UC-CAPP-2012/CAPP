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
#import "PullToRefreshView.h"

@interface AroundMeMapListViewController : UIViewController<NSXMLParserDelegate,MKMapViewDelegate,UITableViewDelegate,UITableViewDataSource,PullToRefreshViewDelegate>{
    
    IBOutlet UIView *aroundMe;
    IBOutlet UIView *mapWindow;
    IBOutlet MKMapView *mapView;
    IBOutlet UITableView *tableView;
    IBOutlet UIView* sideSwipeView;
    UITableViewCell* sideSwipeCell;
    IBOutlet UISearchBar *searchBar;
    UISwipeGestureRecognizerDirection sideSwipeDirection;
    BOOL animatingSideSwipe;

    IBOutlet UISegmentedControl *segmentControll;
    IBOutlet UIView *loadView;
    
    IBOutlet UIView *DetailView;
    IBOutlet UIImageView *DetailImage;
    IBOutlet UILabel *TitleLabel;
    IBOutlet UILabel *StartDateLabel;
    IBOutlet UILabel *AddressLabel;
    
    NSMutableArray *Cost;
    IBOutlet UIButton *ListingViewButton;
    
    IBOutlet UIView *navView;
    IBOutlet UIView *switchMapView;
    IBOutlet UIView *switchTableView;
    NSMutableArray *favData;
    ListingString *theList;
    NSMutableString *currentElementValue;
//    
//    float x1;
//    float x2;
//    float y1;
//    float y2;
    
}
- (IBAction)segmentedButton:(id)sender;
@property (nonatomic, strong) IBOutlet UIView* sideSwipeView;
@property (nonatomic, strong) UITableViewCell* sideSwipeCell;
@property (nonatomic) UISwipeGestureRecognizerDirection sideSwipeDirection;
@property (nonatomic) BOOL animatingSideSwipe;
@property (strong, nonatomic) NSMutableArray* filteredTableData;
- (void) removeSideSwipeView:(BOOL)animated;
- (BOOL) gestureRecognizersSupported;
@property BOOL refreshing;
@property (nonatomic, assign) bool isFiltered;
@property(nonatomic, strong)NSMutableArray *listingTable,*typeListingTable, *costListingTable, *suburbListingTable, *listingsList, *listingsListString;
@property(strong, nonatomic)NSArray *listingsTableDataSource;
@property(nonatomic)NSMutableArray *sortHeaders1,*sortHeaders2,*sortHeaders3,*sortHeaders4;


-(void)setupArray;
-(void)setupMap;
- (IBAction)currentUserLocation:(id)sender;
@property int currSel;
@property int sortSel;
@end
