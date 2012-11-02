//
//  ListingViewController.m
//  Eric Test CTCCA Project
//
//  Created by CTCCA on 16/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

//From the Listing ID - Contact the Database then populate outlets.
//Will require picture control.
//And 3 Text Fields.
// + Picture/s
// + Geo Co-ordinate for map view.

#import "ListingViewController.h"
#import <EventKitUI/EventKitUI.h>
#import <EventKit/EventKit.h>
#import "SaveToFavorites.h"
#import "Listing.h"
#import "SearchArray.h"

@interface ListingViewController ()
@end

@implementation ListingViewController
@synthesize listingID,listingTitle, listingsList, listingsListString;
@synthesize currentListing;
@synthesize favourite;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    
    
    [self segmentButton:self];
}

-(void)viewWillAppear:(BOOL)animated
{
    
    
    
}

- (void)viewDidLoad
{
    //Set a activity indicator in here. untill viewDidAppear procs.
    DetailView.hidden = TRUE;
    DetailView.backgroundColor = [UIColor clearColor];
    switchTableView.hidden=false;
    switchMapView.hidden=true;
    [super setTitle:currentListing.title];
    
    Cost = [[NSMutableArray alloc] init];
    [Cost addObject:@"Free"];
    [Cost addObject:@"$"];
    [Cost addObject:@"$$"];
    [Cost addObject:@"$$$"];
    [Cost addObject:@"$$$$"];
    [Cost addObject:@"$$$$$"];
    
    NSString *cutString = [currentListing.listingID stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([SearchArray searchArray:cutString]) {
        favButton.image = [UIImage imageNamed:@"thumbs_down@2x.png"];
        favourite = true;
    }else{
        favourite = false;
    }
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)setupMap
{
    
    //Map Settings
    [mapView setMapType:MKMapTypeStandard];
    [mapView setZoomEnabled:YES];
    [mapView setScrollEnabled:YES];
    [mapView setDelegate:self];
    
    //Center Map on users location;
    //CLLocationCoordinate2D zoomLocation;
    MKCoordinateRegion region = {{0.0, 0.0}, {0.0,0.0}};
    //region.center.latitude = -35.281150; //mapView.userLocation.location.coordinate.latitude;
    //region.center.longitude = 149.128668; //mapView.userLocation.location.coordinate.longitude;
    region.center = currentListing.coordinate;
    region.span.latitudeDelta = 0.05f; // Zoom Settings
    region.span.longitudeDelta = 0.05f; // Zoom Settings
    [mapView setRegion:region animated:YES];
    
}

-(void) setupArray
{
    NSLog(@"%@",listingID);
    //Select * from ListingElements where listingID = listing ID
    [mapView removeAnnotations:mapView.annotations];   
    
    currentListing = self.currentListing;
    [mapView addAnnotation:self.currentListing];
    pageControl.numberOfPages = [currentListing.imageFilenames count];    
}

-(void) setupPictures
{
	scrollView.clipsToBounds = NO;
	scrollView.pagingEnabled = YES;
	scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
	
	CGFloat contentOffset = 0.0f;
    
	for (int i = 0; i < [currentListing.imageFilenames count]; i++) {
		CGRect imageViewFrame = CGRectMake(contentOffset, 0.0f, scrollView.frame.size.width, scrollView.frame.size.height);
        
        NSString *imageString = [(currentListing.imageFilenames)[i] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
		UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageViewFrame];
        
        dispatch_queue_t concurrentQueue =
        dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
        dispatch_async(concurrentQueue, ^(void){
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageString]]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                imageView.image = image;
                imageView.contentMode = UIViewContentModeScaleToFill;
                loadView.hidden = YES;
            });
        });
		//imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        
		[scrollView addSubview:imageView];
        
		contentOffset += imageViewFrame.size.width;
		scrollView.contentSize = CGSizeMake(contentOffset, scrollView.frame.size.height);
	}
    //[scrollView reloadInputViews];
}

-(IBAction)segmentButton:(id)sender{
    
    if (segmentController.selectedSegmentIndex == 0) {
        NSString *openingHrs = [[NSString alloc] init];
        if(![currentListing.openingHours isEqualToString:@""] && ![currentListing.openingHours isEqualToString:@" "]){
            openingHrs=[NSString stringWithFormat:@"<p><strong style='color: #1b4583;'>Opening Hours:</strong> %@</p>",currentListing.openingHours];
        }
        
        NSString *phoneStr = [[NSString alloc] init];
        if(![currentListing.phone isEqualToString:@""] && ![currentListing.phone isEqualToString:@" "]){
            phoneStr=[NSString stringWithFormat:@"<p><strong style='color: #1b4583;'>Phone:</strong> %@</p>",currentListing.phone];
        }
        
        NSString *websiteStr = [[NSString alloc] init];
        NSString *web = [currentListing.websiteURL absoluteString];
        
        NSLog(@"%@",web);
        if(web!=NULL){
            websiteStr=[NSString stringWithFormat:@"<p><strong style='color: #1b4583;'>Website:</strong> %@</p>",[currentListing.websiteURL absoluteString]];
        }
        
        NSString *emailStr = [[NSString alloc] init];
        if(![currentListing.email isEqualToString:@""] && ![currentListing.email isEqualToString:@" "]){
            emailStr=[NSString stringWithFormat:@"<p><strong style='color: #1b4583;'>Email:</strong> %@</p>",currentListing.email];
        }
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
        [dateFormatter setDateFormat:@"dd/MM/yyyy"];
        
        NSString *startStr = [dateFormatter stringFromDate:currentListing.startDate];
        
        NSString *startDateStr = [[NSString alloc] init];
        if(![startStr isEqualToString:@""] && ![startStr isEqualToString:@" "] && startStr!=NULL){
            startDateStr=[NSString stringWithFormat:@"<p><strong style='color: #1b4583;'>Start Date:</strong> %@</p>",startStr];
        }
        
        NSString *endStr = [dateFormatter stringFromDate:currentListing.endDate];
        
        NSString *endDateStr = [[NSString alloc] init];
        if(![endStr isEqualToString:@""] && ![endStr isEqualToString:@" "]&& endStr!=NULL){
            endDateStr=[NSString stringWithFormat:@"<p><strong style='color: #1b4583;'>End Date:</strong> %@</p>",endStr];
        }
        
        [infoBox loadHTMLString:[NSString stringWithFormat:@"<h3 style='color: #1b4583;'>%@</h3><strong style='color: #1b4583;'>Type:</strong> %@<p><strong style='color: #1b4583;'>Cost:</strong> %@</p>%@  %@ %@<p><strong style='color: #1b4583;'>Address:</strong> %@</p> %@ %@ %@",currentListing.title,currentListing.subType,[Cost objectAtIndex:[currentListing.costType intValue]], startDateStr,endDateStr,openingHrs,currentListing.address, phoneStr, websiteStr,emailStr] baseURL:nil];
        infoBox.scrollView.showsHorizontalScrollIndicator=FALSE;
        
 
    }
    if (segmentController.selectedSegmentIndex == 1) {
        [infoBox loadHTMLString:[NSString stringWithFormat:@"%@", currentListing.description] baseURL:nil];
    }
    pageControl.currentPage=0;
    [self setupArray];
    [self setupPictures];
}

// *** MAP METHODS ****

-(MKAnnotationView *) mapView:(MKMapView *)mapViewListing viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapViewListing dequeueReusableAnnotationViewWithIdentifier:@"current"];// get a dequeued view for the annotation like a tableview
    
    if (annotationView == nil)
    {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"current"];
    }
    annotationView.annotation = annotation;
    annotationView.canShowCallout = YES; // show the grey popup with location etc
   // UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    ///[rightButton addTarget:self action:@selector(showDetails:) forControlEvents:UIControlEventTouchUpInside];
    //annotationView.rightCalloutAccessoryView = rightButton;
    
    annotationView.image = [UIImage imageNamed:@"map_marker.png"];
    
    annotationView.draggable = NO;
    //annotationView.highlighted = YES;
    //annotationView.animatesDrop = TRUE;
    //annotationView.canShowCallout = NO;
    
    return annotationView;
}

-(void)mapView:(MKMapView *)mapViewSelect didSelectAnnotationView:(MKPinAnnotationView *)view
{
    if (view.annotation == mapViewSelect.userLocation) {
        return;
    }
    
    NSLog(@"didSelectAnnotationView");
    DetailView.hidden = FALSE;
    view.pinColor = MKPinAnnotationColorGreen;
    view.image = [UIImage imageNamed:@"map_marker_green.png"];
    if ([view.annotation isKindOfClass:[Listing class]] )
    {
        //Title
        TitleLabel.text = ((Listing *) view.annotation).subType;
        
        //Address
        AddressLabel.text = ((Listing *) view.annotation).address;
        
        //Start Date
//        NSDateFormatter *startDateFormat = [[NSDateFormatter alloc] init];
//        [startDateFormat setDateFormat:@"EEEE','MMMM d'.' KK:mma"];
//        NSString *startDateString = [startDateFormat stringFromDate:((Listing *) view.annotation).startDate];
        StartDateLabel.text = view.annotation.title;
        
        //Detail Image    
        NSString *imageString = [(((Listing *) view.annotation).imageFilenames)[0] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        DetailImage.image =[UIImage imageNamed:@"Placeholder.png"];
        dispatch_queue_t concurrentQueue =
        dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
        dispatch_async(concurrentQueue, ^(void){
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageString]]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                DetailImage.image = image;
            });
        });

        
    }
    
}


-(void)mapView:(MKMapView *)mapViewDeSelect didDeselectAnnotationView:(MKPinAnnotationView *)view
{
    if (view.annotation == mapViewDeSelect.userLocation) {
        return;
    }
    NSLog(@"didDeselectAnnotationView");
    DetailView.hidden = TRUE;
    view.pinColor = MKPinAnnotationColorRed;
    view.image = [UIImage imageNamed:@"map_marker.png"];
}

// ** Picture Scroll Methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)sender {
    CGFloat pageWidth = self->scrollView.frame.size.width;
    int page = floor((self->scrollView.contentOffset.x - pageWidth /2) / pageWidth) + 1;
    self->pageControl.currentPage = page;
}

-(IBAction)addToCalendar:(id)sender{
    //Event Store Object
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    EKEvent *event = [EKEvent eventWithEventStore:eventStore];
    EKEventEditViewController *controller = [[EKEventEditViewController alloc] init];
    
    event.title=currentListing.title;
    event.location=currentListing.address;
    if (currentListing.listingType == @"Event") {
        event.startDate = currentListing.startDate;
        event.endDate = currentListing.endDate;
    }
    controller.event = event;
    controller.eventStore = eventStore;
    controller.editViewDelegate = self;
    
    [self presentModalViewController: controller animated:YES];
    
}

- (void)eventEditViewController:(EKEventEditViewController *)controller didCompleteWithAction:(EKEventEditViewAction)action
{
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction)viewWebsite:(id)sender
{
    ListingWebViewController *webView= [self.storyboard instantiateViewControllerWithIdentifier:@"ListingWebView"]; // Listing Detail Page
    webView.Website = currentListing.videoURL;
    [self.navigationController pushViewController:webView animated:YES];
    NSLog(@"Button");
}

-(IBAction)shareWebsite:(id)sender
{
    NSString *web = [currentListing.websiteURL absoluteString];
    
    NSLog(@"%@",web);
    if(web!=NULL && ![web isEqualToString:@""]){

    ListingWebViewController *webView= [self.storyboard instantiateViewControllerWithIdentifier:@"ListingWebView"]; // Listing Detail Page
    NSString *facebookShare = @"http://www.facebook.com/share.php?u=";
    NSString *website = [currentListing.websiteURL absoluteString];
    NSString *shareWebsite = [NSString stringWithFormat:@"%@%@",facebookShare,website];
    webView.Website = [NSURL URLWithString:shareWebsite];
    
    [self.navigationController pushViewController:webView animated:YES];
    NSLog(@"Button");
    }else{
        UIAlertView *alertBox = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                           message:@"This item does not have any website to share."
                                                          delegate:nil
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles: nil];
        [alertBox show];
        }
}

-(IBAction)addToFavourties:(id)sender
{
    if(favourite==NO){
        NSString *cutString = [currentListing.listingID stringByReplacingOccurrencesOfString:@" " withString:@""];
        [SaveToFavorites saveToFavorites:cutString];
    
        favButton.image = [UIImage imageNamed:@"thumbs_down@2x.png"];
        NSLog(@"%@",cutString);
        NSLog(@"Button Favourite");
        favourite = true;
    }else{
        [self unfavourite];
    }
}

-(void)unfavourite
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    //2) Create the full file path by appending the desired file name
    NSString *yourArrayFileName = [documentsDirectory stringByAppendingPathComponent:@"example.dat"];
    favData = [[NSMutableArray alloc] initWithContentsOfFile: yourArrayFileName];
    for(int i = 0; i<[favData count]; i++){
        if([favData[i] isEqualToString:[currentListing.listingID stringByReplacingOccurrencesOfString:@" " withString:@""]]){
            [favData removeObjectAtIndex:i];
        }
    }
    favButton.image = [UIImage imageNamed:@"thumbs_up@2x.png"];
    [favData writeToFile:yourArrayFileName atomically:YES];
    favourite = false;
}

- (IBAction)home:(id)sender {
//    BlabberViewController *blabberView = [self.storyboard instantiateViewControllerWithIdentifier:@"BlabberViewController"]; // Listing Detail Page
//    [self.navigationController pushViewController:blabberView animated:YES];
    NavigationViewController *eventView = [self.storyboard instantiateViewControllerWithIdentifier:@"NavigationViewController"];
    eventView.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;//UIModalTransitionStyleCoverVertical; UIModalTransitionStyleFlipHorizontal;//
    
    [self presentModalViewController:eventView animated:YES];
}

- (IBAction)email:(id)sender {
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        
        mailer.mailComposeDelegate = self;
        
        [mailer setSubject:currentListing.title];
        
       // NSArray *toRecipients = @[@"fisrtMail@example.com", @"secondMail@example.com"];
        //[mailer setToRecipients:toRecipients];
        
        UIImage *myImage = [UIImage imageNamed:@"complete-logo.png"];
        NSData *imageData = UIImagePNGRepresentation(myImage);
        [mailer addAttachmentData:imageData mimeType:@"image/png" fileName:@"CApp"];
        
        NSString *emailBody = [NSString stringWithFormat: @"Have you been here before?\n\n%@\n\n%@",currentListing.title,currentListing.address];
        [mailer setMessageBody:emailBody isHTML:NO];
        
        // only for iPad
        // mailer.modalPresentationStyle = UIModalPresentationPageSheet;
        
        [self presentModalViewController:mailer animated:YES];
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                        message:@"Your device doesn't support the composer sheet"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }

}

#pragma mark - MFMailComposeController delegate


- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	switch (result)
	{
		case MFMailComposeResultCancelled:
			NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued");
			break;
		case MFMailComposeResultSaved:
			NSLog(@"Mail saved: you saved the email message in the Drafts folder");
			break;
		case MFMailComposeResultSent:
			NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send the next time the user connects to email");
			break;
		case MFMailComposeResultFailed:
			NSLog(@"Mail failed: the email message was nog saved or queued, possibly due to an error");
			break;
		default:
			NSLog(@"Mail not sent");
			break;
	}
    
	[self dismissModalViewControllerAnimated:YES];
}


-(IBAction)changePage{
    CGRect frame;
    frame.origin.x = self->scrollView.frame.size.width *self->pageControl.currentPage;
    frame.origin.y = 0;
    frame.size = self->scrollView.frame.size;
    [self->scrollView scrollRectToVisible:frame animated:YES];
    
}

-(IBAction)SwitchView {
    
    // Also I haven't primed the array, yet it still works?
    
    //Button to switch between Map and Table view
    NSArray *viewArray = listingView.subviews; //Gathers an arrary of 'view' in the 'aroundMe' stack in order.
    if (viewArray[1] == mapWindow) // change to table view
    {
        // Main Window Animation
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:listingView cache:YES];
        [listingView bringSubviewToFront:tableView];
        [UIView commitAnimations];
        switchTableView.hidden=false;
        switchMapView.hidden=true;
        // Navigation Bar Animation
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:navView cache:YES];
        [navView bringSubviewToFront:switchTableView];
        [UIView commitAnimations];
    } 
    else if (viewArray[1] == tableView) // change to mapview
    {
        [self setupMap];
        // Main Window Animation
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:listingView cache:YES];        
        [listingView bringSubviewToFront:mapWindow];
        [UIView commitAnimations];
        switchTableView.hidden=true;
        switchMapView.hidden=false;
        // Navigation Bar Animation
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:navView cache:YES];
        [navView bringSubviewToFront:switchMapView];
        [UIView commitAnimations];
        
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
