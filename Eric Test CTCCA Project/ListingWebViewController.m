//
//  ListingWebViewController.m
//  Eric Test CTCCA Project
//
//  Created by CTCCA on 20/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ListingWebViewController.h"

@interface ListingWebViewController ()

@end

@implementation ListingWebViewController
@synthesize activityIndicator, Website;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{

    //Change this the video URL passed from the other screen.
    [webView loadRequest:[NSURLRequest requestWithURL:Website]];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidDisappear:(BOOL)animated{
    activityIndicator.hidden=true;
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [activityIndicator startAnimating];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
   [activityIndicator stopAnimating];
    activityIndicator.hidesWhenStopped=YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
