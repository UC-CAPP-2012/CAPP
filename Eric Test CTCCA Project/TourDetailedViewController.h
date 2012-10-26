//
//  TourDetailedViewController.h
//  Eric Test CTCCA Project
//
//  Created by CTCCA on 13/10/12.
//
//

#import <UIKit/UIKit.h>
#import "Tour.h"
#import <MapKit/MapKit.h>
#import <EventKitUI/EventKitUI.h>
#import "ListingWebViewController.h"
#import "BlabberViewController.h"
#import "TourRoutesViewController.h"
#import "ListingString.h"

@interface TourDetailedViewController : UIViewController<NSXMLParserDelegate, MKMapViewDelegate,EKEventEditViewDelegate>{
    IBOutlet UIView *switchMapView;
    IBOutlet UIView *navView;
    IBOutlet UIView *switchTableView;
    
    IBOutlet UIView *loadView;
    IBOutlet UISegmentedControl *segmentController;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIPageControl *pageControl;
    IBOutlet UIView *tableView;
    IBOutlet UIView *mapWindow;
    Tour *currentTour;
    IBOutlet UIView *listingView;
    IBOutlet MKMapView *mapView;
    IBOutlet UIView *detailedView;
    IBOutlet UITableView *itineraryList;
    IBOutlet UIButton *ListingViewButton;
    IBOutlet UITextView *desciptionView;
    IBOutlet UILabel *AddressLabel;
    
    IBOutlet UILabel *DetailLabel;
    IBOutlet UILabel *TitleLabel;
    IBOutlet UIWebView *infoBox;
    IBOutlet UIImageView *DetailImage;
    IBOutlet UILabel *TourAgentLabel;
    IBOutlet UILabel *DetailsLabel;
    IBOutlet UIView *DetailView;
    ListingString *theList;
    NSMutableString *currentElementValue;
    
}

@property(strong, nonatomic)NSMutableDictionary *listing;
@property(strong, nonatomic)NSArray *listingsDataSource;
@property(nonatomic, strong)NSMutableArray *listingTable,*listingsList, *listingsListString;
@property (strong, nonatomic)Tour *currentTour;


- (IBAction)changePaged:(id)sender;
- (IBAction)segmentButton:(id)sender;
- (IBAction)shareWebsite:(id)sender;
- (IBAction)viewWebsite:(id)sender;
- (IBAction)viewNews:(id)sender;
- (IBAction)SwitchView:(id)sender;
- (IBAction)goHome:(id)sender;

- (IBAction)startTour:(id)sender;
-(void)setupItineraryTable;
-(void)setupMap;
-(void)setupPictures;
@end
