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
    NSString *ItemName;
    NSString *Latitude;
    NSString *Longitude;
    
    // Identification Properties
    NSString *ItemID;
    NSString *ListingType;
    
    NSString *AreaID; // regionID
    NSString *Cost; //PriceID
    NSString *SubtypeName; //subtype
    
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
    NSString *StartDate;
    NSString *EndDate;
    NSString *AudioURL;
    
}


@property (nonatomic, copy) NSString *ItemName;
@property (nonatomic, copy) NSString *Latitude;
@property (nonatomic, copy) NSString *Longitude;

// Identification Properties
@property (nonatomic, copy) NSString *ItemID;
@property (nonatomic, copy) NSString *ListingType;
@property (nonatomic, copy) NSString *OpeningHours;

@property (nonatomic, copy) NSString *AreaID;
@property (nonatomic, copy) NSString *Cost;
@property (nonatomic, copy) NSString *SubtypeName;

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
@property (nonatomic, copy) NSString *StartDate;
@property (nonatomic, copy) NSString *EndDate;
@property (nonatomic, copy) NSString *AudioURL;
@end
