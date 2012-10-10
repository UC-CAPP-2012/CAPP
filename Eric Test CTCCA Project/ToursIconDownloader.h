//
//  ToursIconDownloader.h
//  Eric Test CTCCA Project
//
//  Created by CTCCA on 10/10/12.
//
//

@class Tour;
@class TourMapListViewController;
@protocol IconDownloaderDelegate;

@interface ToursIconDownloader : NSObject
{
    Tour *tour;
    NSIndexPath *indexPathInTableView;
    id <IconDownloaderDelegate> delegate;
    
    NSMutableData *activeDownload;
    NSURLConnection *imageConnection;
}

@property (nonatomic, retain) Tour *tour;
@property (nonatomic, retain) NSIndexPath *indexPathInTableView;
@property (nonatomic, retain) id <IconDownloaderDelegate> delegate;

@property (nonatomic, retain) NSMutableData *activeDownload;
@property (nonatomic, retain) NSURLConnection *imageConnection;

- (void)startDownload;
- (void)cancelDownload;

@end

@protocol IconDownloaderDelegate

- (void)appImageDidLoad:(NSIndexPath *)indexPath;

@end