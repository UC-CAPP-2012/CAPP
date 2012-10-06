//
//  BlabberStoryViewController.m
//  Eric Test CTCCA Project
//
//  Created by CTCCA on 25/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BlabberStoryViewController.h"

@interface BlabberStoryViewController ()

@end

@implementation BlabberStoryViewController
@synthesize currentListing;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
     [self setupArray];
    loadView.hidden=TRUE;
}

- (void)viewDidLoad
{
    [super setTitle:@"Blabber"];
   
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

-(void) setupArray
{
    
    currentListing = self.currentListing;
    NSLog(@"%@",currentListing.NewsID);
    
    UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:22];
    [newsTitle setFont:font];
    newsTitle.text = currentListing.NewsHeading;
    newsPublisher.text = currentListing.NewsPublisher;
    newsAuthor.text = currentListing.NewsAuthor;
    newsDate.text = currentListing.NewsDateTime;
    newsBody.text = currentListing.NewsBody;
    
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:currentListing.NewsMediaURL]];
    newImage.image = image;
}

@end
