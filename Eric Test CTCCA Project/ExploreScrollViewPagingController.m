//
//  ScrollViewPagingExampleViewController.m
//  ScrollViewPagingExample
//
//  Created by Alexander Repty on 12.02.10.
//  Copyright Enough Software 2010. All rights reserved.
//

// Need to figure out the CGRectMakeOffSet CGFloat Y meaning. 50 Just seems to work to align the clickable area with the button.


#import "ExploreScrollViewPagingController.h"
#import "MainTypeClass.h"

@implementation ExploreScrollViewPagingController
@synthesize typeDataSource;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [self setupArray]; //Listings
    loadView.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    pageControlBeingUsed = NO;
    
    self.title = @"Explore";
    //ARRAY FROM DB
    
}

-(void)setupArray
{
    typeDataSource = [[NSMutableArray alloc] init];
    
    MainTypeClass *type = [[MainTypeClass alloc] init]; // I Think the leak is here..
    type.typeID = @"1";
    type.typeName = @"Entertainment";
    type.imageID = [UIImage imageNamed:@"Entertainment_Large.png"];
    [typeDataSource addObject:type];
    
    MainTypeClass *type2 = [[MainTypeClass alloc] init];
    type2.typeID = @"2";
    type2.typeName = @"Accommodation";
    type2.imageID = [UIImage imageNamed:@"Accommodation_Large.png"];
    [typeDataSource addObject:type2];
    
    MainTypeClass *type3 = [[MainTypeClass alloc] init];
    type3.typeID = @"3";
    type3.typeName = @"Sport";
    type3.imageID = [UIImage imageNamed:@"Sport_Large.png"];
    [typeDataSource addObject:type3];
    
    MainTypeClass *type4 = [[MainTypeClass alloc] init];
    type4.typeID = @"4";
    type4.typeName = @"Outdoor and Nature";
    type4.imageID = [UIImage imageNamed:@"Outdoor_Large.png"];
    [typeDataSource addObject:type4];
    
    //MainTypeClass *type5 = [[MainTypeClass alloc] init];
    //type5.typeID = @"5";
    //type5.typeName = @"Events";
    //type5.imageID = [UIImage imageNamed:@"sgaw.jpg"];
    //[typeDataSource addObject:type5];
    
    MainTypeClass *type6 = [[MainTypeClass alloc] init];
    type6.typeID = @"6";
    type6.typeName = @"Family Fun";
    type6.imageID = [UIImage imageNamed:@"Family_Large.png"];
    [typeDataSource addObject:type6];
    
    MainTypeClass *type7 = [[MainTypeClass alloc] init];
    type7.typeID = @"7";
    type7.typeName = @"Food and Wine";
    type7.imageID = [UIImage imageNamed:@"FoodandWine_Large.png"];
    [typeDataSource addObject:type7];
    
    MainTypeClass *type8 = [[MainTypeClass alloc] init];
    type8.typeID = @"8";
    type8.typeName = @"Cultural";
    type8.imageID = [UIImage imageNamed:@"Cultural_Large.png"];
    [typeDataSource addObject:type8];
    
    scrollView.clipsToBounds = NO;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    
    pageControl.numberOfPages = [typeDataSource count];
    
    [self setUpFrame:pageControl.numberOfPages]; 
}

- (void)setUpFrame: (NSInteger) pages {
    for (int i = 0; i < pageControl.numberOfPages; i++) 
    {
        CGRect frame;
        frame.origin.x = scrollView.frame.size.width *i;
        frame.origin.y = 0; 
        CGSize size = scrollView.frame.size;
        frame.size = size;
        
        
        UIView *subview = [[UIView alloc] initWithFrame:frame];
        subview.backgroundColor = [UIColor whiteColor];
        
        //Map Button
        
        UIButton *mapbutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [mapbutton addTarget:self action:@selector(MapButton:) forControlEvents:UIControlEventTouchDown];
        [mapbutton setTitle:@"Map" forState:UIControlStateNormal];
        
        [mapbutton setTitleColor:[UIColor colorWithRed:0.23 green:0.70 blue:0.44 alpha:1] forState:UIControlStateNormal];
        //SetButton Tag
        mapbutton.tag = i;
        
        mapbutton.layer.shadowColor = [UIColor blackColor].CGColor;
        mapbutton.layer.shadowOffset = CGSizeMake(0,1);
        mapbutton.layer.shadowOpacity = 2;
        mapbutton.layer.shadowRadius = 5.0;
        mapbutton.clipsToBounds = NO;
        
        //List Button
        
        UIButton *listbutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [listbutton addTarget:self action:@selector(ListButton:) forControlEvents:UIControlEventTouchDown];
        [listbutton setTitleColor:[UIColor colorWithRed:0.23 green:0.70 blue:0.44 alpha:1] forState:UIControlStateNormal];
        [listbutton setTitle:@"List" forState:UIControlStateNormal];
        
        //SetButton Tag
        listbutton.tag = i;
        
        listbutton.layer.shadowColor = [UIColor blackColor].CGColor;
        listbutton.layer.shadowOffset = CGSizeMake(0,1);
        listbutton.layer.shadowOpacity = 2;
        listbutton.layer.shadowRadius = 5.0;
        listbutton.clipsToBounds = NO;
        
        //Image View
        
        UIImageView *imageView = [[UIImageView alloc]init];
        MainTypeClass *currType = typeDataSource[i];
        imageView.image = currType.imageID;
        
        
        imageView.contentMode = UIViewContentModeCenter;
        imageView.layer.shadowColor = [UIColor blackColor].CGColor;
        imageView.layer.shadowOffset = CGSizeMake(0,1);
        imageView.layer.shadowOpacity = 2;
        imageView.layer.shadowRadius = 10.0;
        imageView.clipsToBounds = NO;
        
        UILabel *typeLabel = [[UILabel alloc] init];
        typeLabel.text = currType.typeName;
        typeLabel.textColor = [UIColor colorWithRed:0.23 green:0.70 blue:0.44 alpha:1];
        typeLabel.backgroundColor = [UIColor clearColor];
        typeLabel.textAlignment = UITextAlignmentCenter;
        [typeLabel setFont:[UIFont fontWithName:@"Comic Sans" size:24]];
        typeLabel.font = [UIFont systemFontOfSize:24];
        
        
        typeLabel.frame = CGRectMake(0.0, 320, 280, 60.0);
        mapbutton.frame = CGRectMake(10.0, 140.0, 60.0, 60.0);
        listbutton.frame = CGRectMake(190.0, 140.0, 60.0, 60.0);
        imageView.frame = CGRectMake(25.0f, 30.0f, 210.0f, 280.0f);
        
        [subview addSubview:imageView];
        [subview addSubview:mapbutton];
        [subview addSubview:listbutton];
        [subview addSubview:typeLabel];
        
        [self->scrollView addSubview:subview];
        
    } 
    
    self->scrollView.contentSize = CGSizeMake(self->scrollView.frame.size.width * pageControl.numberOfPages, self->scrollView.frame.size.height);
    CGSize scrollableSize = CGSizeMake(scrollView.frame.size.width *  typeDataSource.count, 280); // 280 is the height of the image.
    [self->scrollView setContentSize:scrollableSize]; 
    self->pageControl.currentPage=0;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if(!pageControlBeingUsed)
    {
        CGFloat pageWidth = self->scrollView.frame.size.width;
        CGFloat offset = self->scrollView.contentOffset.x;
        int page = floor((offset - pageWidth /2) / pageWidth) + 1;
        self->pageControl.currentPage = page;
    }
}


-(void)MapButton:(UIView*)sender
{      
    
    //Actions to perform after button press
    ExploreFilterViewController *exploreFilterView = [self.storyboard instantiateViewControllerWithIdentifier:@"ExploreFilterViewController"];
    
    NSInteger currentIndex = sender.tag;
    MainTypeClass *currType;
    currType = typeDataSource[currentIndex];
    
    exploreFilterView.typeName=currType.typeName;
    exploreFilterView.typeID=currType.typeID;
    
    exploreFilterView.mapDefault = YES;
    exploreFilterView.listDefault = NO;
    
    [self.navigationController pushViewController:exploreFilterView animated:YES];
    NSLog(@"Button");
    
    
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self->scrollView = nil;
	self->pageControl = nil;
}

-(void)ListButton:(UIView*)sender
{   
    //Actions to perform after button press
    ExploreFilterViewController *exploreFilterView = [self.storyboard instantiateViewControllerWithIdentifier:@"ExploreFilterViewController"];
    
    NSInteger currentIndex = sender.tag;
    MainTypeClass *currType;
    currType = typeDataSource[currentIndex];
    
    exploreFilterView.typeName=currType.typeName;
    exploreFilterView.typeID=currType.typeID;
    
    exploreFilterView.mapDefault = NO;
    exploreFilterView.listDefault = YES;
    
    
    [self.navigationController pushViewController:exploreFilterView animated:YES];
    NSLog(@"Button");
}


- (IBAction)changePage:(id)sender {
    CGRect frame;
    frame.origin.x = self->scrollView.frame.size.width * self->pageControl.currentPage;
    frame.origin.y=0;
    frame.size = self->scrollView.frame.size;
    [self->scrollView scrollRectToVisible:frame animated:YES];
    pageControlBeingUsed = YES;
}
@end
