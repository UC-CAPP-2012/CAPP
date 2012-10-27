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
@synthesize SubscribeScrollView;
@synthesize SubscribeYesNo;
@synthesize PostCodeTextField;
@synthesize EmailTextField;
@synthesize NickNameTextField;
@synthesize LastNameTextField;
@synthesize listingsListString;
-(IBAction)DismissKeyboard:(id)sender
{
    [sender resignFirstResponder];
}


-(IBAction)Subscribe:(id)sender
{
    
    //NSString * secret = @"some_secret";
    
    errorMsg.text=@"";
    NSString * FirstName = [NickNameTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString * LastName = [LastNameTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString * Email = [EmailTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString * PostCode = [PostCodeTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *Subscribe = @"";
    
    if([SubscribeYesNo isOn])
    {
        Subscribe = @"1";
    }
    else
    {
        Subscribe = @"0";
    }
    
    if([self NSStringIsValidEmail:Email] && ![FirstName isEqualToString:@""] && ![LastName isEqualToString:@""] && ![PostCode isEqualToString:@""] && ![Email isEqualToString:@""] && [PostCode length]==4){
        loadView.hidden=FALSE;
    [RecordSignup recordSignup];
    
    
    NSString * urlString = [NSString stringWithFormat:@"http://imaginecup.ise.canberra.edu.au/PhpScripts/SignUp.php?firstName=%@&lastName=%@&postcode=%@&email=%@&subscribed=%@", FirstName,LastName,PostCode,Email,Subscribe];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
        [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NavigationViewController *eventView = [self.storyboard instantiateViewControllerWithIdentifier:@"NavigationViewController"];
    eventView.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;//UIModalTransitionStyleCoverVertical;
    [self presentModalViewController:eventView animated:YES];
    NSLog(@"Button");
    }else{
        if(![self NSStringIsValidEmail:Email]){
            errorMsg.text=@"Your email is invalid. Please try again.";
            errorMsg.hidden=FALSE;
        }
        if([FirstName isEqualToString:@""]){
            errorMsg.text=@"First name is required.";
            errorMsg.hidden=FALSE;
        }
        if([LastName isEqualToString:@""]){
            errorMsg.text=@"Last name is required.";
            errorMsg.hidden=FALSE;
        }
        if([Email isEqualToString:@""]){
            errorMsg.text=@"Email is required.";
            errorMsg.hidden=FALSE;
        }
        if([PostCode isEqualToString:@""]){
            errorMsg.text=@"Postcode is required.";
            errorMsg.hidden=FALSE;
        }
        if([PostCode length]!=4){
            errorMsg.text=@"Postcode is invalid. Please try again.";
            errorMsg.hidden=FALSE;
        }
    }
    
}

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
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
    
    PostCodeTextField.delegate = (id)self;
    
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated
{
    loadView.hidden=TRUE;
    if ([SignUpCheck checkForSugnup]) {
        [self skipScreen];
    }
    else {
        spashScreen.hidden = TRUE;
    }
    
}




- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([textField.text length] > 4-1) {
        textField.text = [textField.text substringToIndex:4];
        return NO;
    }
    return YES;
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
