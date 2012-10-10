//
//  Tour.h
//  Eric Test CTCCA Project
//
//  Created by Grace on 11/10/12.
//
//

#import <Foundation/Foundation.h>

@interface Tour : NSObject{
    NSString *TourID;
    NSString *TourName;
    NSString *TourDetail;
    NSString *TourCost;
    NSString *TourPhone;
    NSURL *TourWebsite;
    NSString *TourEmail;
    NSArray *ImageFileNames;
    NSURL *VideoURL;
}


@property (nonatomic, copy) NSString *TourID;
@property (nonatomic, copy) NSString *TourName;
@property (nonatomic, copy) NSString *TourDetail;
@property (nonatomic, copy) NSString *TourCost;
@property (nonatomic, copy) NSString *TourPhone;
@property (nonatomic, copy) NSURL *TourWebsite;
@property (nonatomic, copy) NSString *TourEmail;
@property (nonatomic, copy) NSArray *ImageFileNames;
@property (nonatomic, copy) NSURL *VideoURL;

@end
