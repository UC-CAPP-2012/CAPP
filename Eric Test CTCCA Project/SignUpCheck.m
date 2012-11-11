//
//  SignUpCheck.m
//  Eric Test CTCCA Project
//
//  Created by CTCCA on 30/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SignUpCheck.h"

@implementation SignUpCheck

+(BOOL)checkForSugnup{
    NSString *signup = @"signup";
    //Creating a file path under iPhone OS:
    //1) Search for the app's documents directory (copy+paste from Documentation)
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    //2) Create the full file path by appending the desired file name
    NSString *yourArrayFileName = [documentsDirectory stringByAppendingPathComponent:@"signup.dat"];
    
    //Load the array
    NSMutableArray *yourArray = [[NSMutableArray alloc] initWithContentsOfFile: yourArrayFileName];
    if(yourArray == nil)
    {
        //Array file didn't exist... create a new one
        yourArray = [[NSMutableArray alloc] initWithCapacity:20];
    }
    
    if ([yourArray containsObject:signup])
    {
        return YES;
    }
    else {
        return NO;
    }
    
}

+(BOOL)checkForSpinwheelOverlay{
    NSString *spinwheel = @"spinwheel";
    //Creating a file path under iPhone OS:
    //1) Search for the app's documents directory (copy+paste from Documentation)
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    //2) Create the full file path by appending the desired file name
    NSString *yourArrayFileName = [documentsDirectory stringByAppendingPathComponent:@"spinwheel.dat"];
    
    //Load the array
    NSMutableArray *yourArray = [[NSMutableArray alloc] initWithContentsOfFile: yourArrayFileName];
    if(yourArray == nil)
    {
        //Array file didn't exist... create a new one
        yourArray = [[NSMutableArray alloc] initWithCapacity:20];
    }
    
    if ([yourArray containsObject:spinwheel])
    {
        return YES;
    }
    else {
        return NO;
    }
    
}


@end
