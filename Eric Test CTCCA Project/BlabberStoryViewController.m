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
    [super setTitle:@"blabber"];
    
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
    
    //UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    //[newsTitle setFont:font];
    //  [newsTitle setTextColor:[UIColor colorWithRed:0.3 green:0.6 blue:0.54 alpha:1]];
    newsTitle.text = currentListing.NewsHeading;
    newsPublisher.text = currentListing.NewsPublisher;
    newsAuthor.text = currentListing.NewsAuthor;
    newsDate.text = currentListing.NewsDateTime;
    newsBody.text = currentListing.NewsBody;
    NSLog(@"%@",newsBody.text);
    [scrollView setScrollEnabled:TRUE];
    [scrollView setContentSize:CGSizeMake([newsBody contentSize].width, [newsBody contentSize].height+newImage.frame.size.height+200)];
    CGRect newFrame= newsBody.frame;
    newFrame.size.height = [newsBody contentSize].height+newImage.frame.size.height+600;
    newsBody.frame = newFrame;
    
    //[newsBody setContentSize:CGSizeMake([newsBody contentSize].width, [newsBody contentSize].height+newImage.frame.size.height+500)];
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

- (IBAction)imageClicked:(id)sender {
    BlabberImageViewController *listingView = [self.storyboard instantiateViewControllerWithIdentifier:@"BlabberImageViewController"]; // News Detail image Page
    listingView.selectedImage = currentListing.NewsMediaURL;
    listingView.newsTitle = currentListing.NewsHeading;
    [self.navigationController pushViewController:listingView animated:YES];
    NSLog(@"Button");
}
@end
