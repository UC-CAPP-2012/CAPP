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
#import "BlabberViewController.h"
#import "FavoritesViewController.h"
#import "PickerViewController.h"
#import "AboutViewController.h"

//add the spin wheel header to this also
//as well as the favourites 'loved'

@interface HomePageViewController : UIViewController
{
    IBOutlet UIBarButtonItem *about;
    
    IBOutlet UIBarButtonItem *love;
    IBOutlet UIToolbar *toolbarView;
}

@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
-(IBAction)spinWheel:(id)sender;
-(IBAction)blabber:(id)sender;
-(IBAction)aroundMe:(id)sender;
-(IBAction)explore:(id)sender;
-(IBAction)jaunts:(id)sender;
-(IBAction)happenings:(id)sender;
-(IBAction)loved:(id)sender;
-(IBAction)myTrial:(id)sender;


@end
