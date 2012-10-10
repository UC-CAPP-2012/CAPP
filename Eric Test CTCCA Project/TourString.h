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
    NSString *TourDetail;
    NSString *TourCost;
    NSString *TourPhone;
    NSString *TourWebsite;
    NSString *TourEmail;
    NSString *ImageFileNames;
    NSString *VideoURL;
}


@property (nonatomic, copy) NSString *TourID;
@property (nonatomic, copy) NSString *TourName;
@property (nonatomic, copy) NSString *TourDetail;
@property (nonatomic, copy) NSString *TourCost;
@property (nonatomic, copy) NSString *TourPhone;
@property (nonatomic, copy) NSString *TourWebsite;
@property (nonatomic, copy) NSString *TourEmail;
@property (nonatomic, copy) NSString *ImageFileNames;
@property (nonatomic, copy) NSString *VideoURL;
@end
