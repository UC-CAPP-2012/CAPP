//
//  TourString.h
//  Eric Test CTCCA Project
//
//  Created by Grace on 11/10/12.
//
//

#import <Foundation/Foundation.h>

@interface TourString : NSObject{
    NSString *TourID;
    NSString *TourName;
    NSString *TourDetails;
    NSString *TourCost;
    NSString *TourPhone;
    NSString *TourWebsite;
    NSString *TourEmail;
    NSString *ImageURL;
    NSString *VideoURL;
    NSString *AudioURL;
    NSString *TourAgent;
}


@property (nonatomic, copy) NSString *TourID;
@property (nonatomic, copy) NSString *TourName;
@property (nonatomic, copy) NSString *TourDetails;
@property (nonatomic, copy) NSString *TourCost;
@property (nonatomic, copy) NSString *TourPhone;
@property (nonatomic, copy) NSString *TourWebsite;
@property (nonatomic, copy) NSString *TourEmail;
@property (nonatomic, copy) NSString *ImageURL;
@property (nonatomic, copy) NSString *VideoURL;
@property (nonatomic, copy) NSString *AudioURL;
@property (nonatomic, copy) NSString *TourAgent;
@end
