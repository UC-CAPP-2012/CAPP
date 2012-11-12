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
#import "Listing.h"
#import "MainTypeClass.h"

bool errorMsgShown;
@implementation Subscribe
@synthesize SubscribeScrollView;
@synthesize SubscribeYesNo;
@synthesize PostCodeTextField;
@synthesize EmailTextField;
@synthesize NickNameTextField;
@synthesize LastNameTextField;
@synthesize listingsListString, listingsList, typeDataSource;
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
    
    NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    
    if([self NSStringIsValidEmail:Email] && ![FirstName isEqualToString:@""] && ![LastName isEqualToString:@""] && ![PostCode isEqualToString:@""] && ![Email isEqualToString:@""] && [PostCode length]==4 && [PostCode rangeOfCharacterFromSet:notDigits].location == NSNotFound){
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
                appDelegate.listingsList = listingsList;
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
        if([PostCode rangeOfCharacterFromSet:notDigits].location != NSNotFound){
            errorMsg.text=@"Postcode is invalid. Please try again.";
            errorMsg.hidden=FALSE;
        }
        
        if([FirstName isEqualToString:@""] && [LastName isEqualToString:@""] && [Email isEqualToString:@""] && [PostCode isEqualToString:@""]){
            errorMsg.text=@"All fields are required. Please try again.";
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
    errorMsgShown = NO;
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    loadView.hidden=TRUE;
    if ([SignUpCheck checkForSugnup]) {
        appDelegate.showHomeOverlay = NO;
        typeDataSource = [[NSMutableArray alloc] init];
        
        
        
        MainTypeClass *type = [[MainTypeClass alloc] init];
        type.typeID = @"0";
        type.imageID = [UIImage imageNamed:@"loading1.png"];
        [typeDataSource addObject:type];
        
        
        type = [[MainTypeClass alloc] init];
        type.typeID = @"1";
        type.imageID = [UIImage imageNamed:@"loading2.png"];
        [typeDataSource addObject:type];
        
        type = [[MainTypeClass alloc] init];
        type.typeID = @"2";
        type.imageID = [UIImage imageNamed:@"loading3.png"];
        [typeDataSource addObject:type];
        
        type = [[MainTypeClass alloc] init];
        type.typeID = @"3";
        type.imageID = [UIImage imageNamed:@"loading4.png"];
        [typeDataSource addObject:type];
        
        type = [[MainTypeClass alloc] init];
        type.typeID = @"4";
        type.imageID = [UIImage imageNamed:@"loading5.png"];
        [typeDataSource addObject:type];
        
        scrollView.clipsToBounds = NO;
        scrollView.pagingEnabled = YES;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        
        pageControl.numberOfPages = [typeDataSource count];
        
        pageControlBeingUsed = NO;
        [self setUpFrame:pageControl.numberOfPages];
        
        [self skipScreen];
    }
    else {
        splash.hidden = TRUE;
        appDelegate.showHomeOverlay = YES;
    }
    
}

- (void)setUpFrame: (NSInteger) pages {
    for (int i = 0; i < pageControl.numberOfPages; i++)
    {
        CGRect frame;
        frame.origin.x = scrollView.frame.size.width *i;
        frame.origin.y = 0;
        CGSize size = scrollView.frame.size;
        frame.size = size;
        
        
        UIView *subview = [[UIView alloc] initWithFrame:frame];
        [subview setBackgroundColor:[UIColor whiteColor]];
        
        

        UIImageView *imageView = [[UIImageView alloc]init];
        MainTypeClass *currType = typeDataSource[i];
       // CGRect imageRect = CGRectMake(0.0, 0.0, 20.0f, 80.0f);
        
        imageView.image = currType.imageID;
       // [imageView.image drawInRect:imageRect];
        
        imageView.contentMode = UIViewContentModeCenter;
        
        imageView.layer.shadowColor = [UIColor blackColor].CGColor;
        imageView.layer.shadowOffset = CGSizeMake(0,1);
        imageView.layer.shadowOpacity = 2;
        imageView.layer.shadowRadius = 10.0;
        imageView.clipsToBounds = NO;
        
        
        
        imageView.frame =   CGRectMake(0.0f, 0.0f, 321.0f, 351.0f);
        [subview addSubview:imageView];
        
        [self->scrollView addSubview:subview];
        
    }
    
    self->scrollView.contentSize = CGSizeMake(self->scrollView.frame.size.width * pageControl.numberOfPages, self->scrollView.frame.size.height);
    CGSize scrollableSize = CGSizeMake(scrollView.frame.size.width *  typeDataSource.count, 351); // 351 is the height of the image.
    [self->scrollView setContentSize:scrollableSize];
    //self->pageControl.currentPage=0;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //    if ([textField.text length] > 4-1) {
    //        textField.text = [textField.text substringToIndex:4];
    //        return NO;
    //    }
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

-(void)skipScreen
{
    dispatch_queue_t concurrentQueue =
    dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(concurrentQueue, ^(void){
        
        [self setupArray];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            appDelegate.listingsList = listingsList;
            
            
            NavigationViewController *eventView = [self.storyboard instantiateViewControllerWithIdentifier:@"NavigationViewController"];
            eventView.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;//UIModalTransitionStyleCoverVertical; UIModalTransitionStyleFlipHorizontal;//
            
            [self presentModalViewController:eventView animated:YES];
            NSLog(@"Button");
        });
    });
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                        message:@"Something went wrong. Please make sure you are connected to the internet."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
        
        if(errorMsgShown==NO){
            [alert show];
            errorMsgShown = YES;
        }
    }
    
    listingsList = [[NSMutableArray alloc] init];
    
    for (ListingString *listingStringElement in listingsListString) {
        
        Listing *currListing = [[Listing alloc] init];
        
        // ListingID , Title , SubTitle
        
        currListing.listingID = [listingStringElement.ItemID stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        currListing.listingID = [currListing.listingID stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        currListing.title = [listingStringElement.ItemName stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        currListing.title = [currListing.title stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        
        // Placemarker
        
        CLLocationCoordinate2D tempPlacemarker;
        
        NSString *tempLat = [listingStringElement.Latitude stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        tempLat = [tempLat stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        double latDouble =[tempLat doubleValue];
        tempPlacemarker.latitude = latDouble;
        
        NSString *tempLong = [listingStringElement.Longitude stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        tempLong = [tempLong stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        double lonDouble =[tempLong doubleValue];
        tempPlacemarker.longitude = lonDouble;
        
        currListing.coordinate = tempPlacemarker;
        
        //Sort and Filter Types
        
        currListing.listingType = [listingStringElement.ListingType stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        currListing.listingType = [currListing.listingType stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        currListing.areaID = [listingStringElement.AreaID stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        currListing.areaID = [currListing.areaID stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        currListing.costType =[listingStringElement.Cost stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        currListing.costType =[currListing.costType stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        currListing.subType = [listingStringElement.SubtypeName stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        currListing.subType = [currListing.subType stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        
        // Address
        
        currListing.address = [listingStringElement.Address stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        currListing.address = [currListing.address stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        currListing.majorRegionName = [listingStringElement.MajorRegionName stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        currListing.majorRegionName = [currListing.majorRegionName stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        currListing.phone = [listingStringElement.Phone stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        currListing.phone = [currListing.phone stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        currListing.email = [listingStringElement.Email stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        currListing.email = [currListing.email stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        currListing.suburb = [listingStringElement.Suburb stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        currListing.suburb = [currListing.suburb stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        currListing.openingHours = [listingStringElement.OpeningHours stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        currListing.openingHours = [currListing.openingHours stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        
        // Listing View details
        
        currListing.description = [listingStringElement.Details stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        currListing.description = [currListing.description stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        currListing.imageFilenames = [listingStringElement.ImageURL componentsSeparatedByString:@","];
        currListing.videoURL = [NSURL URLWithString:[[[listingStringElement.VideoURL stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@"\t" withString:@""] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        currListing.websiteURL = [NSURL URLWithString:[[[[listingStringElement.Website stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@"\t" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        currListing.audioURL = [NSURL URLWithString:[[[listingStringElement.AudioURL stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@"\t" withString:@""] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        // Start Date
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd/MM/yyyy"];
        // Start Date
        listingStringElement.StartDate = [listingStringElement.StartDate stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        listingStringElement.StartDate = [listingStringElement.StartDate stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        NSDate *startDate = [dateFormatter dateFromString:listingStringElement.StartDate];
        currListing.startDate = startDate;
        
        // End Date
        listingStringElement.EndDate = [listingStringElement.EndDate stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        listingStringElement.EndDate = [listingStringElement.EndDate stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        NSDate *endDate = [dateFormatter dateFromString:listingStringElement.EndDate];
        currListing.endDate = endDate;
        // ** CHECKS ------------------------
        NSLog(@"%@",listingStringElement.ItemName);
        NSLog(@"%@",listingStringElement.Latitude);
        NSLog(@"%@",listingStringElement.Longitude);
        NSLog(@"%f",latDouble);
        NSLog(@"%f",lonDouble);
        NSLog(@"%@",listingStringElement.ItemID);
        NSLog(@"%@",listingStringElement.ListingType);
        NSLog(@"%@",listingStringElement.AreaID);
        NSLog(@"%@",listingStringElement.Cost);
        NSLog(@"%@",listingStringElement.SubtypeName);
        NSLog(@"%@",listingStringElement.Suburb);    //suburb
        NSLog(@"%@",listingStringElement.Postcode);  //postcode
        NSLog(@"%@",listingStringElement.StateID);   //stateID
        NSLog(@"%@",currListing.address);
        NSLog(@"%@",listingStringElement.Details);
        NSLog(@"%@",listingStringElement.ImageURL);
        NSLog(@"%@",listingStringElement.VideoURL);
        NSLog(@"%@",listingStringElement.StartDate);
        NSLog(@"%@",listingStringElement.EndDate);
        NSLog(@"%@",listingStringElement.Website);
        
        // -----------------------------------------
        
        [listingsList addObject:currListing];
        
    }
    
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if(!pageControlBeingUsed)
    {
        CGFloat pageWidth = self->scrollView.frame.size.width;
        CGFloat offset = self->scrollView.contentOffset.x;
        int page = floor((offset - pageWidth /2) / pageWidth) + 1;
        self->pageControl.currentPage = page;
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



- (IBAction)changePage:(id)sender {
    CGRect frame;
    frame.origin.x = self->scrollView.frame.size.width * self->pageControl.currentPage;
    frame.origin.y=0;
    frame.size = self->scrollView.frame.size;
    [self->scrollView scrollRectToVisible:frame animated:YES];
    //pageControlBeingUsed = YES;
}
@end
