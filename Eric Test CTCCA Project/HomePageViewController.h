//
//  HomePageViewController.h
//  Eric Test CTCCA Project
//
//  Created by CTCCA on 23/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AroundMeMapListViewController.h"
#import "ExploreScrollViewPagingController.h"
#import "EventFilterViewController.h"
#import "TourMapListViewController.h"
#import "BlabberTableViewController.h"
#import "FavoritesViewController.h"
#import "PickerViewController.h"

//add the spin wheel header to this also
//as well as the favourites 'loved'
//as well as trails.


@interface HomePageViewController : UIViewController

-(IBAction)spinWheel:(id)sender;
-(IBAction)blabber:(id)sender;
-(IBAction)aroundMe:(id)sender;
-(IBAction)explore:(id)sender;
-(IBAction)jaunts:(id)sender;
-(IBAction)happenings:(id)sender;
-(IBAction)loved:(id)sender;
-(IBAction)myTrial:(id)sender;
@end
