//
//  AboutViewController.m
//  Eric Test CTCCA Project
//
//  Created by CTCCA on 2/11/12.
//
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [self setTitle:@"about"];
    [textHolder loadHTMLString:[NSString stringWithFormat:@"<p><i>Capp – the Canberra app</i> – is the definitive guide to Canberra in its centenary year and beyond.</p><p>Available on both iOS and Android devises, Capp is a living evolving compendium of events, restaurants, bars, shops and attractions in and around Canberra.</p><p>Unlike many city guide apps, Capp was designed by to add value to Canberran’s daily lives in addition to helping tourists discover the Canberra that only locals know.</p><p>The genesis of Capp was <i>The Canberra Times</i>’ desire to deliver the city, its people and those who pass through it, a gift that was forward-thinking, accessible and practical.</p><p>This is idea was made possible thanks to the <i>University of Canberra</i>’s Faculty of Information Sciences and Engineering embracing the concept and it’s students for bringing it to life.</p> "] baseURL:nil];
    textHolder.scrollView.showsHorizontalScrollIndicator=FALSE;
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
