//
//  PickerViewController.m
//  Eric Test CTCCA Project
//
//  Created by CTCCA on 4/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PickerViewController.h"
#import "ListingString.h"
#import "Listing.h"

@interface PickerViewController ()

@end

@implementation PickerViewController
@synthesize listingsList, listingsListString;

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
    [super viewDidLoad];
    
    SubType = [[NSMutableArray alloc] init];
    [SubType addObject:@"Sub1"];
    [SubType addObject:@"Sub2"];
    [SubType addObject:@"Sub3"];
    [SubType addObject:@"Sub4"];
    [SubType addObject:@"Sub5"];
    [SubType addObject:@"Sub6"];
    [SubType addObject:@"Sub7"];
    
    Area =[[NSMutableArray alloc] init];
    [Area addObject:@"Area1"];
    [Area addObject:@"Area2"];
    [Area addObject:@"Area3"];
    [Area addObject:@"Area4"];
    [Area addObject:@"Area5"];
    [Area addObject:@"Area6"];
    [Area addObject:@"Area7"];
    
    Cost = [[NSMutableArray alloc] init];
    [Cost addObject:@"Cost1"];
    [Cost addObject:@"Cost2"];
    [Cost addObject:@"Cost3"];
    [Cost addObject:@"Cost4"];
    [Cost addObject:@"Cost5"];
    [Cost addObject:@"Cost6"];
    [Cost addObject:@"Cost7"];
    
    
    
	// Do any additional setup after loading the view.
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == subtype)
        return [SubType count];
    if (component == area)
        return [Area count];
    if (component == cost)
        return [Cost count];
    
    return 0;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if (component == subtype)
        return [SubType objectAtIndex:row];
    if (component == area)
        return [Area objectAtIndex:row];
    if (component == cost)
        return [Cost objectAtIndex:row];
        
    return 0;
}
-(void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSLog(@"%@", [SubType objectAtIndex:[pickerView selectedRowInComponent:0]]);
    NSLog(@"%@", [Area objectAtIndex:[pickerView selectedRowInComponent:0]]);
    NSLog(@"%@", [Cost objectAtIndex:[pickerView selectedRowInComponent:0]]);
}


-(void)feelingAdventurous:(id)sender  // Control for Map View Button to Listing Detail View   
{      
    [listingsListString removeAllObjects];
    [listingsList removeAllObjects];

    //The strings to send to the webserver.
    
    
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"AroundMe.php.xml"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:data];
    
    //NSString * urlString = [NSString stringWithFormat:@"http://itp2012.com/CMS/IPHONE/subscribe.php?Name=%@&Postcode=%@&Email=%@&Subscribe=%@", x1,x2,y1,y2];
    //NSString *urlString = [NSString stringWithFormat:@"http://www.itp2012.com/CMS/IPHONE/AroundMe.php?x1=-36&x2=-34&y1=150&y2=149"];
    //NSURL *url = [[NSURL alloc] initWithString:urlString];
    //NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    
    
    [xmlParser setDelegate:self];
    
    BOOL worked = [xmlParser parse];
    
    if(worked) {
        NSLog(@"Amount %i", [listingsListString count]);
    }
    else 
    {
        NSLog(@"did not work!");
    }
    
    listingsList = [[NSMutableArray alloc] init];
    
    for (ListingString *listingStringElement in listingsListString) {
        
        Listing *currListing = [[Listing alloc] init];
        
        
        // ListingID , Title , SubTitle220
        
        currListing.listingID = [listingStringElement.ListingID stringByReplacingOccurrencesOfString:@"\n" withString:@""];       
        currListing.title = [listingStringElement.ListingName stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
        [listingsList addObject:currListing];
        }
    
    NSLog(@"%i", [listingsList count]);
}


// --- XML Delegate Classes ----

-(void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"ListingElements"]) 
    {
        self.listingsListString = [[NSMutableArray alloc] init];
    }
    else if ([elementName isEqualToString:@"ListingElement"])
    {
        theList = [[ListingString alloc] init];
        theList.listingID = [[attributeDict objectForKey:@"listingID"] stringValue];
    }
}

-(void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (!currentElementValue)
    {   
        currentElementValue = [[NSMutableString alloc] initWithString:string];
    }
    else 
    {
        [currentElementValue appendString:string];
    }
}

-(void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"ListingElements"])
    {
        return;
    }
    
    if([elementName isEqualToString:@"ListingElement"])
    {
        [self.listingsListString addObject:theList];
        theList = nil;
    }
    else 
    {
        [theList setValue:currentElementValue forKey:elementName];
        NSLog(@"%@",currentElementValue);
        currentElementValue = nil;
    }
}




- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}




@end
