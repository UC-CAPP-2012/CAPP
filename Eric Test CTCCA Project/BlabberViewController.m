//
//  BlabberViewController.m
//  Eric Test CTCCA Project
//
//  Created by CTCCA on 25/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BlabberViewController.h"

@interface BlabberViewController ()

@end

@implementation BlabberViewController


@synthesize newsView;
@synthesize newsTableView;
@synthesize newsTableCell;
@synthesize publishDate;
@synthesize newsImage;
@synthesize newsHeadding;
@synthesize authorName;
@synthesize newsContents;
@synthesize newsLoadView;
@synthesize newsLoadIndicator;

@synthesize newsList;
@synthesize currentNews;

@synthesize NewsID;
@synthesize NewsDateTime;
@synthesize NewsBody;
@synthesize NewsMediaURL;
@synthesize NewsPublisher;
@synthesize NewsAuthor;



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
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
