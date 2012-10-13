//
//  os4MapsAppDelegate.h
//  os4Maps
//
//  Created by Craig Spitzkoff on 7/4/10.
//  Copyright Craig Spitzkoff 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TourRoutesViewController;

@interface os4MapsAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    TourRoutesViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet TourRoutesViewController *viewController;

@end

