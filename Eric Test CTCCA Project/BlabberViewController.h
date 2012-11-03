//
//  BlabberViewController.h
//  Eric Test CTCCA Project
//
//  Created by CTCCA on 8/10/12.
//
//

#import <UIKit/UIKit.h>
#import "News.h"
#import "NewsString.h"
#import <MapKit/MapKit.h>
#import "QuartzCore/QuartzCore.h"
#import "ListingViewController.h"
#import <EventKitUI/EventKitUI.h>
#import "ListingString.h"
#import "IconDownloader.h"
#import "PullToRefreshView.h"
@interface BlabberViewController : UIViewController<NSXMLParserDelegate,EKEventEditViewDelegate, IconDownloaderDelegate, PullToRefreshViewDelegate>{
    
    IBOutlet UIView *loadView;
    IBOutlet UITableView *tableView;
    NewsString *newsList;
    NSMutableString *currentElementValue;
    NSMutableDictionary *imageDownloadsInProgress;  // the set of IconDownloader objects for each news
    IBOutlet UIActivityIndicatorView *loadMoreIndicator;
    IBOutlet UIButton *loadMorebtn;
    IBOutlet UIView *loadMoreView;
}
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

- (IBAction)loadMoreNews:(id)sender;
@property(nonatomic, strong) NSMutableArray *newsListingTable,*newsListingsList,*newsListString;
@property (strong, nonatomic) News *currentNews;
@property (nonatomic, strong) NSMutableDictionary *imageDownloadsInProgress;
@property (strong, nonatomic) NSMutableArray* filteredTableData;
@property (nonatomic, assign) bool isFiltered;
@property BOOL refreshing;
- (void)appImageDidLoad:(NSIndexPath *)indexPath;
-(void) setupArray;
@end
