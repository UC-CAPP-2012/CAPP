//
//  FavoritesViewController.m
//  Eric Test CTCCA Project
//
//  Created by CTCCA on 30/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FavoritesViewController.h"
#import "GenerateFavoritesString.h"
#import <EventKitUI/EventKitUI.h>
#import <EventKit/EventKit.h>
#import "Listing.h"
#import "MainTypeClass.h"
#import "SearchArray.h"
#import "SaveToFavorites.h"
@interface FavoritesViewController ()

@end

@implementation FavoritesViewController
@synthesize currSel,sortSel;
@synthesize listing,listingsDataSource,listingTable, listingsList,listingsListString;
@synthesize sortHeaders1,sortHeaders2,sortHeaders3,sortHeaders4;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    //2) Create the full file path by appending the desired file name
    NSString *yourArrayFileName = [documentsDirectory stringByAppendingPathComponent:@"example.dat"];

    //Load the array
    favData = [[NSMutableArray alloc] initWithContentsOfFile: yourArrayFileName];
    if([favData count]>0)
    {
        if([listingsList count]==0){
            [self setupArray];
        }
    }
    [tableView reloadData];
    loadView.hidden=TRUE;
}

- (void)viewDidLoad
{
    [super setTitle:@"Loved"];
    NSMutableString *stringName = [GenerateFavoritesString createFavoriteString];
    NSLog(@"%@",stringName);
    switchTableView.hidden=false;
    switchMapView.hidden=true;
    detailView.hidden = TRUE;
    detailView.backgroundColor = [UIColor clearColor];
    
    //Creating a file path under iPhone OS:
    //1) Search for the app's documents directory (copy+paste from Documentation)
        
    
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

//Reload With Tab Bar
//--------------------------------------------------------------------------------------------------//
//Reloads the table view when navigated to with the tab bar controller.
- (void)viewWillAppear:(BOOL)animated {

}
//---------------------------------------------------------------------------------------------------//

//Delete Function
//--------------------------------------------------------------------------------------------------//
//Telling the table view that the rows have a delete editing style
//- (UITableViewCellEditingStyle)tableView:(UITableView*)tableView 
//           editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath {
//    return UITableViewCellEditingStyleDelete;
//}
////Displays the delete button and deletes the row and the entry in the favorites array
//- (void)tableView:(UITableView*)tableViewEdit commitEditingStyle:(UITableViewCellEditingStyle)style 
//forRowAtIndexPath:(NSIndexPath*)indexPath {
//    
//    // delete your data for this row from here
//    
//    //Creating a file path under iPhone OS:
//    //1) Search for the app's documents directory (copy+paste from Documentation)
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = paths[0];
//    //2) Create the full file path by appending the desired file name
//    NSString *yourArrayFileName = [documentsDirectory stringByAppendingPathComponent:@"example.dat"];
//    favData = [[NSMutableArray alloc] initWithContentsOfFile: yourArrayFileName];
//    [favData removeObjectAtIndex:indexPath.row];
//    [listingsList removeObjectAtIndex:indexPath.row];
//    //[listingTable removeObjectAtIndex:indexPath.row];
//    [favData writeToFile:yourArrayFileName atomically:YES];
//    [tableViewEdit reloadData];
//}
//--------------------------------------------------------------------------------------------------//



// Return number of sections in table (always 1 for this demo!)
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [listingTable count];
}

// Return the amount of items in our table (the total items in our array above)
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *dictionary = listingTable[section];
    NSArray *array = dictionary[@"Favourites"];
    return [array count];
}

// Return a cell for the table
- (UITableViewCell *)tableView:(UITableView *)tableViewSection cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // A cell identifier which matches our identifier in IB
    static NSString *CellIdentifier = @"CellFavorites";
    
    // Create or reuse a cell
    UITableViewCell *cell = [tableViewSection dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *dictionary = listingTable[indexPath.section];
    NSArray *array = dictionary[@"Favourites"];
    Listing *currListing = array[indexPath.row];
    
    // Get the cell label using its tag and set it
    //UILabel *cellLabel;
 
    //[cellLabel setText:[favData objectAtIndex:indexPath.row]];
    
    
    NSString *cellValue = currListing.title;
    UIImage* image = [UIImage imageNamed:@"star-hollow@2x.png"];
    cell.imageView.image = image;
    //ContentView
    CGRect Label1Frame = CGRectMake(70, 10, 240, 25);
    CGRect Label2Frame = CGRectMake(70, 33, 240, 25);
    //CGRect Label1Frame = CGRectMake(5, 10, 240, 25);
    //CGRect Label2Frame = CGRectMake(5, 33, 240, 25);
    //CGRect Button1Frame = CGRectMake(250, 20, 20, 20);
    
    UILabel *lblTemp;
    //UIButton *btnTemp;
    
    //UIImage* imageTBA = [UIImage imageNamed:@"83-calendar"];
    //UIImage* imageCal = [UIImage imageNamed:@"TabHeartIt.png"];
    
    lblTemp = [[UILabel alloc] initWithFrame:Label1Frame];
    lblTemp.text = cellValue;
    [cell.contentView addSubview:lblTemp];
    
    lblTemp = [[UILabel alloc] initWithFrame:Label2Frame];
    lblTemp.text = currListing.suburb;
    [cell.contentView addSubview:lblTemp];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(void) setupArray // Connection to DataSource
{
    [NSThread detachNewThreadSelector:@selector(threadStartAnimating:) toTarget:self withObject:nil];
    [mapView removeAnnotations:mapView.annotations];
    
    NSMutableString *ids = [GenerateFavoritesString createFavoriteString];
    NSLog(@"%@",ids);
//    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Favourites.xml"];
//    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
//    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:data];
    
    NSString * urlString = [NSString stringWithFormat:@"http://imaginecup.ise.canberra.edu.au/PhpScripts/Favs.php?ids=%@",ids];
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

        NSLog(@"did not work!");
    }
    
    //This needs to be set via the filter and sorter.
    listingsList = [[NSMutableArray alloc] init]; //Complete List of Listings
    listingTable = [[NSMutableArray alloc] init]; //List Displayed in the Table
    sortHeaders1 = [[NSMutableArray alloc] init]; //No Headers
    sortHeaders2 = [[NSMutableArray alloc] init]; //Distinct Type Headers
    sortHeaders3 = [[NSMutableArray alloc] init]; //Distinct Rating Headers
    sortHeaders4 = [[NSMutableArray alloc] init]; //Distinct Price Headers
    [listingTable removeAllObjects]; // Clear Table
    NSMutableArray *section = [[NSMutableArray alloc] init];
    for (ListingString *listingStringElement in listingsListString) {
        
        Listing *currListing = [[Listing alloc] init];
        
        // ListingID , Title , SubTitle
        
        currListing.listingID = [listingStringElement.ItemID stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        currListing.listingID = [currListing.listingID stringByReplacingOccurrencesOfString:@"" withString:@""];
        currListing.title = [listingStringElement.ItemName stringByReplacingOccurrencesOfString:@"\n" withString:@""];

        
        // Placemarker
        
        CLLocationCoordinate2D tempPlacemarker;
        
        NSString *tempLat = [listingStringElement.Latitude stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        double latDouble =[tempLat doubleValue];
        tempPlacemarker.latitude = latDouble;
        
        NSString *tempLong = [listingStringElement.Longitude stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        double lonDouble =[tempLong doubleValue];
        tempPlacemarker.longitude = lonDouble;
        
        currListing.coordinate = tempPlacemarker;
        
        //Sort and Filter Types
        
        currListing.listingType = [listingStringElement.ListingType stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        currListing.areaID = [listingStringElement.AreaID stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        currListing.costType =[listingStringElement.Cost stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        currListing.subType = [listingStringElement.SubtypeName stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
        // Address
        
        currListing.address = [listingStringElement.Address stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
        currListing.majorRegionName = [listingStringElement.MajorRegionName stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
        currListing.phone = [listingStringElement.Phone stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
        currListing.email = [listingStringElement.Email stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
        currListing.suburb = [listingStringElement.Suburb stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
        currListing.openingHours = [listingStringElement.OpeningHours stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
        
        // Listing View details
        
        currListing.description = [listingStringElement.Details stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        currListing.imageFilenames = [listingStringElement.ImageURL componentsSeparatedByString:@","];
        currListing.videoURL = [NSURL URLWithString:[listingStringElement.VideoURL stringByReplacingOccurrencesOfString:@"\n" withString:@""]];
        currListing.websiteURL = [NSURL URLWithString:[listingStringElement.Website stringByReplacingOccurrencesOfString:@"\n" withString:@""]];
        currListing.audioURL = [NSURL URLWithString:[listingStringElement.AudioURL stringByReplacingOccurrencesOfString:@"\n" withString:@""]];
        
        // Start Date
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd/MM/yyyy"];
        // Start Date
        listingStringElement.StartDate = [listingStringElement.StartDate stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        NSDate *startDate = [dateFormatter dateFromString:listingStringElement.StartDate];
        currListing.startDate = startDate;
        
        // End Date
        listingStringElement.EndDate = [listingStringElement.EndDate stringByReplacingOccurrencesOfString:@"\n" withString:@""];
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

        [mapView addAnnotation:currListing];
        
        [section addObject:currListing];
        
        
        }
    
    // --------------------------
    
    
    NSDictionary *sectionDict = @{@"Favourites": section};
    [listingTable addObject:sectionDict];

    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath // Control for Map View Button to Listing Detail View
{
    NSDictionary *dictionary = listingTable[indexPath.section];
    NSArray *array = dictionary[@"Favourites"];
    Listing *selectedEvent = array[indexPath.row];
    
    ListingViewController *listingView = [self.storyboard instantiateViewControllerWithIdentifier:@"ListingViewController"]; // Listing Detail Page
    listingView.currentListing = selectedEvent;
    [self.navigationController pushViewController:listingView animated:YES];
    NSLog(@"Button");
    
}

-(void)setupMap
{
    // NEED TO ADD A RESTRICTION!
    // NEED TO TEST OUTSIDE OF CANBERRA
    
    //Map Settings
    
    
    [mapView setMapType:MKMapTypeStandard];
    [mapView setZoomEnabled:YES];
    [mapView setScrollEnabled:YES];
    [mapView setDelegate:self];
    
    //Center Map on users location;
    //CLLocationCoordinate2D zoomLocation;
    MKCoordinateRegion region = {{0.0, 0.0}, {0.0,0.0}};
    region.center.latitude = -35.281150; //mapView.userLocation.location.coordinate.latitude;
    region.center.longitude = 149.128668; //mapView.userLocation.location.coordinate.longitude;
    region.span.latitudeDelta = 0.15f; // Zoom Settings
    region.span.longitudeDelta = 0.25f; // Zoom Settings
    [mapView setRegion:region animated:YES];
    
}

// *** MAP METHODS ****

-(MKAnnotationView *) mapView:(MKMapView *)mapViewAroundMe viewForAnnotation:(id<MKAnnotation>)annotation
{
    
    MKPinAnnotationView *MyPin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"current"];
    MyPin.pinColor = MKPinAnnotationColorRed;
    
    MyPin.draggable = NO;
    MyPin.highlighted = YES;
    MyPin.animatesDrop = TRUE;
    MyPin.canShowCallout = NO;
    
    if (annotation == mapViewAroundMe.userLocation) {
        return nil;
    }
    //MyPin.image = [UIImage imageNamed:@"Map-Marker-Marker-Outside-Azure-256.png"];
    //MyPin.annotation = annotation;
    
    return MyPin;
}


-(void)mapView:(MKMapView *)mapViewSelect didSelectAnnotationView:(MKPinAnnotationView *)view
{
    NSLog(@"didSelectAnnotationView");
    detailView.hidden = FALSE;
    view.pinColor = MKPinAnnotationColorGreen;
    
    if ([view.annotation isKindOfClass:[Listing class]] )
    {
        //Title
        TitleLabel.text = view.annotation.title;
        
        //Address
        addressLabel.text = ((Listing *) view.annotation).address;
        
        //Start Date
        //        NSDateFormatter *startDateFormat = [[NSDateFormatter alloc] init];
        //        [startDateFormat setDateFormat:@"EEEE','MMMM d'.' KK:mma"];
        //        NSString *startDateString = [startDateFormat stringFromDate:((Listing *) view.annotation).startDate];
        startDateLabel.text = ((Listing *) view.annotation).subType;
        
        //Detail Image
        NSString *imageString = [(((Listing *) view.annotation).imageFilenames)[0] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        detailImage.image =[UIImage imageNamed:@"Placeholder.png"];
        dispatch_queue_t concurrentQueue =
        dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
        dispatch_async(concurrentQueue, ^(void){
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageString]]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                detailImage.image = image;
            });
        });
        
        NSLog(@"%@",(((Listing *) view.annotation).imageFilenames)[0]);
        
        //Button Press
        
        NSString *listingID = ((Listing *) view.annotation).listingID;
        for (int i = 0; i < [listingsList count]; i++) {
            Listing *currentListing = listingsList[i];
            if ([currentListing.listingID isEqualToString:listingID]) {
                ListingViewButton.tag = i;
            }
        }
        [ListingViewButton addTarget:self action:@selector(ListingView:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
}


-(void)mapView:(MKMapView *)mapViewDeSelect didDeselectAnnotationView:(MKPinAnnotationView *)view
{
    NSLog(@"didDeselectAnnotationView");
    detailView.hidden = TRUE;
    view.pinColor = MKPinAnnotationColorRed;
}
// END MAP METHODS


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

- (void)eventEditViewController:(EKEventEditViewController *)controller didCompleteWithAction:(EKEventEditViewAction)action
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void) threadStartAnimating:(id)data{
    loadView.hidden = false;
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

// Switch View Button

- (IBAction)switchViews {
    // Also I haven't primed the array, yet it still works - will need to ensure array order by bringing Subview to Front on initialisation.
    
    //Button to switch between Map and Table view
    NSArray *viewArray = favView.subviews; //Gathers an arrary of 'view' in the 'aroundMe' stack in order.
    if (viewArray[1] == MapWindow) // change to table view
    {
        // Main Window Animation
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:favView cache:YES];
        [favView bringSubviewToFront:TableWindow];
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
    else if (viewArray[1] == TableWindow) // change to mapview
    {
        // Main Window Animation
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:favView cache:YES];
        [favView bringSubviewToFront:MapWindow];
        [UIView commitAnimations];
        switchTableView.hidden=true;
        switchMapView.hidden=false;
        // Navigation Bar Animation
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:navView cache:YES];
        [navView bringSubviewToFront:switchMapView];
        [UIView commitAnimations];
        [self setupMap];
        
    }

}

-(void)ListingView:(id)sender  // Control for Map View Button to Listing Detail View
{
    ListingViewController *listingView = [self.storyboard instantiateViewControllerWithIdentifier:@"ListingViewController"]; // Listing Detail Page
    NSInteger selectedIndex = ((UIButton*)sender).tag;
    Listing *selectedListing = listingsList[selectedIndex];
    listingView.currentListing = selectedListing;
    [self.navigationController pushViewController:listingView animated:YES];
    NSLog(@"%@",selectedListing.listingID);
}
@end