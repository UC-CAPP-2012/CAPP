//
//  Subscribe.m
//  Eric Test CTCCA Project
//
//  Created by CTCCA on 30/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Subscribe.h"
#import "SignUpCheck.h"
#import "RecordSignup.h"
#import "NavigationViewController.h"


@implementation Subscribe
@synthesize SubscribeActivityIndicator;
@synthesize SubscribeScrollView;
@synthesize SubscribeYesNo;
@synthesize PostCodeTextField;
@synthesize EmailTextField;
@synthesize NickNameTextField;

-(IBAction)DismissKeyboard:(id)sender
{
    [sender resignFirstResponder];
}

-(IBAction)Subscribe:(id)sender
{
    
    //NSString * secret = @"some_secret";
    
    NSString * FirstName = [NickNameTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString * Email = [EmailTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString * PostCode = [PostCodeTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *Subscribe = @"";
    
    if([SubscribeYesNo isOn])
    {
        Subscribe = @"Yes";
    }
    else
    {
        Subscribe = @"No";
    }
    
    [RecordSignup recordSignup];
    
    
    NSString * urlString = [NSString stringWithFormat:@"http://itp2012.com/CMS/IPHONE/subscribe.php?Name=%@&Postcode=%@&Email=%@&Subscribe=%@", FirstName,PostCode,Email,Subscribe];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
        [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NavigationViewController *eventView = [self.storyboard instantiateViewControllerWithIdentifier:@"NavigationViewController"];
    eventView.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;//UIModalTransitionStyleCoverVertical;
    [self presentModalViewController:eventView animated:YES];
    NSLog(@"Button");
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView
 {
 }
 */

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{

    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated
{
    if ([SignUpCheck checkForSugnup]) {
        [self skipScreen];
    }
    else {
        spashScreen.hidden = TRUE;
    }
    
}

-(void)skipScreen
{
    NavigationViewController *eventView = [self.storyboard instantiateViewControllerWithIdentifier:@"NavigationViewController"];
    eventView.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;//UIModalTransitionStyleCoverVertical; UIModalTransitionStyleFlipHorizontal;//
    
    [self presentModalViewController:eventView animated:YES];
    NSLog(@"Button"); 
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self setEmailTextField:nil];
    [self setPostCodeTextField:nil];
    [self setSubscribeYesNo:nil];
    [self setSubscribeScrollView:nil];
    [self setSubscribeActivityIndicator:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
