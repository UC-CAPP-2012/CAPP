//
//  SaveToFavorites.m
//  Eric Test CTCCA Project
//
//  Created by CTCCA on 30/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SaveToFavorites.h"

@implementation SaveToFavorites

+(void) saveToFavorites:(NSString*)listingName
{
    //Creating a file path under iPhone OS:
    //1) Search for the app's documents directory (copy+paste from Documentation)
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = paths[0];
    
    //2) Create the full file path by appending the desired file name
    NSString *yourArrayFileName = [documentsDirectory stringByAppendingPathComponent:@"example.dat"];
    
    //Load the array
    NSMutableArray *yourArray = [[NSMutableArray alloc] initWithContentsOfFile: yourArrayFileName];
    if(yourArray == nil)
    {
        //Array file didn't exist... create a new one
        yourArray = [[NSMutableArray alloc] initWithCapacity:20];
    }
    if (![yourArray containsObject:listingName]) {
        [yourArray addObject:listingName];
        //Save the array
        [yourArray writeToFile:yourArrayFileName atomically:YES];
    }
    
}

@end
