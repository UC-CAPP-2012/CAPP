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

@property (nonatomic, strong) Tour *tour;
@property (nonatomic, strong) NSIndexPath *indexPathInTableView;
@property (nonatomic, strong) id <IconDownloaderDelegate> delegate;

@property (nonatomic, strong) NSMutableData *activeDownload;
@property (nonatomic, strong) NSURLConnection *imageConnection;

- (void)startDownload;
- (void)cancelDownload;

@end

@protocol IconDownloaderDelegate

- (void)appImageDidLoad:(NSIndexPath *)indexPath;

@end