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
    NSString *Subtitle;
    NSString *Latitude;
    NSString *Longitude;
    
    // Identification Properties
    NSString *ListingID;
    NSString *ListingType;
    
    NSString *AreaID; // regionID
    NSString *CostType; //PriceID
    NSString *RatingType; //rating
    NSString *SubType; //subtype
    
    // Listing View Variables
    NSString *UnitNumber; //unitnumber
    NSString *StreetName; //streetname
    NSString *StreetType; //streettype
    NSString *Suburb;    //suburb
    NSString *Postcode;  //postcode
    NSString *StateID;   //stateID
    
    NSString *Details; // Made from other properties - Email / Website Telephone.
    NSString *Description; 
    NSString *Review; 
    NSString *ImageURL; //ImageCluster
    NSString *VideoURL; //AudioVideoURL
    NSString *WebsiteURL; //website
    NSString *Email; //email
    
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
@property (nonatomic, copy) NSString *Subtitle;
@property (nonatomic, copy) NSString *Latitude;
@property (nonatomic, copy) NSString *Longitude;

// Identification Properties
@property (nonatomic, copy) NSString *ListingID;
@property (nonatomic, copy) NSString *ListingType;

@property (nonatomic, copy) NSString *AreaID;
@property (nonatomic, copy) NSString *CostType;
@property (nonatomic, copy) NSString *RatingType;
@property (nonatomic, copy) NSString *SubType;

// Listing View Variables

@property (nonatomic, copy) NSString *UnitNumber; //unitnumber
@property (nonatomic, copy) NSString *StreetName; //streetname
@property (nonatomic, copy) NSString *StreetType; //streettype
@property (nonatomic, copy) NSString *Suburb;    //suburb
@property (nonatomic, copy) NSString *Postcode;  //postcode
@property (nonatomic, copy) NSString *StateID;   //stateID

@property (nonatomic, copy) NSString *Details;
@property (nonatomic, copy) NSString *Description;
@property (nonatomic, copy) NSString *Review;
@property (nonatomic, copy) NSString *ImageURL;
@property (nonatomic, copy) NSString *VideoURL;
@property (nonatomic, copy) NSString *WebsiteURL;

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
