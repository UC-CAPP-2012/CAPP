//
//  NavigationViewController.m
//  Eric Test CTCCA Project
//
//  Created by CTCCA on 30/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NavigationViewController.h"
#import "AppDelegate.h"
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
    //[self customizeApperarance];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
- (void) customizeApperarance
{
    //[[UINavigationBar appearance] setBackgroundColor:[UIColor yellowColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{UITextAttributeTextColor: [UIColor blackColor]}];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{UITextAttributeTextColor: [UIColor blackColor]}forState:UIControlStateNormal];
    //[[UIBarButtonItem appearance] setTitleTextAttributes:@{UITe]
    
    //[[UIBarButtonItem appearance] setBackgroundColor:[UIColor blackColor]];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    //
    //    CGFloat scale = .9;
    //    CGFloat cy = 10.0 - ( 10.0 * scale );
    //
    //    CGRect r = self.view.frame;
    //    r.origin.y -= cy;
    //    r.size.height += cy;
    //    self.view.frame = r;
    
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

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (appDelegate.isLanscapeOk) {
        // for iPhone, you could also return UIInterfaceOrientationMaskAllButUpsideDown
        return UIInterfaceOrientationMaskAll;
    }
    return UIInterfaceOrientationMaskPortrait;
}

@end
