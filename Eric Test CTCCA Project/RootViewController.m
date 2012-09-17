//
//  RootViewController.m
//  SideSwipeTableView
//
//  Created by Peter Boctor on 4/13/11.
//  Copyright 2011 Peter Boctor. All rights reserved.
//

#import "RootViewController.h"
#import "SideSwipeTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

#define BUTTON_LEFT_MARGIN 10.0
#define BUTTON_SPACING 25.0

@interface RootViewController (PrivateStuff)
-(void) setupSideSwipeView;
-(UIImage*) imageFilledWith:(UIColor*)color using:(UIImage*)startImage;
@end

@implementation RootViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  // Setup the title and image for each button within the side swipe view

  self.sideSwipeView = [[UIView alloc] initWithFrame:CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y, tableView.frame.size.width, tableView.rowHeight)];
  [self setupSideSwipeView];
}

- (void) setupSideSwipeView
{
  // Add the background pattern
  self.sideSwipeView.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"dotted-pattern.png"]];

  // Overlay a shadow image that adds a subtle darker drop shadow around the edges
  UIImage* shadow = [[UIImage imageNamed:@"inner-shadow.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
  UIImageView* shadowImageView = [[UIImageView alloc] initWithFrame:sideSwipeView.frame];
  shadowImageView.alpha = 0.6;
  shadowImageView.image = shadow;
  shadowImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    UIImage* imageheart = [UIImage imageNamed:@"TabHeartIt.png"];
    UIImage* imagetrail = [UIImage imageNamed:@"ToursAdd.png"];
    
    //cell.textLabel.text = cellValue;
    //cell.imageView.image = image;
    
    //ContentView
    
    CGRect Button1Frame = CGRectMake(250, 20, 20, 20);
    
    UIButton *btnTemp;
    
    btnTemp =[[UIButton alloc] initWithFrame:Button1Frame];
    [btnTemp setImage:imageheart forState:UIControlStateNormal];
    [self.sideSwipeView addSubview:btnTemp];
    
    //Accessory View
    CGRect Button2Frame = CGRectMake(0, 0, 20, 20);    
    UIButton *btnTemp2;
    
    btnTemp2 =[[UIButton alloc] initWithFrame:Button2Frame];
    [btnTemp2 setImage:imagetrail forState:UIControlStateNormal];
    // Add the button to the side swipe view
    [self.sideSwipeView addSubview:btnTemp2];
  [self.sideSwipeView addSubview:shadowImageView];
  
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 10;
}


#pragma mark Button touch up inside action
- (IBAction) touchUpInsideAction:(UIButton*)button
{
  NSIndexPath* indexPath = [tableView indexPathForCell:sideSwipeCell];
  
  NSUInteger index = [buttons indexOfObject:button];
  NSDictionary* buttonInfo = [buttonData objectAtIndex:index];
  [[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat: @"%@ on cell %d", [buttonInfo objectForKey:@"title"], indexPath.row]
                               message:nil
                              delegate:nil
                     cancelButtonTitle:nil
                     otherButtonTitles:@"OK", nil] show];
  
  [self removeSideSwipeView:YES];
}

#pragma mark Generate images with given fill color
// Convert the image's fill color to the passed in color
-(UIImage*) imageFilledWith:(UIColor*)color using:(UIImage*)startImage
{
  // Create the proper sized rect
  CGRect imageRect = CGRectMake(0, 0, CGImageGetWidth(startImage.CGImage), CGImageGetHeight(startImage.CGImage));

  // Create a new bitmap context
  CGContextRef context = CGBitmapContextCreate(NULL, imageRect.size.width, imageRect.size.height, 8, 0, CGImageGetColorSpace(startImage.CGImage), kCGImageAlphaPremultipliedLast);

  // Use the passed in image as a clipping mask
  CGContextClipToMask(context, imageRect, startImage.CGImage);
  // Set the fill color
  CGContextSetFillColorWithColor(context, color.CGColor);
  // Fill with color
  CGContextFillRect(context, imageRect);

  // Generate a new image
  CGImageRef newCGImage = CGBitmapContextCreateImage(context);
  UIImage* newImage = [UIImage imageWithCGImage:newCGImage scale:startImage.scale orientation:startImage.imageOrientation];

  // Cleanup
  CGContextRelease(context);
  CGImageRelease(newCGImage);
  
  return newImage;
}


@end