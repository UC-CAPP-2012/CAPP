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
    
    
    dispatch_queue_t concurrentQueue =
    dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(concurrentQueue, ^(void){

    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:currentListing.NewsMediaURL]];
        dispatch_async(dispatch_get_main_queue(), ^{
        newImage.image = image;
            loadView.hidden=TRUE;
        });
    });
    
}

@end
