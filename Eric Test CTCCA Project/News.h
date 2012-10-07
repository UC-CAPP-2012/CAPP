//
//  News.h
//  Eric Test CTCCA Project
//
//  Created by Hassna Alqarni on 4/10/12.
//
//

#import <Foundation/Foundation.h>

@interface News : NSObject{

    NSString *NewsID;
    NSString *NewsHeading;
    NSString *NewsDateTime;
    NSString *NewsBody;
    NSURL *NewsMediaURL;
    NSString *NewsPublisher;
    NSString *NewsAuthor;
    UIImage *NewsIcon;
}

@property (nonatomic, copy) NSString *NewsID;
@property (nonatomic, copy) NSString *NewsHeading;
@property (nonatomic, copy) NSString *NewsDateTime; //Should probably be an NSArray of some sort.
@property (nonatomic, copy) NSString *NewsBody;
@property (nonatomic, copy) NSURL *NewsMediaURL;
@property (nonatomic, copy) NSString *NewsPublisher;
@property (nonatomic, copy) NSString *NewsAuthor;
@property (nonatomic, copy) UIImage *NewsIcon;

@end
