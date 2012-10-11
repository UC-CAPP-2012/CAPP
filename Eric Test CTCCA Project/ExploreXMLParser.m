//
//  ExploreXMLParser.m
//  Eric Test CTCCA Project
//
//  Created by CTCCA on 1/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ExploreXMLParser.h"
#import "MainTypeClass.h"

@implementation ExploreXMLParser
@synthesize sortTypes, sortType;

-(id) loadXMLByURL:(NSString *)urlString
{
    sortTypes = [[NSMutableArray alloc] init];
    sortType = [[MainTypeClass alloc] init];
    NSURL *url =[NSURL URLWithString:urlString];
    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
    parser = [[NSXMLParser alloc] initWithData:data];
    parser.delegate = self;
    [parser parse];
    return self;
}


// --- XML Delegate Classes ----

-(void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"ListingElements"])  // Change this to match the header of the sorter. 
    {
        sortTypes = [[NSMutableArray alloc] init];
    }
    else if ([elementName isEqualToString:@"ListingElement"])
    {
        sortType = [[MainTypeClass alloc] init];
        sortType.typeID = [attributeDict[@"listingID"] stringValue];
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
        [sortTypes addObject:sortType];
        sortType = nil;
    }
    else 
    {
        [sortType setValue:currentElementValue forKey:elementName];
        NSLog(@"%@",currentElementValue);
        currentElementValue = nil;
    }
}


@end
