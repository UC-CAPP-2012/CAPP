//
//  RootViewController.h
//  SideSwipeTableView
//
//  Created by Peter Boctor on 4/13/11.
//  Copyright 2011 Peter Boctor. All rights reserved.
//

#import "ExploreFilterViewController.h"
#import "EventFilterViewController.h"

@interface RootViewController : ExploreFilterViewController
{
  NSArray* buttonData;
  NSMutableArray* buttons;
}

@end
