//
//  LocationString.h
//  Eric Test CTCCA Project
//
//  Created by Grace on 11/10/12.
//
//

#import <Foundation/Foundation.h>

@interface LocationString : NSObject{
    
    NSString *LocationID;
    NSString *TourID;
    NSString *TourSeqNum;
    NSString *LocationName;
    NSString *Latitude;
    NSString *Longitude;
    NSString *Address;
    NSString *Suburb;
    NSString *Postcode;
    
}

@property (nonatomic, copy) NSString *LocationID;
@property (nonatomic, copy) NSString *TourID;
@property (nonatomic, copy) NSString *TourSeqNum;
@property (nonatomic, copy) NSString *LocationName;
@property (nonatomic, copy) NSString *Latitude;
@property (nonatomic, copy) NSString *Longitude;
@property (nonatomic, copy) NSString *Address;
@property (nonatomic, copy) NSString *Suburb;
@property (nonatomic, copy) NSString *Postcode;

@end
