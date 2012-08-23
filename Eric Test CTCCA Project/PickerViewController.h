//
//  PickerViewController.h
//  Eric Test CTCCA Project
//
//  Created by CTCCA on 4/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListingString.h"
#define subtype 0
#define area 1
#define cost 2

@interface PickerViewController : UIViewController <NSXMLParserDelegate, UIPickerViewDataSource, UIPickerViewDelegate>{

    IBOutlet UIPickerView *spinWheel;
    NSMutableArray *SubType;
    NSMutableArray *Area;
    NSMutableArray *Cost;
    
    ListingString *theList;
    NSMutableString *currentElementValue;
    
}

@property(nonatomic, strong) NSMutableArray *listingsList, *listingsListString;

-(IBAction)feelingAdventurous:(id)sender;

@end
