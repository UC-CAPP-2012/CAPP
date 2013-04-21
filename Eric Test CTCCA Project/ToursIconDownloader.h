//
//  ToursIconDownloader.h
//  Eric Test CTCCA Project
//
//  Created by CTCCA on 10/10/12.
//
//

@class Tour;
@class TourMapListViewController;
@protocol TourIconDownloaderDelegate;

@interface ToursIconDownloader : NSObject
{
    Tour *tour;
    NSIndexPath *indexPathInTableView;
    id <TourIconDownloaderDelegate> delegate;
    
    NSMutableData *activeDownload;
    NSURLConnection *imageConnection;
}

@property (nonatomic, strong) Tour *tour;
@property (nonatomic, strong) NSIndexPath *indexPathInTableView;
@property (nonatomic, strong) id <TourIconDownloaderDelegate> delegate;

@property (nonatomic, strong) NSMutableData *activeDownload;
@property (nonatomic, strong) NSURLConnection *imageConnection;

- (void)startDownload;
- (void)cancelDownload;

@end

@protocol TourIconDownloaderDelegate

- (void)appImageDidLoad:(NSIndexPath *)indexPath;

@end