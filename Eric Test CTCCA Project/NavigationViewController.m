//
//  NavigationViewController.m
//  Eric Test CTCCA Project
//
//  Created by CTCCA on 30/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NavigationViewController.h"

@interface NavigationViewController ()

@end

@implementation NavigationViewController

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
    [self customizeApperarance];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
- (void) customizeApperarance
{
    //[[UINavigationBar appearance] setBackgroundColor:[UIColor yellowColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{UITextAttributeTextColor: [UIColor blackColor]}];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{UITextAttributeTextColor: [UIColor blackColor]}forState:UIControlStateNormal];
    //[[UIBarButtonItem appearance] setBackgroundColor:[UIColor blackColor]];


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
