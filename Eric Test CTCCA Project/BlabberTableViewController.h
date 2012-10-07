//
//  BlabberTableViewController.h
//  Eric Test CTCCA Project
//
//  Created by Hassna Alqarni on 4/10/12.
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

@interface BlabberTableViewController : UITableViewController<NSXMLParserDelegate,EKEventEditViewDelegate, IconDownloaderDelegate>{

    IBOutlet UITableView *tableView;
    NewsString *newsList;
    NSMutableString *currentElementValue;
    NSMutableDictionary *imageDownloadsInProgress;  // the set of IconDownloader objects for each news
}

@property(nonatomic, strong) NSMutableArray *newsListingTable,*newsListingsList,*newsListString;
@property (strong, nonatomic) News *currentNews;
@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;

- (void)appImageDidLoad:(NSIndexPath *)indexPath;
-(void) setupArray;
@end
