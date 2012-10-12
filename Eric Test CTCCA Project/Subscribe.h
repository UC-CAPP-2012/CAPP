//
//  Subscribe.h
//  Eric Test CTCCA Project
//
//  Created by CTCCA on 30/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Subscribe : UIViewController
{
    
    NSTimer *ActivityTimer;
    IBOutlet UIImageView *spashScreen;
    IBOutlet UILabel *errorMsg;
    
    IBOutlet UIView *loadView;
}


@property (strong, nonatomic) IBOutlet UIScrollView *SubscribeScrollView;

@property (strong, nonatomic) IBOutlet UISwitch *SubscribeYesNo;

@property (strong, nonatomic) IBOutlet UITextField *PostCodeTextField;

@property (strong, nonatomic) IBOutlet UITextField *EmailTextField;

@property (strong, nonatomic) IBOutlet UITextField *NickNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *LastNameTextField;

-(IBAction)Subscribe:(id)sender;

- (IBAction)DismissKeyboard:(id)sender;

@end

