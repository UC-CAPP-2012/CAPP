//
//  GenerateFavoritesString.m
//  Eric Test CTCCA Project
//
//  Created by CTCCA on 30/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GenerateFavoritesString.h"

@implementation GenerateFavoritesString

+(NSMutableString *)createFavoriteString
{
    NSUInteger i = 0;
    //Creating a file path under iPhone OS:
    //1) Search for the app's documents directory (copy+paste from Documentation)
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    //2) Create the full file path by appending the desired file name
    NSString *yourArrayFileName = [documentsDirectory stringByAppendingPathComponent:@"example.dat"];
    
    //Load the array
    NSMutableArray *yourArray = [[NSMutableArray alloc] initWithContentsOfFile: yourArrayFileName];
    //NSUInteger count = [yourArray count];
    if(yourArray != nil)
    {
        NSMutableString *favString = [NSMutableString stringWithString:@""];
        //for(i=0;i<[yourArray count];i++)
        //{
        for (NSMutableString *element in yourArray)
        {
            if(i != [yourArray count]-1)
            {
                [favString appendString: [NSString stringWithFormat:@"%@,",element]];
                i++;
            }
            else
            {
                [favString appendString: [NSString stringWithFormat:@"%@",element]];   
            }                     
            //}
            
        }
        return favString;
    }
    else {
        return NULL;
    }
    
}

@end
