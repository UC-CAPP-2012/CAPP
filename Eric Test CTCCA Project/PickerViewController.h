//
//  PickerViewController.h
//  Eric Test CTCCA Project
//
//  Created by CTCCA on 4/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListingString.h"
#import "Listing.h"
#import "ListingViewController.h"
#define subtype 0
#define area 1
#define cost 2

@interface PickerViewController : UIViewController <NSXMLParserDelegate, UIPickerViewDataSource, UIPickerViewDelegate>{

    IBOutlet UIButton *feelingAdv;
    IBOutlet UIView *loadView;
    
    IBOutlet UIPickerView *spinWheel;
    NSMutableArray *SubType;
    NSMutableArray *Area;
    NSMutableArray *Cost;
    NSString *selectedCategory;
    NSString *selectedSuburb;
    NSString *selectedCost;
    IBOutlet UIImageView *lockCategory;
    IBOutlet UIImageView *lockSuburb;
    IBOutlet UIImageView *lockCost;
    IBOutlet UIButton *resultButton;
    ListingString *theList;
    NSMutableString *currentElementValue;
    IBOutlet UIView *resultButtonView;
    Listing *result;
}
- (IBAction)lockUnlockCategory:(id)sender;
- (IBAction)lockUnlockSuburb:(id)sender;
- (IBAction)lockUnlockCost:(id)sender;

@property(nonatomic, strong) NSMutableArray *listingsList, *listingsListString;

-(IBAction)feelingAdventurous:(id)sender;
- (IBAction)goToListing:(id)sender;
-(void)spin;
@property BOOL categoryLocked;
@property BOOL suburbLocked;
@property BOOL costLocked;
@end
