//
//  AreaClass.h
//  Eric Test CTCCA Project
//
//  Created by CTCCA on 26/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKAnnotation.h>

@interface AreaClass : NSObject {
    
    // Main Class Properties    
    NSString *areaID;
    NSString *areaName;
    CLLocationCoordinate2D areaCoordinate;

    float spanLat;
    float spanLong;
}
@property (nonatomic, copy) NSString *areaID;
@property (nonatomic, copy) NSString *areaName;
@property (nonatomic, assign) CLLocationCoordinate2D areaCoordinate;
@property float spanLat;
@property float spanLong;

@end;