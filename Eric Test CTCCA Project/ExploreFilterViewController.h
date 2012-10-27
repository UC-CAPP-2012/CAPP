//
//  ExploreFilterViewController.h
//  Eric Test CTCCA Project
//
//  Created by CTCCA on 16/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "QuartzCore/QuartzCore.h"
#import "ListingViewController.h"
#import "ExploreXMLParser.h"
#import "AreaXMLParser.h"
#import "ListingString.h"
#import "PullToRefreshView.h"

@interface ExploreFilterViewController : UIViewController<NSXMLParserDelegate,MKMapViewDelegate,UITableViewDelegate,UITableViewDataSource, PullToRefreshViewDelegate>{
    
    //Main Screen View outlets variables
    IBOutlet UIView *exploreView;
    IBOutlet UIView *mapWindow;
    IBOutlet MKMapView *mapView;
    IBOutlet UIView *tableWindow;
    IBOutlet UITableView *tableView;
    IBOutlet UIView* sideSwipeView;
    UITableViewCell* sideSwipeCell;
    UISwipeGestureRecognizerDirection sideSwipeDirection;
    BOOL animatingSideSwipe;

    //Navigation Bar View outlets
    IBOutlet UIView *navView;
    IBOutlet UIView *switchMapView;
    IBOutlet UIView *switchTableView;
    IBOutlet UIView *loadView;
    
    IBOutlet UIView *DetailView;
    IBOutlet UIImageView *DetailImage;
    IBOutlet UILabel *TitleLabel;
    IBOutlet UILabel *StartDateLabel;
    IBOutlet UILabel *AddressLabel;
    NSMutableArray *Cost;
    //Filter outlets
    IBOutlet UIButton *ListingViewButton;
    
    
    
    ExploreXMLParser *xmlParserSort1;
    ExploreXMLParser *xmlParserSort2;
    ExploreXMLParser *xmlParserSort3;
    AreaXMLParser *areaXmlParser;
    
    ListingString *theList;
    NSMutableString *currentElementValue;
    
    IBOutlet UISegmentedControl *segmentController;
}
- (IBAction)SwitchView;

-(IBAction)segmentButton:(id)sender;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSMutableArray* filteredTableData;
@property (nonatomic, assign) bool isFiltered;
@property (nonatomic, assign) bool listFiltered;
//Passed from previous Controller.
@property (strong, nonatomic)NSString *typeID;
@property (strong, nonatomic)NSString *typeName;
@property (nonatomic, retain) IBOutlet UIView* sideSwipeView;
@property (nonatomic, retain) UITableViewCell* sideSwipeCell;
@property (nonatomic) UISwipeGestureRecognizerDirection sideSwipeDirection;
@property (nonatomic) BOOL animatingSideSwipe;
- (IBAction)SwitchView:(id)sender;

- (void) removeSideSwipeView:(BOOL)animated;
- (BOOL) gestureRecognizersSupported;
@property(strong, nonatomic)NSArray *listingsDataSource;
@property(nonatomic, strong)NSMutableArray *listFilter,*listingTable, *listingsList, *typeListingTable, *costListingTable, *suburbListingTable, *listingsListString;
@property(nonatomic)NSMutableArray *sortHeaders1,*sortHeaders2,*sortHeaders3,*sortHeaders4;

@property int currSel;
@property int sortSel;

@property (strong, nonatomic)NSString *areaID;
@property (strong, nonatomic)NSString *sortID;

@property BOOL mapDefault;
@property BOOL listDefault;

@end
