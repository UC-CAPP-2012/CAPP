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
#import "SideSwipeTableViewCell.h"
#define USE_GESTURE_RECOGNIZERS YES
#define BOUNCE_PIXELS 5.0
#define PUSH_STYLE_ANIMATION NO

@interface FavoritesViewController (PrivateStuff)
- (void) addSwipeViewTo:(UITableViewCell*)cell direction:(UISwipeGestureRecognizerDirection)direction;
- (void) setupGestureRecognizers;
- (void) swipe:(UISwipeGestureRecognizer *)recognizer direction:(UISwipeGestureRecognizerDirection)direction;
@end

bool errorMsgShown;
@implementation FavoritesViewController
PullToRefreshView *pull;
@synthesize sideSwipeView, sideSwipeCell, sideSwipeDirection, animatingSideSwipe;
@synthesize currSel,sortSel, typeListingTable, costListingTable, suburbListingTable, refreshing;
@synthesize listing,listingsDataSource,listingTable, listingsList,listingsListString,filteredTableData, isFiltered;
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
        if([listingsList count]==0 || [listingsList count]!= [favData count] ){
            [self setupArray];
            [tableView reloadData];
        }
        
    }else{
        tableView.hidden = true;
        emptyListMsg.hidden = false;
    }
    
    [loadView removeFromSuperview];
}

- (void)viewWillAppear:(BOOL)animated{
    emptyListMsg.hidden = TRUE;
    
    if([listingsList count]==0){
        tableView.contentOffset = CGPointMake(0, searchBar.frame.size.height);
    }
}

- (void)viewDidLoad
{
    [super setTitle:@"loved"];
    NSMutableString *stringName = [GenerateFavoritesString createFavoriteString];
    NSLog(@"%@",stringName);
    switchTableView.hidden=false;
    switchMapView.hidden=true;
    detailView.hidden = TRUE;
    detailView.backgroundColor = [UIColor clearColor];
    errorMsgShown = NO;
    //Creating a file path under iPhone OS:
    //1) Search for the app's documents directory (copy+paste from Documentation)
    
    currSel=0;
    Cost = [[NSMutableArray alloc] init];
    [Cost addObject:@"Free"];
    [Cost addObject:@"$"];
    [Cost addObject:@"$$"];
    [Cost addObject:@"$$$"];
    [Cost addObject:@"$$$$"];
    [Cost addObject:@"$$$$$"];
    
    [super viewDidLoad];
    animatingSideSwipe = NO;
    self.sideSwipeView = [[UIView alloc] initWithFrame:CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y, tableView.frame.size.width, tableView.rowHeight)];
    [self setupSideSwipeView];
    [self setupGestureRecognizers];
    pull = [[PullToRefreshView alloc] initWithScrollView:(UIScrollView *) tableView];
    [pull setDelegate:self];
    [tableView addSubview:pull];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(foregroundRefresh:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void) setupSideSwipeView
{
    // Add the background pattern
    //self.sideSwipeView.backgroundColor = [UIColor colorWithRed:0.0 green:0.8 blue:0.0 alpha:0.5];
    // Overlay a shadow image that adds a subtle darker drop shadow around the edges
    UIImage* shadow = [UIImage imageNamed:@"inner-shadow.png"];
    UIImageView* shadowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(tableView.frame.origin.x, 0, tableView.frame.size.width, tableView.rowHeight)];
    shadowImageView.alpha = 0.2;
    shadowImageView.image = shadow;
    shadowImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.sideSwipeView addSubview:shadowImageView];
    
    
}

- (BOOL) gestureRecognizersSupported
{
    if (!USE_GESTURE_RECOGNIZERS) return NO;
    
    // Apple's docs: Although this class was publicly available starting with iOS 3.2, it was in development a short period prior to that
    // check if it responds to the selector locationInView:. This method was not added to the class until iOS 3.2.
    return [[[UISwipeGestureRecognizer alloc] init] respondsToSelector:@selector(locationInView:)];
}

- (void) setupGestureRecognizers
{
    // Do nothing under 3.x
    if (![self gestureRecognizersSupported]) return;
    
    // Setup a right swipe gesture recognizer
    UISwipeGestureRecognizer* rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
    rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [tableView addGestureRecognizer:rightSwipeGestureRecognizer];
    
    // Setup a left swipe gesture recognizer
    UISwipeGestureRecognizer* leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
    leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [tableView addGestureRecognizer:leftSwipeGestureRecognizer];
}

// Called when a left swipe occurred
- (void)swipeLeft:(UISwipeGestureRecognizer *)recognizer
{
    [self swipe:recognizer direction:UISwipeGestureRecognizerDirectionLeft];
}

// Called when a right swipe ocurred
- (void)swipeRight:(UISwipeGestureRecognizer *)recognizer
{
    [self swipe:recognizer direction:UISwipeGestureRecognizerDirectionRight];
}

// Handle a left or right swipe
- (void)swipe:(UISwipeGestureRecognizer *)recognizer direction:(UISwipeGestureRecognizerDirection)direction
{
    if (recognizer && recognizer.state == UIGestureRecognizerStateEnded)
    {
        // Get the table view cell where the swipe occured
        CGPoint location = [recognizer locationInView:tableView];
        NSIndexPath* indexPath = [tableView indexPathForRowAtPoint:location];
        UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        
        // If we are already showing the swipe view, remove it
        if (cell.frame.origin.x != 0)
        {
            [self removeSideSwipeView:YES];
            return;
        }
        
        // Make sure we are starting out with the side swipe view and cell in the proper location
        [self removeSideSwipeView:NO];
        
        // If this isn't the cell that already has thew side swipe view and we aren't in the middle of animating
        // then start animating in the the side swipe view
        if (cell!= sideSwipeCell && !animatingSideSwipe)
            [self addSwipeViewTo:cell direction:direction];
    }
}


- (void)pullToRefreshViewShouldRefresh:(PullToRefreshView *)view;
{
    
    tableView.contentOffset = CGPointMake(0, -65);
    [pull setState:PullToRefreshViewStateLoading];
    
    // [self reloadTableData];
    
    [self performSelectorInBackground:@selector(reloadTableData) withObject:nil];
}

-(void) reloadTableData
{
    
    // call to reload your data
    if (segmentController.selectedSegmentIndex == 0) {
        sortSel = 0;
        NSLog(@"Button1");
    }
    if (segmentController.selectedSegmentIndex == 1) {
        sortSel = 1;
        NSLog(@"Button2");
    }
    if (segmentController.selectedSegmentIndex == 2) {
        sortSel = 2;
        NSLog(@"Button3");
    }
    if (segmentController.selectedSegmentIndex == 3) {
        sortSel = 3;
        NSLog(@"Button4");
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    //2) Create the full file path by appending the desired file name
    NSString *yourArrayFileName = [documentsDirectory stringByAppendingPathComponent:@"example.dat"];
    
    //Load the array
    favData = [[NSMutableArray alloc] initWithContentsOfFile: yourArrayFileName];
    if([favData count]>0)
    {
        
        [self setupArray];
        
        [tableView reloadData];
    }
    [pull finishedLoading];
}

-(void)foregroundRefresh:(NSNotification *)notification
{
    
    //self->tableView.contentOffset = CGPointMake(0, -65);
    //[pull setState:PullToRefreshViewStateLoading];
    //[self reloadTableData];
    //[self performSelectorInBackground:@selector(reloadTableData) withObject:nil];
}



//Reload With Tab Bar
//--------------------------------------------------------------------------------------------------//
//Reloads the table view when navigated to with the tab bar controller.

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
//
//    if (sortSel == 0) { // allphabetically.
//
//        [listingTable removeAllObjects]; // Clear Table
//    }
//    else if (sortSel == 1) { //Type
//        [typeListingTable removeAllObjects]; // Clear Table
//
//    }
//    else if (sortSel == 2) {  //Price
//
//        [costListingTable removeAllObjects]; // Clear Table
//    }
//    else { // Suburb
//        [suburbListingTable removeAllObjects]; // Clear Table
//    }
//
//    NSMutableArray *section = [[NSMutableArray alloc] init];
//
//    if([listingsList count]>0){
//        for(int i =0; i<[listingsList count]; i++){
//            [section addObject:listingsList[i]];
//        }
//        NSDictionary *sectionDict = @{@"Favourites": section};
//        [listingTable addObject:sectionDict];
//
//
//        for (int i =0; i < [sortHeaders2 count]; i++){
//            NSMutableArray *section2 = [[NSMutableArray alloc] init];
//            NSString *currSortHeader = sortHeaders2[i];
//            for (Listing *listingListListing in listingsList)
//            {
//                NSString *type = listingListListing.subType;
//
//                if ([type isEqualToString:currSortHeader])
//                {
//                    [section2 addObject:listingListListing];
//                }
//            }
//            NSDictionary *sectionDict2 = @{@"Favourites": section2};
//            [typeListingTable addObject:sectionDict2];
//
//        }
//
//        for (int i =0; i < [sortHeaders3 count]; i++){
//            NSMutableArray *section3 = [[NSMutableArray alloc] init];
//            NSString *currSortHeader = sortHeaders3[i];
//            for (Listing *listingListListing in listingsList)
//            {
//                NSString *type = listingListListing.costType;
//
//                if ([type isEqualToString:currSortHeader])
//                {
//                    [section3 addObject:listingListListing];
//                }
//            }
//            NSDictionary *sectionDict3 = @{@"Favourites": section3};
//            [costListingTable addObject:sectionDict3];
//
//        }
//
//        for (int i =0; i < [sortHeaders4 count]; i++){
//            NSMutableArray *section4 = [[NSMutableArray alloc] init];
//            NSString *currSortHeader = sortHeaders4[i];
//            for (Listing *listingListListing in listingsList)
//            {
//                NSString *type = listingListListing.suburb;
//
//                if ([type isEqualToString:currSortHeader])
//                {
//                    [section4 addObject:listingListListing];
//                }
//            }
//            NSDictionary *sectionDict4 = @{@"Favourites": section4};
//            [suburbListingTable addObject:sectionDict4];
//
//        }
//
//        NSLog(@"%i",[listingTable count]);
//        NSLog(@"%i",[typeListingTable count]);
//        NSLog(@"%i",[costListingTable count]);
//        NSLog(@"%i",[suburbListingTable count]);
//    }
//
//    //[listingTable removeObjectAtIndex:indexPath.row];
//    [favData writeToFile:yourArrayFileName atomically:YES];
//    [tableView reloadData];
//
//}
//--------------------------------------------------------------------------------------------------//



// Return number of sections in table (always 1 for this demo!)
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(isFiltered){
        return 1;
    }
    else{
        if (sortSel == 0) { // allphabetically.
            return 1;
        }
        else if (sortSel == 1) { //Type
            return [typeListingTable count];
            
        }
        else if (sortSel == 2) {  //Price
            
            return [costListingTable count];
        }
        else { // Suburb
            return [suburbListingTable count];
        }
        
    }
}

// Return the amount of items in our table (the total items in our array above)
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.isFiltered){
        return filteredTableData.count;
    }
    else{
        if([listingsList count]>0){
            NSDictionary *dictionary;
            if (sortSel == 0) { // allphabetically.
                dictionary= listingTable[section];
            }
            else if (sortSel == 1) { //Type
                dictionary= typeListingTable[section];
            }
            else if (sortSel == 2) {  //Price
                dictionary= costListingTable[section];
            }
            else { // Suburb
                dictionary= suburbListingTable[section];
            }
            
            NSArray *array = dictionary[@"Favourites"];
            return [array count];
        }else{
            return 0;
        }
        
    }
}

-(UIView *)tableView:(UITableView *)tableViewHeader viewForHeaderInSection:(NSInteger)section
{
    NSMutableArray *sectionHeaders = [[NSMutableArray alloc] init];
    NSString *title = nil;
    [sectionHeaders removeAllObjects];
    if(isFiltered){
        NSMutableArray *header= [[NSMutableArray alloc] init];
        [header addObject:@"Search Results"];
        sectionHeaders = [NSArray arrayWithArray:header];
    }
    else{
        if (sortSel == 0) { // allphabetically.
            sectionHeaders = [NSArray arrayWithArray:sortHeaders1];
        }
        else if (sortSel == 1) { //Type
            for(NSString *header in sortHeaders2)
            {
                [sectionHeaders addObject:header];
            }
            
        }
        else if (sortSel == 2) {  //Price
            
            for(NSString *header in sortHeaders3)
            {
                [sectionHeaders addObject: [Cost objectAtIndex:[header intValue]]];
            }
        }
        else if (sortSel == 3) { // Suburb
            for(NSString *header in sortHeaders4)
            {
                [sectionHeaders addObject:header];
            }
        }
    }
    UIView *headerView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableViewHeader.bounds.size.width, tableViewHeader.bounds.size.height)];
    [headerView setBackgroundColor:[UIColor colorWithRed:0.23 green:0.70 blue:0.44 alpha:1]];
    UILabel *headerTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableViewHeader.bounds.size.width - 10, 20)];
    
    for (int i = 0; i < [sectionHeaders count]; i++) {
        if (section == i)
        {
            NSString *currHeaders = sectionHeaders[i];
            title = currHeaders;
        }
        
    }
    
    
    headerTitle.text = title;
    
    headerTitle.textColor = [UIColor whiteColor];
    headerTitle.backgroundColor = [UIColor clearColor];
    [headerView addSubview:headerTitle];
    
    return headerView;
}


// Return a cell for the table
- (UITableViewCell *)tableView:(UITableView *)tableViewSection cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // A cell identifier which matches our identifier in IB
    static NSString *CellIdentifier = @"CellFavorites";
    
    // Create or reuse a cell
    SideSwipeTableViewCell *cell = (SideSwipeTableViewCell*)[tableViewSection dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[SideSwipeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    if(refreshing==NO){
        Listing *currListing;
        if(isFiltered)
        {
            currListing = filteredTableData[indexPath.row];
        }
        else
        {
            NSDictionary *dictionary;
            if (sortSel == 0) { // allphabetically.
                dictionary= listingTable[indexPath.section];
            }
            else if (sortSel == 1) { //Type
                dictionary= typeListingTable[indexPath.section];
                
            }
            else if (sortSel == 2) {  //Price
                
                dictionary= costListingTable[indexPath.section];
            }
            else { // Suburb
                dictionary= suburbListingTable[indexPath.section];
            }
            NSArray *array = dictionary[@"Favourites"];
            currListing= array[indexPath.row];
        }
        
        // Get the cell label using its tag and set it
        //UILabel *cellLabel;
        
        //[cellLabel setText:[favData objectAtIndex:indexPath.row]];
        
        
        UIImage* image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",currListing.subType]];
        if(image==NULL){
            image = [UIImage imageNamed:@"star-hollow@2x.png"];
        }
        cell.imageView.image = image;
        //ContentView
        //ContentView
        UILabel *cellHeading = (UILabel *)[cell viewWithTag:2];
        [cellHeading setText: currListing.title];
        
        UILabel *cellSubtype = (UILabel *)[cell viewWithTag:3];
        [cellSubtype setText: currListing.suburb];
        
        //ContentView
        //        CGRect Button1Frame = CGRectMake(230, 30, 65, 25);
        //        UIButton *btnTemp = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        //
        //        btnTemp.frame =Button1Frame;
        //
        //        // Make sure the button ends up in the right place when the cell is resized
        //        btnTemp.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
        //
        //        [btnTemp setTitle:@"Remove" forState:UIControlStateNormal];
        //        btnTemp.clipsToBounds = YES;
        //
        //        //[btnTemp setTitleColor:[UIColor colorWithRed:0 green:0 blue:1 alpha:1] forState:UIControlStateNormal];
        //        for (int i = 0; i < [listingsList count]; i++) {
        //            Listing *currentListing = listingsList[i];
        //            if ([currentListing.listingID isEqualToString:currListing.listingID]) {
        //                btnTemp.tag =i;
        //            }
        //        }
        //
        //
        //            [btnTemp addTarget:self action:@selector(unfavourite:) forControlEvents:UIControlEventTouchUpInside];
        //[cell addSubview:btnTemp];
    }
    return cell;
}

- (void)tableView:(UITableView *)theTableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    // If we are using gestures, then don't do anything
    if ([self gestureRecognizersSupported]) return;
    
    // Get the table view cell where the swipe occured
    UITableViewCell* cell = [theTableView cellForRowAtIndexPath:indexPath];
    
    // Make sure we are starting out with the side swipe view and cell in the proper location
    [self removeSideSwipeView:NO];
    
    // If this isn't the cell that already has thew side swipe view and we aren't in the middle of animating
    // then start animating in the the side swipe view. We don't have access to the direction, so we always assume right
    if (cell!= sideSwipeCell && !animatingSideSwipe)
        [self addSwipeViewTo:cell direction:UISwipeGestureRecognizerDirectionRight];
}

// Apple's docs: To enable the swipe-to-delete feature of table views (wherein a user swipes horizontally across a row to display a Delete button), you must implement the tableView:commitEditingStyle:forRowAtIndexPath: method.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // If we are using gestures, then don't allow editing
    if ([self gestureRecognizersSupported])
        return NO;
    else
        return YES;
}

#pragma mark Adding the side swipe view
- (void) addSwipeViewTo:(UITableViewCell*)cell direction:(UISwipeGestureRecognizerDirection)direction
{
    // Change the frame of the side swipe view to match the cell
    sideSwipeView.frame = cell.frame;
    
    // Add the side swipe view to the table below the cell
    [tableView insertSubview:sideSwipeView belowSubview:cell];
    
    // Remember which cell the side swipe view is displayed on and the swipe direction
    self.sideSwipeCell = cell;
    sideSwipeDirection = direction;
    
    CGRect cellFrame = cell.frame;
    if (PUSH_STYLE_ANIMATION)
    {
        // Move the side swipe view offscreen either to the left or the right depending on the swipe direction
        sideSwipeView.frame = CGRectMake(direction == UISwipeGestureRecognizerDirectionRight ? -cellFrame.size.width : cellFrame.size.width, cellFrame.origin.y, cellFrame.size.width, cellFrame.size.height);
        
        
    }
    else
    {
        // Move the side swipe view to offset 0
        sideSwipeView.frame = CGRectMake(0, cellFrame.origin.y, cellFrame.size.width, cellFrame.size.height);
    }
    
    NSIndexPath* indexPath = [tableView indexPathForCell:sideSwipeCell];
    NSDictionary *dictionary;
    if (sortSel == 0) { // allphabetically.
        dictionary= listingTable[indexPath.section];
    }
    else if (sortSel == 1) { //Type
        dictionary= typeListingTable[indexPath.section];
        
    }
    else if (sortSel == 2) {  //Price
        
        dictionary= costListingTable[indexPath.section];
    }
    else { // Suburb
        dictionary= suburbListingTable[indexPath.section];
    }
    
    NSMutableArray *array = dictionary[@"Events"];
    Listing *currListing = array[indexPath.row];
    
    //ContentView
    CGRect Button1Frame = CGRectMake(150, 10, 30, 30);
    UIButton *btnTemp = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btnTemp =[[UIButton alloc] initWithFrame:Button1Frame];
    
    // Make sure the button ends up in the right place when the cell is resized
    btnTemp.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    
    
    for (int i = 0; i < [listingsList count]; i++) {
        Listing *currentListing = listingsList[i];
        if ([currentListing.listingID isEqualToString:currListing.listingID]) {
            btnTemp.tag =i;
        }
    }
    
    
    [btnTemp setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1]];
    [btnTemp setImage:nil forState:UIControlStateNormal];
    [btnTemp setImage:nil forState:UIControlStateSelected];
    //btnTemp.imageView.image = [UIImage imageNamed:@"thumbs_down@2x.png"];
    [btnTemp setImage:[UIImage imageNamed:@"thumbs_down@2x.png"] forState:UIControlStateNormal];
    [btnTemp setImage:[UIImage imageNamed:@"thumbs_down@2x.png"] forState:UIControlStateSelected];
    //[btnTemp setBackgroundImage:[UIImage imageNamed:@"thumbs_down@2x.png"] forState:UIControlStateApplication];
    //[btnTemp setBackgroundImage:[UIImage imageNamed:@"thumbs_down@2x.png"] forState:UIControlStateDisabled];
    //[btnTemp setBackgroundImage:[UIImage imageNamed:@"thumbs_down@2x.png"] forState:UIControlStateHighlighted];
    //[btnTemp setBackgroundImage:[UIImage imageNamed:@"thumbs_down@2x.png"] forState:UIControlStateReserved];
    [btnTemp addTarget:self action:@selector(unfavourite:) forControlEvents:UIControlEventTouchUpInside];
    [self.sideSwipeView addSubview:btnTemp];
    
    
    // Animate in the side swipe view
    animatingSideSwipe = YES;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStopAddingSwipeView:finished:context:)];
    if (PUSH_STYLE_ANIMATION)
    {
        // Move the side swipe view to offset 0
        // While simultaneously moving the cell's frame offscreen
        // The net effect is that the side swipe view is pushing the cell offscreen
        sideSwipeView.frame = CGRectMake(0, cellFrame.origin.y, cellFrame.size.width, cellFrame.size.height);
    }
    cell.frame = CGRectMake(direction == UISwipeGestureRecognizerDirectionRight ? cellFrame.size.width : -cellFrame.size.width, cellFrame.origin.y, cellFrame.size.width, cellFrame.size.height);
    [UIView commitAnimations];
}

// Note that the animation is done
- (void)animationDidStopAddingSwipeView:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    animatingSideSwipe = NO;
}

#pragma mark Removing the side swipe view
// UITableViewDelegate
// When a row is selected, animate the removal of the side swipe view
- (NSIndexPath *)tableView:(UITableView *)theTableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self removeSideSwipeView:YES];
    return indexPath;
}

// UIScrollViewDelegate
// When the table is scrolled, animate the removal of the side swipe view
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self removeSideSwipeView:YES];
}

// When the table is scrolled to the top, remove the side swipe view
- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    [self removeSideSwipeView:NO];
    return YES;
}

// Remove the side swipe view.
// If animated is YES, then the removal is animated using a bounce effect
- (void) removeSideSwipeView:(BOOL)animated
{
    // Make sure we have a cell where the side swipe view appears and that we aren't in the middle of animating
    if (!sideSwipeCell || animatingSideSwipe) return;
    
    if (animated)
    {
        // The first step in a bounce animation is to move the side swipe view a bit offscreen
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        if (sideSwipeDirection == UISwipeGestureRecognizerDirectionRight)
        {
            if (PUSH_STYLE_ANIMATION)
                sideSwipeView.frame = CGRectMake(-sideSwipeView.frame.size.width + BOUNCE_PIXELS,sideSwipeView.frame.origin.y,sideSwipeView.frame.size.width, sideSwipeView.frame.size.height);
            sideSwipeCell.frame = CGRectMake(BOUNCE_PIXELS, sideSwipeCell.frame.origin.y, sideSwipeCell.frame.size.width, sideSwipeCell.frame.size.height);
        }
        else
        {
            if (PUSH_STYLE_ANIMATION)
                sideSwipeView.frame = CGRectMake(sideSwipeView.frame.size.width - BOUNCE_PIXELS,sideSwipeView.frame.origin.y,sideSwipeView.frame.size.width, sideSwipeView.frame.size.height);
            sideSwipeCell.frame = CGRectMake(-BOUNCE_PIXELS, sideSwipeCell.frame.origin.y, sideSwipeCell.frame.size.width, sideSwipeCell.frame.size.height);
        }
        animatingSideSwipe = YES;
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationDidStopOne:finished:context:)];
        [UIView commitAnimations];
    }
    else
    {
        [sideSwipeView removeFromSuperview];
        sideSwipeCell.frame = CGRectMake(0,sideSwipeCell.frame.origin.y,sideSwipeCell.frame.size.width, sideSwipeCell.frame.size.height);
        self.sideSwipeCell = nil;
    }
}

#pragma mark Bounce animation when removing the side swipe view
// The next step in a bounce animation is to move the side swipe view a bit on screen
- (void)animationDidStopOne:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    if (sideSwipeDirection == UISwipeGestureRecognizerDirectionRight)
    {
        if (PUSH_STYLE_ANIMATION)
            sideSwipeView.frame = CGRectMake(-sideSwipeView.frame.size.width + BOUNCE_PIXELS*2,sideSwipeView.frame.origin.y,sideSwipeView.frame.size.width, sideSwipeView.frame.size.height);
        sideSwipeCell.frame = CGRectMake(BOUNCE_PIXELS*2, sideSwipeCell.frame.origin.y, sideSwipeCell.frame.size.width, sideSwipeCell.frame.size.height);
    }
    else
    {
        if (PUSH_STYLE_ANIMATION)
            sideSwipeView.frame = CGRectMake(sideSwipeView.frame.size.width - BOUNCE_PIXELS*2,sideSwipeView.frame.origin.y,sideSwipeView.frame.size.width, sideSwipeView.frame.size.height);
        sideSwipeCell.frame = CGRectMake(-BOUNCE_PIXELS*2, sideSwipeCell.frame.origin.y, sideSwipeCell.frame.size.width, sideSwipeCell.frame.size.height);
    }
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStopTwo:finished:context:)];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView commitAnimations];
}

// The final step in a bounce animation is to move the side swipe completely offscreen
- (void)animationDidStopTwo:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    [UIView commitAnimations];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    if (sideSwipeDirection == UISwipeGestureRecognizerDirectionRight)
    {
        if (PUSH_STYLE_ANIMATION)
            sideSwipeView.frame = CGRectMake(-sideSwipeView.frame.size.width ,sideSwipeView.frame.origin.y,sideSwipeView.frame.size.width, sideSwipeView.frame.size.height);
        sideSwipeCell.frame = CGRectMake(0, sideSwipeCell.frame.origin.y, sideSwipeCell.frame.size.width, sideSwipeCell.frame.size.height);
    }
    else
    {
        if (PUSH_STYLE_ANIMATION)
            sideSwipeView.frame = CGRectMake(sideSwipeView.frame.size.width ,sideSwipeView.frame.origin.y,sideSwipeView.frame.size.width, sideSwipeView.frame.size.height);
        sideSwipeCell.frame = CGRectMake(0, sideSwipeCell.frame.origin.y, sideSwipeCell.frame.size.width, sideSwipeCell.frame.size.height);
    }
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStopThree:finished:context:)];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView commitAnimations];
}

// When the bounce animation is completed, remove the side swipe view and reset some state
- (void)animationDidStopThree:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    animatingSideSwipe = NO;
    self.sideSwipeCell = nil;
    [sideSwipeView removeFromSuperview];
}


-(void)unfavourite:(id)sender
{
    
    NSInteger selectedIndex = ((UIButton*)sender).tag;
    Listing *selected = listingsList[selectedIndex];
    [listingsList removeObjectAtIndex:selectedIndex];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    //2) Create the full file path by appending the desired file name
    NSString *yourArrayFileName = [documentsDirectory stringByAppendingPathComponent:@"example.dat"];
    favData = [[NSMutableArray alloc] initWithContentsOfFile: yourArrayFileName];
    for(int x = 0; x<[favData count]; x++){
        NSString *listingId = favData[x];
        if([listingId isEqualToString:selected.listingID]){
            [favData removeObjectAtIndex:x];
        }
        
    }
    
    //    NSMutableArray *tempList = listingsList;
    //    [listingsList removeAllObjects];
    //    listingsList = [[NSMutableArray alloc] init];
    //    for(int y=0; y<[tempList count]; y++){
    //        Listing *listingItem = (Listing *)tempList[y];
    //        if(![listingItem.listingID isEqualToString:selected.listingID]){
    //            [listingsList addObject:listingItem];
    //        }
    //    }
    
    [listingTable removeAllObjects];
    [typeListingTable removeAllObjects];
    
    [costListingTable removeAllObjects];
    [suburbListingTable removeAllObjects];
    
    listingTable = [[NSMutableArray alloc] init]; //List Displayed in the Table
    typeListingTable = [[NSMutableArray alloc] init]; //List Displayed in the Table
    costListingTable = [[NSMutableArray alloc] init]; //List Displayed in the Table
    suburbListingTable = [[NSMutableArray alloc] init]; //List Displayed in the Table
    sortHeaders1 = [[NSMutableArray alloc] init]; //No Headers
    sortHeaders2 = [[NSMutableArray alloc] init]; //Distinct Type Headers
    sortHeaders3 = [[NSMutableArray alloc] init]; //Distinct Rating Headers
    sortHeaders4 = [[NSMutableArray alloc] init]; //Distinct Price Headers
    
    NSMutableArray *section = [[NSMutableArray alloc] init];
    
    if([listingsList count]>0){
        for(int i =0; i<[listingsList count]; i++){
            [section addObject:listingsList[i]];
            Listing *tempListing = listingsList[i];
            NSString *subType = tempListing.subType;
            if(![sortHeaders2 containsObject:subType])
            {
                [sortHeaders2 addObject:subType];
                NSLog(@"%@", subType);
            }
            
            NSString *cost = tempListing.costType;
            if(![sortHeaders3 containsObject:cost])
            {
                [sortHeaders3 addObject:cost];
                NSLog(@"%@", cost);
            }
            
            NSString *suburb = tempListing.suburb;
            if(![sortHeaders4 containsObject:suburb])
            {
                [sortHeaders4 addObject:suburb];
                NSLog(@"%@", suburb);
            }
            
        }
        NSDictionary *sectionDict = @{@"Favourites": section};
        [listingTable addObject:sectionDict];
        
        
        for (int i =0; i < [sortHeaders2 count]; i++){
            NSMutableArray *section2 = [[NSMutableArray alloc] init];
            NSString *currSortHeader = sortHeaders2[i];
            for (Listing *listingListListing in listingsList)
            {
                NSString *type = listingListListing.subType;
                
                if ([type isEqualToString:currSortHeader])
                {
                    [section2 addObject:listingListListing];
                }
            }
            NSDictionary *sectionDict2 = @{@"Favourites": section2};
            [typeListingTable addObject:sectionDict2];
            
        }
        
        for (int i =0; i < [sortHeaders3 count]; i++){
            NSMutableArray *section3 = [[NSMutableArray alloc] init];
            NSString *currSortHeader = sortHeaders3[i];
            for (Listing *listingListListing in listingsList)
            {
                NSString *type = listingListListing.costType;
                
                if ([type isEqualToString:currSortHeader])
                {
                    [section3 addObject:listingListListing];
                }
            }
            NSDictionary *sectionDict3 = @{@"Favourites": section3};
            [costListingTable addObject:sectionDict3];
            
        }
        
        for (int i =0; i < [sortHeaders4 count]; i++){
            NSMutableArray *section4 = [[NSMutableArray alloc] init];
            NSString *currSortHeader = sortHeaders4[i];
            for (Listing *listingListListing in listingsList)
            {
                NSString *type = listingListListing.suburb;
                
                if ([type isEqualToString:currSortHeader])
                {
                    [section4 addObject:listingListListing];
                }
            }
            NSDictionary *sectionDict4 = @{@"Favourites": section4};
            [suburbListingTable addObject:sectionDict4];
            
        }
    }else{
        tableView.hidden = true;
        emptyListMsg.hidden = false;
        
    }
    [favData writeToFile:yourArrayFileName atomically:YES];
    [tableView reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

-(void) setupArray // Connection to DataSource
{
    refreshing = TRUE;
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
        if(errorMsgShown==NO){
            [alert show];
            errorMsgShown = YES;
        }
        
        NSLog(@"did not work!");
    }
    
    //This needs to be set via the filter and sorter.
    //[listingsListString removeAllObjects];
    [listingsList removeAllObjects];
    [listingTable removeAllObjects];
    listingsList = [[NSMutableArray alloc] init]; //Complete List of Listings
    listingTable = [[NSMutableArray alloc] init]; //List Displayed in the Table
    typeListingTable = [[NSMutableArray alloc] init]; //List Displayed in the Table
    costListingTable = [[NSMutableArray alloc] init]; //List Displayed in the Table
    suburbListingTable = [[NSMutableArray alloc] init]; //List Displayed in the Table
    sortHeaders1 = [[NSMutableArray alloc] init]; //No Headers
    sortHeaders2 = [[NSMutableArray alloc] init]; //Distinct Type Headers
    sortHeaders3 = [[NSMutableArray alloc] init]; //Distinct Rating Headers
    sortHeaders4 = [[NSMutableArray alloc] init]; //Distinct Price Headers
    [listingTable removeAllObjects]; // Clear Table
    [typeListingTable removeAllObjects]; // Clear Table
    [costListingTable removeAllObjects]; // Clear Table
    [suburbListingTable removeAllObjects]; // Clear Table
    NSMutableArray *section = [[NSMutableArray alloc] init];
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
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
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
        
        [mapView addAnnotation:currListing];
        
        Listing *tempListing = currListing;
        NSString *subType = tempListing.subType;
        if(![sortHeaders2 containsObject:subType])
        {
            [sortHeaders2 addObject:subType];
            NSLog(@"%@", subType);
        }
        
        NSString *cost = tempListing.costType;
        if(![sortHeaders3 containsObject:cost])
        {
            [sortHeaders3 addObject:cost];
            NSLog(@"%@", cost);
        }
        
        NSString *suburb = tempListing.suburb;
        if(![sortHeaders4 containsObject:suburb])
        {
            [sortHeaders4 addObject:suburb];
            NSLog(@"%@", suburb);
        }
        
        
        [section addObject:currListing];
    }
    
    // --------------------------
    
    
    NSDictionary *sectionDict = @{@"Favourites": section};
    [listingTable addObject:sectionDict];
    
    // --- SORT 1 Headers ---- // NAME
    
    [sortHeaders1 addObject:@"All"];
    
    // -----------------------
    
    
    [sortHeaders2 sortUsingSelector:@selector(compare:)];
    
    
    
    [sortHeaders3 sortUsingSelector:@selector(compare:)];
    
    
    
    [sortHeaders4 sortUsingSelector:@selector(compare:)];
    
    // -----------------------
    
    if([listingsList count]>0){
        
        for (int i =0; i < [sortHeaders2 count]; i++){
            NSMutableArray *section2 = [[NSMutableArray alloc] init];
            NSString *currSortHeader = sortHeaders2[i];
            for (Listing *listingListListing in listingsList)
            {
                NSString *type = listingListListing.subType;
                
                if ([type isEqualToString:currSortHeader])
                {
                    [section2 addObject:listingListListing];
                }
            }
            NSDictionary *sectionDict2 = @{@"Favourites": section2};
            [typeListingTable addObject:sectionDict2];
            
        }
        
        for (int i =0; i < [sortHeaders3 count]; i++){
            NSMutableArray *section3 = [[NSMutableArray alloc] init];
            NSString *currSortHeader = sortHeaders3[i];
            for (Listing *listingListListing in listingsList)
            {
                NSString *type = listingListListing.costType;
                
                if ([type isEqualToString:currSortHeader])
                {
                    [section3 addObject:listingListListing];
                }
            }
            NSDictionary *sectionDict3 = @{@"Favourites": section3};
            [costListingTable addObject:sectionDict3];
            
        }
        
        for (int i =0; i < [sortHeaders4 count]; i++){
            NSMutableArray *section4 = [[NSMutableArray alloc] init];
            NSString *currSortHeader = sortHeaders4[i];
            for (Listing *listingListListing in listingsList)
            {
                NSString *type = listingListListing.suburb;
                
                if ([type isEqualToString:currSortHeader])
                {
                    [section4 addObject:listingListListing];
                }
            }
            NSDictionary *sectionDict4 = @{@"Favourites": section4};
            [suburbListingTable addObject:sectionDict4];
            
        }
        
        NSLog(@"%i",[listingTable count]);
        NSLog(@"%i",[typeListingTable count]);
        NSLog(@"%i",[costListingTable count]);
        NSLog(@"%i",[suburbListingTable count]);
        tableView.hidden = false;
        emptyListMsg.hidden = true;
    }else{
        tableView.hidden = true;
        emptyListMsg.hidden = false;
        
    }
    refreshing = NO;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self showDetailsForIndexPath:indexPath];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self showDetailsForIndexPath:indexPath];
}

-(void) showDetailsForIndexPath:(NSIndexPath*)indexPath
{
    [searchBar resignFirstResponder];
    
    NSDictionary *dictionary;
    if (sortSel == 0) { // allphabetically.
        dictionary= listingTable[indexPath.section];
    }
    else if (sortSel == 1) { //Type
        dictionary= typeListingTable[indexPath.section];
        
    }
    else if (sortSel == 2) {  //Price
        
        dictionary= costListingTable[indexPath.section];
    }
    else { // Suburb
        dictionary= suburbListingTable[indexPath.section];
    }
    NSArray *array = dictionary[@"Favourites"];
    Listing *selectedEvent;
    
    if(isFiltered)
    {
        selectedEvent = filteredTableData[indexPath.row];
    }
    else
    {
        selectedEvent = array[indexPath.row];
    }
    
    ListingViewController *listingView = [self.storyboard instantiateViewControllerWithIdentifier:@"ListingViewController"]; // Listing Detail Page
    listingView.currentListing = selectedEvent;
    [self.navigationController pushViewController:listingView animated:YES];
    NSLog(@"Button");
}

-(void)searchBar:(UISearchBar*)searchBarUI textDidChange:(NSString*)text
{
    if(text.length == 0)
    {
        isFiltered = FALSE;
        [searchBarUI resignFirstResponder];
    }
    else
    {
        isFiltered = true;
        filteredTableData = [[NSMutableArray alloc] init];
        
        for (Listing* listingSearch in listingsList)
        {
            NSRange nameRange = [listingSearch.title rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange suburbRange = [listingSearch.suburb rangeOfString:text options:NSCaseInsensitiveSearch];
            
            if(nameRange.location != NSNotFound || suburbRange.location!=NSNotFound)
            {
                [filteredTableData addObject:listingSearch];
            }
        }
    }
    
    [tableView reloadData];
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
    
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"current"];// get a dequeued view for the annotation like a tableview
    
    if (annotationView == nil)
    {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"current"];
    }
    annotationView.annotation = annotation;
    annotationView.canShowCallout = YES; // show the grey popup with location etc
    UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    if ([annotation isKindOfClass:[Listing class]] )
    {
        Listing *current = ((Listing *) annotation);
        for (int i = 0; i < [listingsList count]; i++) {
            Listing *currentListing = listingsList[i];
            if ([currentListing.listingID isEqualToString:current.listingID]) {
                rightButton.tag = i;
            }
        }
        
        [rightButton addTarget:self action:@selector(ListingView:) forControlEvents:UIControlEventTouchUpInside];
        
        annotationView.rightCalloutAccessoryView = rightButton;
    }
    annotationView.image = [UIImage imageNamed:@"map_marker.png"];
    
    annotationView.draggable = NO;
    //annotationView.highlighted = YES;
    //annotationView.animatesDrop = TRUE;
    //annotationView.canShowCallout = NO;
    
    if (annotation == mapViewAroundMe.userLocation) {
        return nil;
    }
    //MyPin.image = [UIImage imageNamed:@"Map-Marker-Marker-Outside-Azure-256.png"];
    //annotationView.annotation = annotation;
    
    return annotationView;
}


-(void)mapView:(MKMapView *)mapViewSelect didSelectAnnotationView:(MKPinAnnotationView *)view
{
    NSLog(@"didSelectAnnotationView");
    detailView.hidden = FALSE;
    view.pinColor = MKPinAnnotationColorGreen;
    view.image = [UIImage imageNamed:@"map_marker_green.png"];
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
    view.image = [UIImage imageNamed:@"map_marker.png"];
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
        segmentController.hidden = false;
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
        segmentController.hidden = TRUE;
        [UIView commitAnimations];
        [self setupMap];
        
    }
    
}

- (IBAction)segmentedButton:(id)sender {
    if (segmentController.selectedSegmentIndex == 0) {
        sortSel = 0;
        NSLog(@"Button1");
    }
    if (segmentController.selectedSegmentIndex == 1) {
        sortSel = 1;
        NSLog(@"Button2");
    }
    if (segmentController.selectedSegmentIndex == 2) {
        sortSel = 2;
        NSLog(@"Button3");
    }
    if (segmentController.selectedSegmentIndex == 3) {
        sortSel = 3;
        NSLog(@"Button4");
    }
    [tableView reloadData];
    
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