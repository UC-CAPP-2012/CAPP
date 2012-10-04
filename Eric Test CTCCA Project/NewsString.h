//
//  NewsString.h
//  Eric Test CTCCA Project
//
//  Created by Hassna Alqarni on 4/10/12.
//
//

#import <Foundation/Foundation.h>

@interface NewsString : NSObject{

    NSString *NewsID;
    NSString *NewsHeading;
    NSString *NewsDateTime;
    NSString *NewsBody;
    NSString *NewsMediaURL;
    NSString *NewsPublisher;
    NSString *NewsAuthor;
}

@property (nonatomic, copy) NSString *NewsID;
@property (nonatomic, copy) NSString *NewsHeading;
@property (nonatomic, copy) NSString *NewsDateTime;
@property (nonatomic, copy) NSString *NewsBody;
@property (nonatomic, copy) NSString *NewsMediaURL;
@property (nonatomic, copy) NSString *NewsPublisher;
@property (nonatomic, copy) NSString *NewsAuthor;

@end
