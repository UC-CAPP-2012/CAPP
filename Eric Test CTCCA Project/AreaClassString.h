//
//  AreaClassString.h
//  Eric Test CTCCA Project
//
//  Created by CTCCA on 2/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AreaClassString : NSObject {


// Main Class Properties    
NSString *areaID;
NSString *areaName;    
NSString *latitutude;
NSString *longtitude;
NSString *spanLat;
NSString *spanLong;
}
@property (nonatomic, copy) NSString *areaID;
@property (nonatomic, copy) NSString *areaName;
@property (nonatomic, copy) NSString *latitutude;
@property (nonatomic, copy) NSString *longtitude;
@property (nonatomic, copy) NSString *spanLat;
@property (nonatomic, copy) NSString *spanLong;

@end;

