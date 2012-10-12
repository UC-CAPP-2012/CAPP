//
//  Listing.h
//  Eric Test CTCCA Project
//
//  Created by CTCCA on 26/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKAnnotation.h>

@interface Listing : NSObject <MKAnnotation> {
    
    // MAP properties    
    NSString *title;
    CLLocationCoordinate2D coordinate;
    
    // Identification Properties
    NSString *listingID;
    NSString *listingType;
    
    NSString *areaID;
    NSString *costType;
    NSString *subType;
    
    // Listing View Variables
    NSString *address;
    NSString *description;
    NSArray *imageFilenames;
    NSURL *videoURL;
    NSURL *websiteURL;
    NSString *majorRegionName;
    NSString *phone;
    NSString *email;
    NSString *suburb;
    NSString *openingHours;
    
    // Event Variable
    NSDate *startDate;
    NSDate *endDate;
    
    
}

//Identification Properties
@property (nonatomic, copy) NSString *listingID;
@property (nonatomic, copy) NSString *listingType;

//Required for MAP annotations

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

// Sorts

//Name;
@property (nonatomic, copy) NSString *areaID;
@property (nonatomic, copy) NSString *costType; //Should probably be an NSArray of some sort.
@property (nonatomic, copy) NSString *subType;
@property (nonatomic, copy) NSString *suburb;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *openingHours;

//Required for Table View


//Required for ListingView
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *majorRegionName;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSArray *imageFilenames;
@property (nonatomic, copy) NSURL *videoURL;
@property (nonatomic, copy) NSURL *websiteURL;

//Required for Events

@property (nonatomic, copy) NSDate *startDate;
@property (nonatomic, copy) NSDate *endDate;

@end