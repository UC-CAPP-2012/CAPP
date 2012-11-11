//
//  Subscribe.h
//  Eric Test CTCCA Project
//
//  Created by CTCCA on 30/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuartzCore/CALayer.h"
#import "ListingString.h"
#import "Listing.h"
@interface Subscribe : UIViewController<NSXMLParserDelegate>
{
    
    NSTimer *ActivityTimer;
    
    IBOutlet UILabel *errorMsg;
    IBOutlet UIPageControl *pageControl;
    BOOL pageControlBeingUsed;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIView *splash;
    IBOutlet UIView *loadView;
    ListingString *theList;
    NSMutableString *currentElementValue;
}
- (IBAction)changePage:(id)sender;
@property(nonatomic, strong)NSMutableArray *listingsListString,*listingsList;
@property(nonatomic, strong)NSMutableArray *typeDataSource;

@property (strong, nonatomic) IBOutlet UIScrollView *SubscribeScrollView;

@property (strong, nonatomic) IBOutlet UISwitch *SubscribeYesNo;

@property (strong, nonatomic) IBOutlet UITextField *PostCodeTextField;

@property (strong, nonatomic) IBOutlet UITextField *EmailTextField;

@property (strong, nonatomic) IBOutlet UITextField *NickNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *LastNameTextField;

-(IBAction)Subscribe:(id)sender;

- (IBAction)DismissKeyboard:(id)sender;
-(void)setupArray;
@end

