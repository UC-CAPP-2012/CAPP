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
    
    IBOutlet UIView *notFoundView;
    IBOutlet UIView *loadView;
    IBOutlet UIButton *catLock;
    IBOutlet UIButton *regionLock;
    IBOutlet UIButton *priceLock;
    
    IBOutlet UIButton *feelAdvBtn;
    IBOutlet UIPickerView *spinWheel;
    NSMutableArray *SubType;
    NSMutableArray *Area;
    NSMutableArray *Cost;
    
    NSMutableArray *CostArray;
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
- (IBAction)removeOverlay:(id)sender;

- (IBAction)feelingAdv:(id)sender;

-(void)feelingAdventurous;
- (IBAction)goToListing:(id)sender;
-(void)spin;
@property BOOL categoryLocked;
@property BOOL suburbLocked;
@property BOOL costLocked;
@property BOOL spinned;
@property BOOL alert;
@end
