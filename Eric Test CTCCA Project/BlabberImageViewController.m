//
//  BlabberImageViewController.m
//  Eric Test CTCCA Project
//
//  Created by CTCCA on 8/10/12.
//
//

#import "BlabberImageViewController.h"
#import "AppDelegate.h"
@interface BlabberImageViewController ()

@end

@implementation BlabberImageViewController
@synthesize selectedImage;
@synthesize newsTitle;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) viewDidAppear:(BOOL)animated{
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:selectedImage]];
    imageView.image = image;
    //[scrollView setContentSize:image.size];
    [scrollView setMaximumZoomScale:2.5f];
    [scrollView setMinimumZoomScale:1.0f];
    loadView.hidden=TRUE;
}

- (UIView*)viewForZoomingInScrollView: (UIScrollView*)scrollView{
    return imageView;
}

-(void)viewDidDisappear:(BOOL)animated{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.isLanscapeOk = NO;
}

- (void)viewDidLoad
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.isLanscapeOk = YES;
    
    [super setTitle:newsTitle];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
