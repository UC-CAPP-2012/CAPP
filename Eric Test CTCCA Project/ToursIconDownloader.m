//
//  ToursIconDownloader.m
//  Eric Test CTCCA Project
//
//  Created by CTCCA on 10/10/12.
//
//

#import "ToursIconDownloader.h"

#import "Tour.h"

#define kAppIconWidth 89
#define kAppIconHeight 103

@implementation ToursIconDownloader

@synthesize tour;
@synthesize indexPathInTableView;
@synthesize delegate;
@synthesize activeDownload;
@synthesize imageConnection;

#pragma mark

- (void)startDownload
{
    self.activeDownload = [NSMutableData data];
    // alloc+init and start an NSURLConnection; release on completion/failure
    NSString *urlString = [(tour.ImageFileNames)[0] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSURL *ImageURL = [NSURL URLWithString:urlString];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:
                             [NSURLRequest requestWithURL:ImageURL] delegate:self];
    self.imageConnection = conn;
}

- (void)cancelDownload
{
    [self.imageConnection cancel];
    self.imageConnection = nil;
    self.activeDownload = nil;
}


#pragma mark -
#pragma mark Download support (NSURLConnectionDelegate)

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.activeDownload appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	// Clear the activeDownload property to allow later attempts
    self.activeDownload = nil;
    
    // Release the connection now that it's finished
    self.imageConnection = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // Set appIcon and clear temporary data/image
    UIImage *image = [[UIImage alloc] initWithData:self.activeDownload];
    
//    if (image.size.width != kAppIconWidth || image.size.height != kAppIconHeight)
//	{
//        CGSize itemSize = CGSizeMake(kAppIconWidth, kAppIconHeight);
//		UIGraphicsBeginImageContext(itemSize);
//		CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
//		[image drawInRect:imageRect];
//		self.tour.TourIcon = UIGraphicsGetImageFromCurrentImageContext();
//		UIGraphicsEndImageContext();
//    }
//    else
    //{
        self.tour.TourIcon = image;
    //}
    
    self.activeDownload = nil;
    
    // Release the connection now that it's finished
    self.imageConnection = nil;
    
    // call our delegate and tell it that our icon is ready for display
    [delegate appImageDidLoad:self.indexPathInTableView];
}

@end

