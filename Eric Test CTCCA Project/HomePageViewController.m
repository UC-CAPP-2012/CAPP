//
//  HomePageViewController.m
//  Eric Test CTCCA Project
//
//  Created by CTCCA on 23/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HomePageViewController.h"

@interface HomePageViewController ()

@end

@implementation HomePageViewController

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
-(void)viewDidAppear:(BOOL)animated
{

}

-(void)skipScreen
{
    EventFilterViewController *eventView = [self.storyboard instantiateViewControllerWithIdentifier:@"EventFilterViewController"];
    eventView.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;//UIModalTransitionStyleCoverVertical;
    [self presentModalViewController:eventView animated:YES];
    NSLog(@"Button"); 
}

//Buttons
-(void)spinWheel:(id)sender // Control for Map View Button to Listing Detail View   
{      
    PickerViewController *pickerView = [self.storyboard instantiateViewControllerWithIdentifier:@"PickerViewController"]; // Listing Detail Page
    pickerView.title = @"Spinwheel";
    [self.navigationController pushViewController:pickerView animated:YES];
    NSLog(@"spinWheel");
    
}
-(void)blabber:(id)sender  // Control for Map View Button to Listing Detail View   
{      
    BlabberViewController *blabberView = [self.storyboard instantiateViewControllerWithIdentifier:@"BlabberViewController"]; // Listing Detail Page
    [self.navigationController pushViewController:blabberView animated:YES];
    //NSLog(@"Button");
    
}
-(void)aroundMe:(id)sender  // Control for Map View Button to Listing Detail View   
{      
    AroundMeMapListViewController *aroundMeView = [self.storyboard instantiateViewControllerWithIdentifier:@"AroundMeMapListViewController"];
    [self.navigationController pushViewController:aroundMeView animated:YES];
    NSLog(@"Button");
    
}
-(void)explore:(id)sender  // Control for Map View Button to Listing Detail View   
{     

    ExploreScrollViewPagingController *exploreView = [self.storyboard instantiateViewControllerWithIdentifier:@"ExploreScrollViewPagingController"];
    [self.navigationController pushViewController:exploreView animated:YES];
    NSLog(@"Button");
    
}
-(void)jaunts:(id)sender  // Control for Map View Button to Listing Detail View   
{      
    TourMapListViewController *tourView = [self.storyboard instantiateViewControllerWithIdentifier:@"TourMapListViewController"]; // Listing Detail Page
    [self.navigationController pushViewController:tourView animated:YES];
    NSLog(@"Button");
    
}
-(void)happenings:(id)sender  // Control for Map View Button to Listing Detail View   
{      
    EventFilterViewController *eventView = [self.storyboard instantiateViewControllerWithIdentifier:@"EventFilterViewController"];
    [self.navigationController pushViewController:eventView animated:YES];
    NSLog(@"Button");
    
}
-(void)loved:(id)sender // Control for Map View Button to Listing Detail View   
{      
    FavoritesViewController *favoritesView = [self.storyboard instantiateViewControllerWithIdentifier:@"FavoritesViewController"]; // Listing Detail Page
    [self.navigationController pushViewController:favoritesView animated:YES];
    NSLog(@"loved");
    
}
-(void)myTrial:(id)sender  // Control for Map View Button to Listing Detail View   
{      
    //ListingViewController *listingView = [self.storyboard instantiateViewControllerWithIdentifier:@"ListingViewController"]; // Listing Detail Page
    //[self.navigationController pushViewController:listingView animated:YES];
    NSLog(@"myTrial");
    
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
