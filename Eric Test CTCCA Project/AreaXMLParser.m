//
//  AreaXMLParser.m
//  Eric Test CTCCA Project
//
//  Created by CTCCA on 2/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AreaXMLParser.h"
#import "AreaClassString.h"

@implementation AreaXMLParser
@synthesize areaTypes, areaType;

-(id) loadXMLByURL:(NSString *)urlString
{
    areaTypes = [[NSMutableArray alloc] init];
    areaType = [[AreaClassString alloc] init];
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
        areaTypes = [[NSMutableArray alloc] init];
    }
    else if ([elementName isEqualToString:@"ListingElement"])
    {
        areaType = [[AreaClassString alloc] init];
        areaType.areaID = [attributeDict[@"listingID"] stringValue];
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
        [areaTypes addObject:areaType];
        areaType = nil;
    }
    else 
    {
        [areaType setValue:currentElementValue forKey:elementName];
        NSLog(@"%@",currentElementValue);
        currentElementValue = nil;
    }
}

@end
