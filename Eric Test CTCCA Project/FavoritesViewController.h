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
    NSMutableArray *favData;
    IBOutlet UITableView *tableView;
    IBOutlet UIView *loadView;
    
    ListingString *theList;
    NSMutableString *currentElementValue;
}
@property(strong, nonatomic)NSMutableDictionary *listing;
@property(strong, nonatomic)NSArray *listingsDataSource;
@property(nonatomic, strong)NSMutableArray *monthFilter, *listingTable,*listingsList, *listingsListString;
@property(nonatomic)NSMutableArray *sortHeaders1,*sortHeaders2,*sortHeaders3,*sortHeaders4;
@property int currSel;
@property int sortSel;

-(void)setupArray;
-(void)setupMap;
@end
