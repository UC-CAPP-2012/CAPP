//
//  AreaXMLParser.h
//  Eric Test CTCCA Project
//
//  Created by CTCCA on 2/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AreaClassString.h"

@interface AreaXMLParser : NSObject <NSXMLParserDelegate>{
    
    NSXMLParser *parser;
    NSMutableArray *areaTypes;
    AreaClassString *areaType;
    NSMutableString *currentElementValue;
    
    
}

@property (readonly, retain) NSMutableArray *areaTypes;
@property (readonly, retain) AreaClassString *areaType;
-(id)loadXMLByURL:(NSString *)urlString;

@end

