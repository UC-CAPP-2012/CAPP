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
#import "AppDelegate.h"

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
        dispatch_queue_t concurrentQueue =
        dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
        dispatch_async(concurrentQueue, ^(void){
            [RecordSignup recordSignup];
            
            
            NSString * urlString = [NSString stringWithFormat:@"http://imaginecup.ise.canberra.edu.au/PhpScripts/SignUp.php?firstName=%@&lastName=%@&postcode=%@&email=%@&subscribed=%@", FirstName,LastName,PostCode,Email,Subscribe];
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
            [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];

            dispatch_async(dispatch_get_main_queue(), ^{
                [self setupArray];
                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                appDelegate.listingsListString = listingsListString;
                NavigationViewController *eventView = [self.storyboard instantiateViewControllerWithIdentifier:@"NavigationViewController"];
                eventView.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;//UIModalTransitionStyleCoverVertical;
                [self presentModalViewController:eventView animated:YES];
                NSLog(@"Button");

            });
        });

        
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
    [self setupArray];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.listingsListString = listingsListString;
    
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

// *** DATA CONNECTION ***

-(void)setupArray // Connection to DataSource
{
    [listingsListString removeAllObjects];
    
    //The strings to send to the webserver.
    
    NSDate *todaysDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStrToday = [dateFormatter stringFromDate:todaysDate];
    
    //NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"AroundMe.php.xml"];
    //NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    //NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:data];
    
    NSString *urlString = [NSString stringWithFormat:@"http://imaginecup.ise.canberra.edu.au/PhpScripts/AroundMe.php?today=%@",dateStrToday];
    
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    
    
    [xmlParser setDelegate:self];
    
    BOOL worked = [xmlParser parse];
    
    if(worked) {
        NSLog(@"Amount %i", [listingsListString count]);
    }
    else
    {
        NSLog(@"did not work!");
    }
}

// --- XML Delegate Classes ----

-(void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"ListingElements"])
    {
        self.listingsListString = [[NSMutableArray alloc] init];
    }
    else if ([elementName isEqualToString:@"ListingElement"])
    {
        theList = [[ListingString alloc] init];
        theList.ItemID = [attributeDict[@"listingID"] stringValue];
    }
}

-(void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (!currentElementValue)
    {
        currentElementValue = [[NSMutableString alloc] initWithString:string];
    }
    else
    {
        [currentElementValue appendString:string];
    }
}

-(void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"ListingElements"])
    {
        return;
    }
    
    if([elementName isEqualToString:@"ListingElement"])
    {
        [self.listingsListString addObject:theList];
        theList = nil;
    }
    else
    {
        [theList setValue:currentElementValue forKey:elementName];
        NSLog(@"%@",currentElementValue);
        currentElementValue = nil;
    }
}



@end
