//
//  FavoritesViewController.m
//  Eric Test CTCCA Project
//
//  Created by CTCCA on 30/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FavoritesViewController.h"
#import "GenerateFavoritesString.h"

@interface FavoritesViewController ()

@end

@implementation FavoritesViewController

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
    [super setTitle:@"Loved"];
    NSMutableString *stringName = [GenerateFavoritesString createFavoriteString];
    NSLog(@"%@",stringName);
    [super viewDidLoad];
    //Creating a file path under iPhone OS:
    //1) Search for the app's documents directory (copy+paste from Documentation)
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    //2) Create the full file path by appending the desired file name
    NSString *yourArrayFileName = [documentsDirectory stringByAppendingPathComponent:@"example.dat"];
    
    //Load the array
    favData = [[NSMutableArray alloc] initWithContentsOfFile: yourArrayFileName];
    
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
- (UITableViewCellEditingStyle)tableView:(UITableView*)tableView 
           editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath {
    return UITableViewCellEditingStyleDelete;
}
//Displays the delete button and deletes the row and the entry in the favorites array
- (void)tableView:(UITableView*)tableViewEdit commitEditingStyle:(UITableViewCellEditingStyle)style 
forRowAtIndexPath:(NSIndexPath*)indexPath {
    
    // delete your data for this row from here
    
    //Creating a file path under iPhone OS:
    //1) Search for the app's documents directory (copy+paste from Documentation)
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    //2) Create the full file path by appending the desired file name
    NSString *yourArrayFileName = [documentsDirectory stringByAppendingPathComponent:@"example.dat"];
    favData = [[NSMutableArray alloc] initWithContentsOfFile: yourArrayFileName];
    [favData removeObjectAtIndex:indexPath.row];
    [favData writeToFile:yourArrayFileName atomically:YES];
    [tableViewEdit reloadData];
}
//--------------------------------------------------------------------------------------------------//



// Return number of sections in table (always 1 for this demo!)
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// Return the amount of items in our table (the total items in our array above)
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [favData count];
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
    
    // Get the cell label using its tag and set it
    UILabel *cellLabel = (UILabel *)[cell viewWithTag:1];
    [cellLabel setText:[favData objectAtIndex:indexPath.row]];
    
    
    return cell;
}

@end