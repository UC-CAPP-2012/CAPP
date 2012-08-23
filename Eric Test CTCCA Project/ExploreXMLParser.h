//
//  ExploreXMLParser.h
//  Eric Test CTCCA Project
//
//  Created by CTCCA on 1/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainTypeClass.h"

@interface ExploreXMLParser : NSObject <NSXMLParserDelegate>{

    NSXMLParser *parser;
    NSMutableArray *sortTypes;
    MainTypeClass *sortType;
    NSMutableString *currentElementValue;
    
    
}

@property (readonly, retain) NSMutableArray *sortTypes;
@property (readonly, retain) MainTypeClass *sortType;
-(id)loadXMLByURL:(NSString *)urlString;

@end
