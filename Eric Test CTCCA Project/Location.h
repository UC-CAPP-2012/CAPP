//
//  Location.h
//  Eric Test CTCCA Project
//
//  Created by Grace on 11/10/12.
//
//

#import <Foundation/Foundation.h>

@interface Location : NSObject{

    NSString *LocationID;
    NSString *TourID;
    int TourSeqNum;
    NSString *LocationName;
    float Latitude;
    float Longitude;
    NSString *Address;
    NSString *Suburb;
    int Postcode;
    
}

@property (nonatomic, copy) NSString *LocationID;
@property (nonatomic, copy) NSString *TourID;
@property int TourSeqNum;
@property (nonatomic, copy) NSString *LocationName;
@property float Latitude;
@property float Longitude;
@property (nonatomic, copy) NSString *Address;
@property (nonatomic, copy) NSString *Suburb;
@property int Postcode;

@end

