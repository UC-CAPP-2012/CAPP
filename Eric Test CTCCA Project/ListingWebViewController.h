//
//  ListingWebViewController.h
//  Eric Test CTCCA Project
//
//  Created by CTCCA on 20/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListingWebViewController : UIViewController<UIWebViewDelegate>{
    IBOutlet UIWebView *webView;
    IBOutlet UIActivityIndicatorView *activityIndicator;
}


@property (strong, nonatomic)NSURL *Website;
@property(nonatomic)IBOutlet UIActivityIndicatorView *activityIndicator;

@end
