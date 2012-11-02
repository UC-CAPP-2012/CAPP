//
//  ListingViewController.h
//  Eric Test CTCCA Project
//
//  Created by CTCCA on 16/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <EventKitUI/EventKitUI.h>
#import <MessageUI/MessageUI.h>
#import "ListingWebViewController.h"
#import "NavigationViewController.h"
#import "Listing.h"
#import "ListingString.h"

@interface ListingViewController : UIViewController<NSXMLParserDelegate, MKMapViewDelegate,EKEventEditViewDelegate, MFMailComposeViewControllerDelegate, UIWebViewDelegate>{
    
    //Main Screen View outlets
    IBOutlet UIView *listingView;
    IBOutlet UIView *mapWindow;
    IBOutlet MKMapView *mapView;
    IBOutlet UIView *tableView;
    IBOutlet UIView *loadView;
    IBOutlet UIView *DetailView;
    IBOutlet UIImageView *DetailImage;
    IBOutlet UILabel *TitleLabel;
    IBOutlet UILabel *StartDateLabel;
    IBOutlet UILabel *AddressLabel;
    //Navigation Bar View outlets
    IBOutlet UIView *navView;
    IBOutlet UIView *switchMapView;
    IBOutlet UIView *switchTableView;
    IBOutlet UIScrollView	*scrollView;
    IBOutlet UIPageControl *pageControl;    
    IBOutlet UIWebView *infoBox;
    IBOutlet UISegmentedControl *segmentController;

    NSMutableArray *favData;
    NSMutableArray *Cost;
    
    IBOutlet UIBarItem *favButton;
    ListingString *theList;
    NSMutableString *currentElementValue;
    
}
@property(nonatomic, strong)NSMutableArray *listingsList, *listingsListString;
@property (strong, nonatomic)NSString *listingID;
@property (strong, nonatomic)NSString *listingTitle;
@property (strong, nonatomic)Listing *currentListing;
@property BOOL favourite;
-(void)setupMap;
-(void)unfavourite;
-(IBAction)changePage;
-(IBAction)segmentButton:(id)sender;
-(IBAction)addToCalendar:(id)sender;
- (IBAction)home:(id)sender;
- (IBAction)email:(id)sender;

@end
