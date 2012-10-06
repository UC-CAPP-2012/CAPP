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
@synthesize categoryLocked,suburbLocked,costLocked;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        categoryLocked=FALSE;
        suburbLocked=FALSE;
        costLocked=FALSE;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    resultButtonView.hidden=TRUE;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    SubType = [[NSMutableArray alloc] init];
    [SubType addObject:@"Entertainment"];
    [SubType addObject:@"Accomodation"];
    [SubType addObject:@"Sport"];
    [SubType addObject:@"Outdoor & Nature"];
    [SubType addObject:@"Family Fun"];
    [SubType addObject:@"Food & Wine"];
    [SubType addObject:@"Museums & Galleries"];
    
    Area =[[NSMutableArray alloc] init];
    [Area addObject:@"Area1"];
    [Area addObject:@"Area2"];
    [Area addObject:@"Area3"];
    [Area addObject:@"Area4"];
    [Area addObject:@"Area5"];
    [Area addObject:@"Area6"];
    [Area addObject:@"Area7"];
    
    Cost = [[NSMutableArray alloc] init];
    [Cost addObject:@"Free"];
    [Cost addObject:@"$"];
    [Cost addObject:@"$$"];
    [Cost addObject:@"$$$"];
    [Cost addObject:@"$$$$"];
    [Cost addObject:@"$$$$$"];
    
    
    
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
    selectedCategory= [SubType objectAtIndex:[pickerView selectedRowInComponent:subtype]];
    selectedSuburb = [Area objectAtIndex:[pickerView selectedRowInComponent:area]];
    selectedCost = [Cost objectAtIndex:[pickerView selectedRowInComponent:cost]];
    NSLog(@"%@",selectedCategory);
    NSLog(@"%@",selectedSuburb);
    NSLog(@"%@",selectedCost);
}



-(void)spin
{
    if(!categoryLocked){
        int random = (arc4random() % [SubType count]);
        selectedCategory = [SubType objectAtIndex:random];
        [spinWheel selectRow:random inComponent:subtype animated:YES];
        //[self performSelector:@selector(moveIntoPosition) withObject:nil afterDelay:0.5f];
    }
    
    if(!suburbLocked){
        int random2 = (arc4random() % [Area count]);
        selectedSuburb = [Area objectAtIndex:random2];
        [spinWheel selectRow:random2 inComponent:area animated:YES];
        //[self performSelector:@selector(moveIntoPosition) withObject:nil afterDelay:0.5f];

    }
    
    if(!costLocked){
        int random3 = (arc4random() % [Cost count]);
        selectedCost = [Cost objectAtIndex:random3];
        [spinWheel selectRow:random3 inComponent:cost animated:YES];
        //[self performSelector:@selector(moveIntoPosition) withObject:nil afterDelay:0.5f];
        
    }
    //stop and hide animating image
}

-(void)feelingAdventurous:(id)sender  // Control for Map View Button to Listing Detail View   
{
    [self spin];
    
    [listingsListString removeAllObjects];
    [listingsList removeAllObjects];

    //The strings to send to the webserver.
    NSLog(@"%@",selectedCategory);
    NSLog(@"%@",selectedSuburb);
    NSLog(@"%@",selectedCost);
    
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
        //NSLog(@"Amount %i", [listingsListString count]);
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
        currListing.listingID = [currListing.listingID stringByReplacingOccurrencesOfString:@"" withString:@""];
        currListing.title = [listingStringElement.ListingName stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        currListing.subtitle = [listingStringElement.Subtitle stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
        // Placemarker
        
        CLLocationCoordinate2D tempPlacemarker;
        
        NSString *tempLat = [listingStringElement.Latitude stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        double latDouble =[tempLat doubleValue];
        tempPlacemarker.latitude = latDouble;
        
        NSString *tempLong = [listingStringElement.Longitude stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        double lonDouble =[tempLong doubleValue];
        tempPlacemarker.longitude = lonDouble;
        
        currListing.coordinate = tempPlacemarker;
        
        //Sort and Filter Types
        
        currListing.listingType = [listingStringElement.ListingType stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        currListing.areaID = [listingStringElement.AreaID stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        currListing.costType =[listingStringElement.CostType stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        currListing.ratingType = [listingStringElement.RatingType stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        currListing.subType = [listingStringElement.SubType stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
        // Address
        
        currListing.address = [listingStringElement.Address stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
        
        // Listing View details
        
        currListing.details = [listingStringElement.Details stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        currListing.description = [listingStringElement.Description stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        currListing.review = [listingStringElement.Review stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        currListing.imageFilenames = [listingStringElement.ImageURL componentsSeparatedByString:@","];
        NSString *urlTemp = [listingStringElement.VideoURL stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        NSString *videoUrlString = [[NSString stringWithFormat:urlTemp] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *webUrlTemp = [listingStringElement.WebsiteURL stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        NSString *webUrlString = [[NSString stringWithFormat:webUrlTemp] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        currListing.videoURL = [NSURL URLWithString:videoUrlString];
        currListing.websiteURL = [NSURL URLWithString:webUrlString];
        
        // Start Date
        
        listingStringElement.startDay = [listingStringElement.StartDay stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        listingStringElement.startMonth = [listingStringElement.StartMonth stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        listingStringElement.startYear = [listingStringElement.StartYear stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        listingStringElement.startMinute = [listingStringElement.StartMinute stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        listingStringElement.startHour = [listingStringElement.StartHour stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
        int startDay =[listingStringElement.StartDay intValue];
        int startMonth =[listingStringElement.StartMonth intValue];
        int startYear =[listingStringElement.StartYear intValue];
        int startMinute =[listingStringElement.StartMinute intValue];
        int startHour =[listingStringElement.StartHour intValue];
        
        NSDateComponents *startcomps = [[NSDateComponents alloc] init];
        [startcomps setDay:startDay];
        [startcomps setMonth:startMonth];
        [startcomps setYear:startYear];
        [startcomps setHour:startHour];
        [startcomps setMinute:startMinute];
        NSCalendar *gregorianStart = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDate *startDate = [gregorianStart dateFromComponents:startcomps];
        currListing.startDate = startDate;
        
        // End Date
        
        listingStringElement.endDay = [listingStringElement.EndDay stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        listingStringElement.endMonth = [listingStringElement.EndMonth stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        listingStringElement.endYear = [listingStringElement.EndYear stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        listingStringElement.endMinute = [listingStringElement.EndMinute stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        listingStringElement.endHour = [listingStringElement.EndHour stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
        int endDay =[listingStringElement.EndDay intValue];
        int endMonth =[listingStringElement.EndMonth intValue];
        int endYear =[listingStringElement.EndYear intValue];
        int endMinute =[listingStringElement.EndMinute intValue];
        int endHour =[listingStringElement.EndHour intValue];
        
        NSDateComponents *endcomps = [[NSDateComponents alloc] init];
        [endcomps setDay:endDay];
        [endcomps setMonth:endMonth];
        [endcomps setYear:endYear];
        [endcomps setHour:endHour];
        [endcomps setMinute:endMinute];
        NSCalendar *endgregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDate *endDate = [endgregorian dateFromComponents:endcomps];
        currListing.endDate = endDate;
        
    
        [listingsList addObject:currListing];
        }
    //NSLog(@"%i", [listingsList count]);
    result = [listingsList objectAtIndex:(arc4random() % [listingsList count])];
    resultButtonView.hidden=FALSE;
    [resultButton setTitle:result.title forState:UIControlStateNormal];
    NSLog(@"%@", result.title);
}

- (IBAction)goToListing:(id)sender {
    ListingViewController *listingView = [self.storyboard instantiateViewControllerWithIdentifier:@"ListingViewController"]; // Listing Detail Page
    listingView.currentListing = result;
    [self.navigationController pushViewController:listingView animated:YES];
    NSLog(@"%@",result.title);

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




- (IBAction)lockUnlockCategory:(id)sender {
    NSString *imageName;
    if(categoryLocked){
        imageName = @"unlock.png";
    }else{
        imageName = @"lock.png";
    }
    UIImage* image = [UIImage imageNamed:imageName];
    lockCategory.image = image;
    categoryLocked = !categoryLocked;
}

- (IBAction)lockUnlockSuburb:(id)sender {
    NSString *imageName;
    if(suburbLocked){
        imageName = @"unlock.png";
    }else{
        imageName = @"lock.png";
    }
    UIImage* image = [UIImage imageNamed:imageName];
    lockSuburb.image = image;
    suburbLocked=!suburbLocked;
}

- (IBAction)lockUnlockCost:(id)sender {
    NSString *imageName;
    if(costLocked){
        imageName = @"unlock.png";
    }else{
        imageName = @"lock.png";
    }
    UIImage* image = [UIImage imageNamed:imageName];
    lockCost.image = image;
    costLocked=!costLocked;
}
@end
