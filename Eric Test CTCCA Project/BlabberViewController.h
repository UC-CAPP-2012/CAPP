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
}

@property(nonatomic, strong) NSMutableArray *newsListingTable,*newsListingsList,*newsListString;
@property (strong, nonatomic) News *currentNews;
@property (nonatomic, strong) NSMutableDictionary *imageDownloadsInProgress;

- (void)appImageDidLoad:(NSIndexPath *)indexPath;
-(void) setupArray;
@end
