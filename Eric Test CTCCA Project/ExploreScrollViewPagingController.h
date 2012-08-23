//
//  ScrollViewPagingExampleViewController.h
//  ScrollViewPagingExample
//
//  Created by Alexander Repty on 12.02.10.
//  Copyright Enough Software 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuartzCore/CALayer.h"
#import "ExploreFilterViewController.h"

@interface ExploreScrollViewPagingController : UIViewController <UIScrollViewDelegate>{
    IBOutlet UIScrollView	*scrollView;
    IBOutlet UIPageControl *pageControl;
    IBOutlet UIView *loadView;
}
@property(nonatomic)NSMutableArray *typeDataSource;


-(IBAction)changePage;

@end

