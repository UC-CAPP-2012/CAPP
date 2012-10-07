//
//  BlabberImageViewController.h
//  Eric Test CTCCA Project
//
//  Created by CTCCA on 8/10/12.
//
//

#import <UIKit/UIKit.h>

@interface BlabberImageViewController : UIViewController{
    
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIImageView *imageView;
    IBOutlet UIView *loadView;
}

@property (strong, nonatomic)NSURL  *selectedImage;
@property (strong, nonatomic)NSString  *title;
@end
