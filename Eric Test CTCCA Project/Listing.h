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
    NSString *subtitle;
    CLLocationCoordinate2D coordinate;
    
    // Identification Properties
    NSString *listingID;
    NSString *listingType;
    
    NSString *areaID;
    NSString *costType;
    NSString *ratingType;
    NSString *subType;
    
    // Listing View Variables
    NSString *address;
    NSString *details;
    NSString *description;
    NSString *review;
    NSArray *imageFilenames;
    NSURL *videoURL;
    NSURL *websiteURL;
    
    // Event Variable
    NSDate *startDate;
    NSDate *endDate;
    
    
}

//Identification Properties
@property (nonatomic, copy) NSString *listingID;
@property (nonatomic, copy) NSString *listingType;

//Required for MAP annotations

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

// Sorts

//Name;
@property (nonatomic, copy) NSString *areaID;
@property (nonatomic, copy) NSString *costType; //Should probably be an NSArray of some sort.
@property (nonatomic, copy) NSString *ratingType;
@property (nonatomic, copy) NSString *subType;

//Required for Table View


//Required for ListingView
@property (nonatomic) NSString *address;
@property (nonatomic, copy) NSString *details;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSString *review;
@property (nonatomic, copy) NSArray *imageFilenames;
@property (nonatomic, copy) NSURL *videoURL;
@property (nonatomic, copy) NSURL *websiteURL;

//Required for Events

@property (nonatomic, copy) NSDate *startDate;
@property (nonatomic, copy) NSDate *endDate;

@end