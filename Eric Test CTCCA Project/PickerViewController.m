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
#import "SignUpCheck.h"
#import "RecordSignup.h"

@interface PickerViewController ()

@end

int count = 0;
bool allUnlocked = true;
bool errorMsgShown;
@implementation PickerViewController

@synthesize listingsList, listingsListString;
@synthesize categoryLocked,suburbLocked,costLocked,spinned, alert;
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
    notFoundView.hidden=TRUE;
    
    
    
}

- (void)viewDidLoad
{
    errorMsgShown = NO;
    [super setTitle:@"spinwheel"];
    [super viewDidLoad];
    
    spinned=false;
    alert = NO;
    SubType = [[NSMutableArray alloc] init];
    [SubType addObject:@"Any"];
    [SubType addObject:@"Food & Wine"];
    [SubType addObject:@"Entertainment"];
    [SubType addObject:@"Cultural"];
    [SubType addObject:@"Shopping"];
    [SubType addObject:@"Accommodation"];
    [SubType addObject:@"Outdoor"];
    [SubType addObject:@"Family"];
    [SubType addObject:@"Sport"];
    
    Area =[[NSMutableArray alloc] init];
    [Area addObject:@"Any"];
    [Area addObject:@"Gungahlin"];
    [Area addObject:@"Belconnen"];
    [Area addObject:@"Inner North"];
    [Area addObject:@"Inner South"];
    [Area addObject:@"Woden Valley"];
    [Area addObject:@"Tuggeranong"];
    [Area addObject:@"Regional"];
    [Area addObject:@"Murrumbateman"];
    [Area addObject:@"Yass"];
    [Area addObject:@"Bungendore"];
    [Area addObject:@"Civic"];
    [Area addObject:@"Queanbeyan"];
    
    Cost = [[NSMutableArray alloc] init];
    [Cost addObject:@"Any"];
    [Cost addObject:@"Free"];
    [Cost addObject:@"$"];
    [Cost addObject:@"$$"];
    [Cost addObject:@"$$$"];
    [Cost addObject:@"$$$$"];
    [Cost addObject:@"$$$$$"];
    
    CostArray = [[NSMutableArray alloc] init];
    [CostArray addObject:@"Free"];
    [CostArray addObject:@"$"];
    [CostArray addObject:@"$$"];
    [CostArray addObject:@"$$$"];
    [CostArray addObject:@"$$$$"];
    [CostArray addObject:@"$$$$$"];
    
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
    if(![selectedCategory isEqualToString:SubType[[pickerView selectedRowInComponent:subtype]]]){
        selectedCategory= SubType[[pickerView selectedRowInComponent:subtype]];
        if(![selectedCategory isEqualToString:@"Any"]){
            categoryLocked = NO;
            [self lockUnlockCategory:catLock];
        }else{
            categoryLocked = YES;
            [self lockUnlockCategory:catLock];
        }
    }
    
    if(![selectedSuburb isEqualToString:Area[[pickerView selectedRowInComponent:area]]]){
        selectedSuburb = Area[[pickerView selectedRowInComponent:area]];
        if(![selectedSuburb isEqualToString:@"Any"]){
            suburbLocked = NO;
            [self lockUnlockSuburb:regionLock];
        }else{
            suburbLocked = YES;
            [self lockUnlockSuburb:regionLock];
        }
    }
    
    if(![selectedCost isEqualToString:Cost[[pickerView selectedRowInComponent:cost]]]){
        selectedCost = Cost[[pickerView selectedRowInComponent:cost]];
        if(![selectedCost isEqualToString:@"Any"]){
            costLocked = NO;
            [self lockUnlockCost:priceLock];
        }else{
            costLocked = YES;
            [self lockUnlockCost:priceLock];
        }
    }
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
        while(random==0){
            random = (arc4random() % [SubType count]);
        }
        selectedCategory = SubType[random];
        [spinWheel selectRow:random inComponent:subtype animated:YES];
        //[self performSelector:@selector(moveIntoPosition) withObject:nil afterDelay:0.5f];
    }
    
    if(!suburbLocked){
        int random2 = (arc4random() % [Area count]);
        while(random2==0){
            random2 = (arc4random() % [Area count]);
        }
        selectedSuburb = Area[random2];
        [spinWheel selectRow:random2 inComponent:area animated:YES];
        //[self performSelector:@selector(moveIntoPosition) withObject:nil afterDelay:0.5f];
        
    }
    
    if(!costLocked){
        int random3 = (arc4random() % [Cost count]);
        while(random3==0){
            random3 = (arc4random() % [Cost count]);
        }
        selectedCost = Cost[random3];
        [spinWheel selectRow:random3 inComponent:cost animated:YES];
        
        
    }
    //stop and hide animating image
}


- (IBAction)feelingAdv:(id)sender {
    count=0;
    spinned = NO;
    alert = NO;
    // spinWheel.userInteractionEnabled = NO;
    [self feelingAdventurous];
    // spinWheel.userInteractionEnabled = YES;
}

-(void)feelingAdventurous  // Control for Map View Button to Listing Detail View
{
    
    
    if(spinned==NO){
        [feelAdvBtn setEnabled:false];
        [catLock setEnabled:false];
        [regionLock setEnabled:false];
        [priceLock setEnabled:false];
        [spinWheel setUserInteractionEnabled:false];
        notFoundView.hidden = true;
        loadView.hidden = false;
        resultButtonView.hidden=TRUE;
        if(!costLocked && !categoryLocked && !suburbLocked){
            allUnlocked = true;
        }else{
            allUnlocked = false;
        }
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
            if([selectedCost isEqualToString:@"Free"]){
                selectedCost = @"0";
            }else if([selectedCost isEqualToString:@"$"]){
                selectedCost = @"1";
            }else if([selectedCost isEqualToString:@"$$"]){
                selectedCost = @"2";
            }else if([selectedCost isEqualToString:@"$$$"]){
                selectedCost = @"3";
            }else if([selectedCost isEqualToString:@"$$$$"]){
                selectedCost = @"4";
            }else if([selectedCost isEqualToString:@"$$$$$"]){
                selectedCost = @"5";
            }
            
            //        NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"AroundMe.php.xml"];
            //        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
            //        NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:data];
            if([selectedCategory isEqualToString:@"Food & Wine"]){
                selectedCategory = [[selectedCategory stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
            }
            NSString *urlString = [NSString stringWithFormat:@"http://imaginecup.ise.canberra.edu.au/PhpScripts/Spinwheel.php?category=%@&region=%@&cost=%@",selectedCategory,[selectedSuburb stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],selectedCost];
            NSURL *url = [[NSURL alloc] initWithString:urlString];
            NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];            
            
            [xmlParser setDelegate:self];
            
            BOOL worked = [xmlParser parse];
            
            if(worked) {
                NSLog(@"Amount %i", [listingsListString count]);
            }
            else
            {
                UIAlertView *alertBox = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                                   message:@"Something went wrong. Please make sure you are connected to the internet."
                                                                  delegate:nil
                                                         cancelButtonTitle:@"OK"
                                                         otherButtonTitles: nil];
                if(errorMsgShown==NO){
                    [alertBox show];
                    errorMsgShown = YES;
                }
                
                NSLog(@"did not work!");
            }
            
            if([listingsListString count]==0 && (count<20 || allUnlocked)){
                NSLog(@"%i",count);
                count++;
                [self feelingAdventurous];
            }
            
            listingsList = [[NSMutableArray alloc] init];
            
            for (ListingString *listingStringElement in listingsListString) {
                
                Listing *currListing = [[Listing alloc] init];
                
                // ListingID , Title , SubTitle
                
                currListing.listingID = [listingStringElement.ItemID stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                currListing.listingID = [currListing.listingID stringByReplacingOccurrencesOfString:@"\t" withString:@""];
                currListing.title = [listingStringElement.ItemName stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                currListing.title = [currListing.title stringByReplacingOccurrencesOfString:@"\t" withString:@""];
                
                // Placemarker
                
                CLLocationCoordinate2D tempPlacemarker;
                
                NSString *tempLat = [listingStringElement.Latitude stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                tempLat = [tempLat stringByReplacingOccurrencesOfString:@"\t" withString:@""];
                double latDouble =[tempLat doubleValue];
                tempPlacemarker.latitude = latDouble;
                
                NSString *tempLong = [listingStringElement.Longitude stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                tempLong = [tempLong stringByReplacingOccurrencesOfString:@"\t" withString:@""];
                double lonDouble =[tempLong doubleValue];
                tempPlacemarker.longitude = lonDouble;
                
                currListing.coordinate = tempPlacemarker;
                
                //Sort and Filter Types
                
                currListing.listingType = [listingStringElement.ListingType stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                currListing.listingType = [currListing.listingType stringByReplacingOccurrencesOfString:@"\t" withString:@""];
                currListing.areaID = [listingStringElement.AreaID stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                currListing.areaID = [currListing.areaID stringByReplacingOccurrencesOfString:@"\t" withString:@""];
                currListing.costType =[listingStringElement.Cost stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                currListing.costType =[currListing.costType stringByReplacingOccurrencesOfString:@"\t" withString:@""];
                currListing.subType = [listingStringElement.SubtypeName stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                currListing.subType = [currListing.subType stringByReplacingOccurrencesOfString:@"\t" withString:@""];
                
                // Address
                
                currListing.address = [listingStringElement.Address stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                currListing.address = [currListing.address stringByReplacingOccurrencesOfString:@"\t" withString:@""];
                currListing.majorRegionName = [listingStringElement.MajorRegionName stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                currListing.majorRegionName = [currListing.majorRegionName stringByReplacingOccurrencesOfString:@"\t" withString:@""];
                currListing.phone = [listingStringElement.Phone stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                currListing.phone = [currListing.phone stringByReplacingOccurrencesOfString:@"\t" withString:@""];
                currListing.email = [listingStringElement.Email stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                currListing.email = [currListing.email stringByReplacingOccurrencesOfString:@"\t" withString:@""];
                currListing.suburb = [listingStringElement.Suburb stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                currListing.suburb = [currListing.suburb stringByReplacingOccurrencesOfString:@"\t" withString:@""];
                currListing.openingHours = [listingStringElement.OpeningHours stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                currListing.openingHours = [currListing.openingHours stringByReplacingOccurrencesOfString:@"\t" withString:@""];
                
                // Listing View details
                
                currListing.description = [listingStringElement.Details stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                currListing.description = [currListing.description stringByReplacingOccurrencesOfString:@"\t" withString:@""];
                currListing.imageFilenames = [listingStringElement.ImageURL componentsSeparatedByString:@","];
                currListing.videoURL = [NSURL URLWithString:[[[listingStringElement.VideoURL stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@"\t" withString:@""] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                currListing.websiteURL = [NSURL URLWithString:[[[[listingStringElement.Website stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@"\t" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                currListing.audioURL = [NSURL URLWithString:[[[listingStringElement.AudioURL stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@"\t" withString:@""] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                
                // Start Date
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"dd/MM/yyyy"];
                // Start Date
                listingStringElement.StartDate = [listingStringElement.StartDate stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                listingStringElement.StartDate = [listingStringElement.StartDate stringByReplacingOccurrencesOfString:@"\t" withString:@""];
                NSDate *startDate = [dateFormatter dateFromString:listingStringElement.StartDate];
                currListing.startDate = startDate;
                
                // End Date
                listingStringElement.EndDate = [listingStringElement.EndDate stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                listingStringElement.EndDate = [listingStringElement.EndDate stringByReplacingOccurrencesOfString:@"\t" withString:@""];
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
            if([listingsList count]>0)
            {
                result = listingsList[(arc4random() % [listingsList count])];
            }
            
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if([listingsList count]>0)
                {
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                    loadView.hidden=true;
                    resultButtonView.hidden=FALSE;
                    [resultButton setTitle:result.title forState:UIControlStateNormal];
                    [feelAdvBtn setEnabled:TRUE];
                    [catLock setEnabled:TRUE];
                    [regionLock setEnabled:TRUE];
                    [priceLock setEnabled:TRUE];
                    [spinWheel setUserInteractionEnabled:true];
                    //count = 0;
                    spinned = YES;
                    selectedCost = CostArray[[selectedCost intValue]];
                    
                    NSLog(@"%@", result.title);
                }else if([listingsList count]==0 && count==20){
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                    loadView.hidden=true;
                    notFoundView.hidden = false;
                    [feelAdvBtn setEnabled:TRUE];
                    [catLock setEnabled:TRUE];
                    [regionLock setEnabled:TRUE];
                    [priceLock setEnabled:TRUE];
                    selectedCost = CostArray[[selectedCost intValue]];
                    [spinWheel setUserInteractionEnabled:true];
                    UIAlertView *alertBox = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                                       message:@"There aren't any places found like that.  Unlink and try again."
                                                                      delegate:nil
                                                             cancelButtonTitle:@"OK"
                                                             otherButtonTitles: nil];
                    if(alert==NO){
                        [alertBox show];
                        alert = YES;
                    }
                    //count = 0;
                    spinned = YES;
                }
            });
        });
    }
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
        imageName = @"BrokenLink_White.png";
    }else{
        imageName = @"Link_White.png";
    }
    UIImage* image = [UIImage imageNamed:imageName];
    lockCategory.image = image;
    categoryLocked = !categoryLocked;
}

- (IBAction)lockUnlockSuburb:(id)sender {
    NSString *imageName;
    if(suburbLocked){
        imageName = @"BrokenLink_White.png";
    }else{
        imageName = @"Link_White.png";
    }
    UIImage* image = [UIImage imageNamed:imageName];
    lockSuburb.image = image;
    suburbLocked=!suburbLocked;
}

- (IBAction)lockUnlockCost:(id)sender {
    NSString *imageName;
    if(costLocked){
        imageName = @"BrokenLink_White.png";
    }else{
        imageName = @"Link_White.png";
    }
    UIImage* image = [UIImage imageNamed:imageName];
    lockCost.image = image;
    costLocked=!costLocked;
}
@end
