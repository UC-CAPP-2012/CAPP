//
//  BlabberViewController.h
//  Eric Test CTCCA Project
//
//  Created by CTCCA on 25/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "News.h"

@interface BlabberViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *newsView;
@property (strong, nonatomic) IBOutlet UITableView *newsTableView;
@property (strong, nonatomic) IBOutlet UITableViewCell *newsTableCell;
@property (strong, nonatomic) IBOutlet UILabel *publishDate;
@property (strong, nonatomic) IBOutlet UIImageView *newsImage;
@property (strong, nonatomic) IBOutlet UILabel *newsHeadding;
@property (strong, nonatomic) IBOutlet UILabel *authorName;
@property (strong, nonatomic) IBOutlet UILabel *newsContents;
@property (strong, nonatomic) IBOutlet UIView *newsLoadView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *newsLoadIndicator;

@property(nonatomic, strong)NSMutableArray *newsList;
@property (strong, nonatomic)News *currentNews;

@property int NewsID;
@property (nonatomic, copy) NSData *NewsDateTime;
@property (nonatomic, copy) NSString *NewsBody;
@property (nonatomic, copy) NSURL *NewsMediaURL;
@property (nonatomic, copy) NSString *NewsPublisher;
@property (nonatomic, copy) NSString *NewsAuthor;

@end
