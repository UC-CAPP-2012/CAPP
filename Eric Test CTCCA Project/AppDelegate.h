//
//  AppDelegate.h
//  Eric Test CTCCA Project
//
//  Created by CTCCA on 26/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic, strong)NSMutableArray *listingsList;
@property BOOL isLanscapeOk;
@property BOOL showHomeOverlay;
@end
