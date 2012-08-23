//
//  MainTypeClass.h
//  Eric Test CTCCA Project
//
//  Created by CTCCA on 25/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MainTypeClass : NSObject {

    // Main Class Properties    
    NSString *typeID;
    NSString *typeName;
    UIImage *image;
}
@property (nonatomic, copy) NSString *typeID;
@property (nonatomic, copy) NSString *typeName;
@property (nonatomic, copy) UIImage *imageID;

@end;

