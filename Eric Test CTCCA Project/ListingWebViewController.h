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
    IBOutlet UIActivityIndicatorView *__weak activityIndicator;
}


@property (strong, nonatomic)NSURL *Website;
@property(weak, nonatomic)IBOutlet UIActivityIndicatorView *activityIndicator;

@end
