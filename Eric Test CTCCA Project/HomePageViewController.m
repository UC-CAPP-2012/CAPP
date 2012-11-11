//
//  HomePageViewController.m
//  Eric Test CTCCA Project
//
//  Created by CTCCA on 23/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HomePageViewController.h"
#import "AppDelegate.h"
@interface HomePageViewController ()

@end

@implementation HomePageViewController
@synthesize toolBar;
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
-(void)viewWillAppear:(BOOL)animated
{
    //AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //if(appDelegate.showHomeOverlay==NO){
    //    [overlayView removeFromSuperview];
    //    toolbarView.hidden = false;
    //}
    //else{
    //   toolbarView.hidden = true;
    //}
    [self.navigationController setNavigationBarHidden:YES];
    
}

-(void)skipScreen
{
    //[self.navigationController setNavigationBarHidden:NO];
    EventFilterViewController *eventView = [self.storyboard instantiateViewControllerWithIdentifier:@"EventFilterViewController"];
    eventView.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;//UIModalTransitionStyleCoverVertical;
    [self presentModalViewController:eventView animated:YES];
    [self.navigationController setNavigationBarHidden:NO];
    NSLog(@"Button");
}

//Buttons
-(void)spinWheel:(id)sender // Control for Map View Button to Listing Detail View
{
    //[self.navigationController setNavigationBarHidden:NO];
    PickerViewController *pickerView = [self.storyboard instantiateViewControllerWithIdentifier:@"PickerViewController"]; // Listing Detail Page
    pickerView.title = @"Spinwheel";
    [self.navigationController pushViewController:pickerView animated:YES];
    [self.navigationController setNavigationBarHidden:NO];
    NSLog(@"spinWheel");
    
}
-(void)blabber:(id)sender  // Control for Map View Button to Listing Detail View
{
    //[self.navigationController setNavigationBarHidden:NO];
    BlabberViewController *blabberView = [self.storyboard instantiateViewControllerWithIdentifier:@"BlabberViewController"]; // Listing Detail Page
    [self.navigationController pushViewController:blabberView animated:YES];
    [self.navigationController setNavigationBarHidden:NO];
    //NSLog(@"Button");
    
}
-(void)aroundMe:(id)sender  // Control for Map View Button to Listing Detail View
{
    //[self.navigationController setNavigationBarHidden:NO];
    AroundMeMapListViewController *aroundMeView = [self.storyboard instantiateViewControllerWithIdentifier:@"AroundMeMapListViewController"];
    [self.navigationController pushViewController:aroundMeView animated:YES];
    [self.navigationController setNavigationBarHidden:NO];
    NSLog(@"Button");
    
}
-(void)explore:(id)sender  // Control for Map View Button to Listing Detail View
{
    //[self.navigationController setNavigationBarHidden:NO];
    ExploreScrollViewPagingController *exploreView = [self.storyboard instantiateViewControllerWithIdentifier:@"ExploreScrollViewPagingController"];
    [self.navigationController pushViewController:exploreView animated:YES];
    [self.navigationController setNavigationBarHidden:NO];
    NSLog(@"Button");
    
}
-(void)jaunts:(id)sender  // Control for Map View Button to Listing Detail View
{
    //[self.navigationController setNavigationBarHidden:NO];
    TourMapListViewController *tourView = [self.storyboard instantiateViewControllerWithIdentifier:@"TourMapListViewController"]; // Listing Detail Page
    [self.navigationController pushViewController:tourView animated:YES];
    [self.navigationController setNavigationBarHidden:NO];
    NSLog(@"Button");
    
}
-(void)happenings:(id)sender  // Control for Map View Button to Listing Detail View
{
    //[self.navigationController setNavigationBarHidden:NO];
    EventFilterViewController *eventView = [self.storyboard instantiateViewControllerWithIdentifier:@"EventFilterViewController"];
    [self.navigationController pushViewController:eventView animated:YES];
    [self.navigationController setNavigationBarHidden:NO];
    NSLog(@"Button");
    
}
-(void)loved:(id)sender // Control for Map View Button to Listing Detail View
{
    //[self.navigationController setNavigationBarHidden:NO];
    FavoritesViewController *favoritesView = [self.storyboard instantiateViewControllerWithIdentifier:@"FavoritesViewController"]; // Listing Detail Page
    [self.navigationController pushViewController:favoritesView animated:YES];
    [self.navigationController setNavigationBarHidden:NO];
    NSLog(@"loved");
    
}
-(void)myTrial:(id)sender  // Control for Map View Button to Listing Detail View
{
    AboutViewController *aboutView = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutViewController"]; // Listing Detail Page
    [self.navigationController pushViewController:aboutView animated:YES];
    [self.navigationController setNavigationBarHidden:NO];
    NSLog(@"about");
    
    
}

- (IBAction)closeOverlay:(id)sender {
    [overlayView removeFromSuperview];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.showHomeOverlay = NO;
    toolbarView.hidden = false;
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
