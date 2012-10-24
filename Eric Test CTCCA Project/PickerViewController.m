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
    loadView.hidden=TRUE;
    

}

- (void)viewDidLoad
{
    [super setTitle:@"spinwheel"];
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

-(void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    selectedCategory= SubType[[pickerView selectedRowInComponent:subtype]];
    selectedSuburb = Area[[pickerView selectedRowInComponent:area]];
    selectedCost = Cost[[pickerView selectedRowInComponent:cost]];
    NSLog(@"%@",selectedCategory);
    NSLog(@"%@",selectedSuburb);
    NSLog(@"%@",selectedCost);
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    switch(component) {
            case subtype: return 110;
            case area: return 110;
            case cost: return 70;
        default: return 22;
    }
    
    //NOT REACHED
    return 22;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    switch(component) {
        case subtype: {
            UILabel *retval = (id)view;
            if (!retval) {
                retval= [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [pickerView rowSizeForComponent:component].width-10, [pickerView rowSizeForComponent:component].height)] ;
            }
            retval.backgroundColor = [UIColor clearColor];
            retval.text = SubType[row];
            retval.adjustsFontSizeToFitWidth = YES;
            [retval setFont:[UIFont fontWithName:@"Arial-BoldMT" size:20]];

            return retval;
        }
        case area: {
            UILabel *retval = (id)view;
            if (!retval) {
                retval= [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [pickerView rowSizeForComponent:component].width-10, [pickerView rowSizeForComponent:component].height)] ;
            }
            retval.backgroundColor = [UIColor clearColor];
            retval.text = Area[row];
            retval.adjustsFontSizeToFitWidth = YES;
            [retval setFont:[UIFont fontWithName:@"Arial-BoldMT" size:20]];
            return retval;
        }

        case cost: {
            UILabel *retval = (id)view;
            if (!retval) {
                retval= [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [pickerView rowSizeForComponent:component].width-10, [pickerView rowSizeForComponent:component].height)] ;
            }
            retval.backgroundColor = [UIColor clearColor];
            retval.text = Cost[row];
            retval.adjustsFontSizeToFitWidth = YES;
            [retval setFont:[UIFont fontWithName:@"Arial-BoldMT" size:20]];
            
            return retval;
        }
        default:{
            return (id)view;
        }
    }
    
}


-(void)spin
{
    if(!categoryLocked){
        int random = (arc4random() % [SubType count]);
        selectedCategory = SubType[random];
        [spinWheel selectRow:random inComponent:subtype animated:YES];
        //[self performSelector:@selector(moveIntoPosition) withObject:nil afterDelay:0.5f];
    }
    
    if(!suburbLocked){
        int random2 = (arc4random() % [Area count]);
        selectedSuburb = Area[random2];
        [spinWheel selectRow:random2 inComponent:area animated:YES];
        //[self performSelector:@selector(moveIntoPosition) withObject:nil afterDelay:0.5f];

    }
    
    if(!costLocked){
        int random3 = (arc4random() % [Cost count]);
        selectedCost = Cost[random3];
        [spinWheel selectRow:random3 inComponent:cost animated:YES];
        
        
    }
    //stop and hide animating image
}

-(void)feelingAdventurous:(id)sender  // Control for Map View Button to Listing Detail View   
{
    loadView.hidden = false;
    resultButtonView.hidden=TRUE;
    //[NSThread sleepForTimeInterval:3.0];
    dispatch_queue_t concurrentQueue =
    dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(concurrentQueue, ^(void){
        //[self performSelector:@selector(spin) withObject:nil afterDelay:2.0f];
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
            
            // ListingID , Title , SubTitle
            
            currListing.listingID = [listingStringElement.ItemID stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            currListing.listingID = [currListing.listingID stringByReplacingOccurrencesOfString:@"" withString:@""];
            currListing.title = [listingStringElement.ItemName stringByReplacingOccurrencesOfString:@"\n" withString:@""];

            
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
            currListing.costType =[listingStringElement.Cost stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            currListing.subType = [listingStringElement.SubtypeName stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            
            // Address
            
            currListing.address = [listingStringElement.Address stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
            currListing.majorRegionName = [listingStringElement.MajorRegionName stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
            currListing.phone = [listingStringElement.Phone stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
            currListing.email = [listingStringElement.Email stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
            currListing.suburb = [listingStringElement.Suburb stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
            currListing.openingHours = [listingStringElement.OpeningHours stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
            
            // Listing View details
            
            currListing.description = [listingStringElement.Details stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            currListing.imageFilenames = [listingStringElement.ImageURL componentsSeparatedByString:@","];
            currListing.videoURL = [NSURL URLWithString:[listingStringElement.VideoURL stringByReplacingOccurrencesOfString:@"\n" withString:@""]];
            currListing.websiteURL = [NSURL URLWithString:[listingStringElement.Website stringByReplacingOccurrencesOfString:@"\n" withString:@""]];
            currListing.audioURL = [NSURL URLWithString:[listingStringElement.AudioURL stringByReplacingOccurrencesOfString:@"\n" withString:@""]];
            
            // Start Date
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"dd/MM/yyyy"];
            // Start Date
            listingStringElement.StartDate = [listingStringElement.StartDate stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            NSDate *startDate = [dateFormatter dateFromString:listingStringElement.StartDate];
            currListing.startDate = startDate;
            
            // End Date
            listingStringElement.EndDate = [listingStringElement.EndDate stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            NSDate *endDate = [dateFormatter dateFromString:listingStringElement.EndDate];
            currListing.endDate = endDate;
            
            // ** CHECKS ------------------------
            NSLog(@"%@",listingStringElement.ItemName);
            NSLog(@"%@",listingStringElement.Latitude);
            NSLog(@"%@",listingStringElement.Longitude);
            NSLog(@"%f",latDouble);
            NSLog(@"%f",lonDouble);
            NSLog(@"%@",listingStringElement.ItemID);
            NSLog(@"%@",listingStringElement.ListingType);
            NSLog(@"%@",listingStringElement.AreaID);
            NSLog(@"%@",listingStringElement.Cost);
            NSLog(@"%@",listingStringElement.SubtypeName);
            NSLog(@"%@",listingStringElement.Suburb);    //suburb
            NSLog(@"%@",listingStringElement.Postcode);  //postcode
            NSLog(@"%@",listingStringElement.StateID);   //stateID
            NSLog(@"%@",currListing.address);
            NSLog(@"%@",listingStringElement.Details);
            NSLog(@"%@",listingStringElement.ImageURL);
            NSLog(@"%@",listingStringElement.VideoURL);
            NSLog(@"%@",listingStringElement.StartDate);
            NSLog(@"%@",listingStringElement.EndDate);
            NSLog(@"%@",listingStringElement.Website);

            
            // -----------------------------------------
            
            [listingsList addObject:currListing];
            
        }
        result = listingsList[(arc4random() % [listingsList count])];
        // [NSThread sleepForTimeInterval:3.0];
        //loadView.hidden=TRUE;
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            loadView.hidden=true;
            resultButtonView.hidden=FALSE;
            [resultButton setTitle:result.title forState:UIControlStateNormal];
            NSLog(@"%@", result.title);
        });
    });

    
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
        theList.ItemID = [attributeDict[@"listingID"] stringValue];
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
