//
//  BlabberStoryViewController.h
//  Eric Test CTCCA Project
//
//  Created by CTCCA on 25/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "News.h"
@interface BlabberStoryViewController : UIViewController{
    
    IBOutlet UILabel *newsTitle;
    IBOutlet UIView *loadView;
    IBOutlet UILabel *newsPublisher;
    IBOutlet UILabel *newsAuthor;
    IBOutlet UILabel *newsDate;
    IBOutlet UIImageView *newImage;
    IBOutlet UITextView *newsBody;
}
@property (strong, nonatomic)News  *currentListing;
@end
