//
//  FavoritesViewController.h
//  Eric Test CTCCA Project
//
//  Created by CTCCA on 30/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "QuartzCore/QuartzCore.h"
#import "ListingViewController.h"
#import <EventKitUI/EventKitUI.h>
#import "ListingString.h"
#import "PullToRefreshView.h"

@interface FavoritesViewController : UIViewController <NSXMLParserDelegate,MKMapViewDelegate,UITableViewDelegate,UITableViewDataSource,EKEventEditViewDelegate,PullToRefreshViewDelegate>
{
    IBOutlet UISegmentedControl *segmentController;
    IBOutlet UISearchBar *searchBar;
    IBOutlet UIView *MapWindow;
    NSMutableArray *favData;
    IBOutlet UIView *favView;
    IBOutlet UITableView *tableView;
    IBOutlet UIView *loadView;
    IBOutlet UIView *navView;
    IBOutlet UIView *switchMapView;
    IBOutlet UIView* sideSwipeView;
    UITableViewCell* sideSwipeCell;
    UISwipeGestureRecognizerDirection sideSwipeDirection;
    BOOL animatingSideSwipe;

    NSMutableArray *Cost;
    
    IBOutlet UIView *TableWindow;
    IBOutlet UIButton *ListingViewButton;
    IBOutlet UILabel *addressLabel;
    IBOutlet UILabel *startDateLabel;
    IBOutlet UILabel *TitleLabel;
    IBOutlet UIImageView *detailImage;
    IBOutlet MKMapView *mapView;
    IBOutlet UIView *detailView;
    IBOutlet UIView *switchTableView;
    ListingString *theList;
    IBOutlet UILabel *emptyListMsg;
    NSMutableString *currentElementValue;
}
@property (nonatomic, strong) IBOutlet UIView* sideSwipeView;
@property (nonatomic, strong) UITableViewCell* sideSwipeCell;
@property (nonatomic) UISwipeGestureRecognizerDirection sideSwipeDirection;
@property (nonatomic) BOOL animatingSideSwipe;
- (void) removeSideSwipeView:(BOOL)animated;
- (BOOL) gestureRecognizersSupported;

- (IBAction)switchViews;
- (IBAction)segmentedButton:(id)sender;
@property BOOL refreshing;
@property(strong, nonatomic)NSMutableDictionary *listing;
@property(strong, nonatomic)NSArray *listingsDataSource;
@property (strong, nonatomic) NSMutableArray* filteredTableData;
@property (nonatomic, assign) bool isFiltered;

@property(nonatomic, strong)NSMutableArray  *listingTable,*listingsList,*typeListingTable, *costListingTable, *suburbListingTable, *listingsListString;
@property(nonatomic)NSMutableArray *sortHeaders1,*sortHeaders2,*sortHeaders3,*sortHeaders4;
@property int currSel;
@property int sortSel;

-(void)setupArray;
-(void)setupMap;
@end
