//
//  ListingString.h
//  Eric Test CTCCA Project
//
//  Created by CTCCA on 29/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ListingString : NSObject{
    
    // MAP properties    
    NSString *ListingName;
    NSString *Latitude;
    NSString *Longitude;
    
    // Identification Properties
    NSString *ListingID;
    NSString *ListingType;
    
    NSString *AreaID; // regionID
    NSString *Cost; //PriceID
    NSString *SubType; //subtype
    
    // Listing View Variables
    NSString *Address;
    NSString *Suburb;    //suburb
    NSString *Postcode;  //postcode
    NSString *StateID;   //stateID
    NSString *MajorRegionName;

    NSString *Details; 
    NSString *ImageURL; //ImageCluster
    NSString *VideoURL; //AudioVideoURL
    NSString *Website; //website
    NSString *Email; //email
    NSString *Phone; //phone
    NSString *OpeningHours;
    // Event Variable
    NSString *StartDay;
    NSString *StartMonth;
    NSString *StartYear;
    NSString *EndDay; 
    NSString *EndMonth; 
    NSString *EndYear; 
    
    NSString *StartMinute;
    NSString *StartHour;
    NSString *EndMinute;
    NSString *EndHour;
    
    
}


@property (nonatomic, copy) NSString *ListingName;
@property (nonatomic, copy) NSString *Latitude;
@property (nonatomic, copy) NSString *Longitude;

// Identification Properties
@property (nonatomic, copy) NSString *ListingID;
@property (nonatomic, copy) NSString *ListingType;
@property (nonatomic, copy) NSString *OpeningHours;

@property (nonatomic, copy) NSString *AreaID;
@property (nonatomic, copy) NSString *Cost;
@property (nonatomic, copy) NSString *SubType;

// Listing View Variables

@property (nonatomic, copy) NSString *Address;
@property (nonatomic, copy) NSString *MajorRegionName;
@property (nonatomic, copy) NSString *Suburb;    //suburb
@property (nonatomic, copy) NSString *Postcode;  //postcode
@property (nonatomic, copy) NSString *StateID;   //stateID

@property (nonatomic, copy) NSString *Details;
@property (nonatomic, copy) NSString *ImageURL;
@property (nonatomic, copy) NSString *VideoURL;
@property (nonatomic, copy) NSString *Website;
@property (nonatomic, copy) NSString *Phone;
@property (nonatomic, copy) NSString *Email;

// Event Variable
@property (nonatomic, copy) NSString *StartDay;
@property (nonatomic, copy) NSString *StartMonth; 
@property (nonatomic, copy) NSString *StartYear;
@property (nonatomic, copy) NSString *EndDay; 
@property (nonatomic, copy) NSString *EndMonth;
@property (nonatomic, copy) NSString *EndYear; 
@property (nonatomic, copy) NSString *StartMinute;
@property (nonatomic, copy) NSString *StartHour;
@property (nonatomic, copy) NSString *EndMinute;
@property (nonatomic, copy) NSString *EndHour;

@end
