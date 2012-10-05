//
//  FavoritesViewController.h
//  Eric Test CTCCA Project
//
//  Created by CTCCA on 30/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "QuartzCore/Quartzcore.h"
#import "ListingViewController.h"
#import <EventKitUI/EventKitUI.h>
#import "ListingString.h"

@interface FavoritesViewController : UIViewController <NSXMLParserDelegate,MKMapViewDelegate,UITableViewDelegate,UITableViewDataSource,EKEventEditViewDelegate>
{
    IBOutlet UIView *MapWindow;
    NSMutableArray *favData;
    IBOutlet UIView *favView;
    IBOutlet UITableView *tableView;
    IBOutlet UIView *loadView;
    IBOutlet UIView *navView;
    IBOutlet UIView *switchMapView;
    
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
    NSMutableString *currentElementValue;
}
- (IBAction)switchViews;

@property(strong, nonatomic)NSMutableDictionary *listing;
@property(strong, nonatomic)NSArray *listingsDataSource;
@property(nonatomic, strong)NSMutableArray *monthFilter, *listingTable,*listingsList, *listingsListString;
@property(nonatomic)NSMutableArray *sortHeaders1,*sortHeaders2,*sortHeaders3,*sortHeaders4;
@property int currSel;
@property int sortSel;

-(void)setupArray;
-(void)setupMap;
@end
