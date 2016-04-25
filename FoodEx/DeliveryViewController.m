//
//  DeliveryViewController.m
//  FoodEx
//
//  Created by Adam Gaynor on 3/1/16.
//  Copyright © 2016 FoodEx. All rights reserved.
//

#import "DeliveryViewController.h"
#import "GlobalData.h"
#import "ReviewOrderViewController.h"
@interface DeliveryViewController ()

@end

@implementation DeliveryViewController
{
    BOOL didLocateUser;
}

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

- (void)viewDidLoad {
    [super viewDidLoad];

    self.myDeliveryAnnotations = [[NSMutableArray alloc] init];
    self.undeliveredAnnotations = [[NSMutableArray alloc] init];
    
    self.tblDeliveries.hidden = YES;
    self.mapView.hidden = NO;
    
    
    self.tblDeliveries.delegate = self;
    self.tblDeliveries.dataSource = self;
    
    [self.datePicker setMinimumDate:[NSDate date]];
    

    //setup map information
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    self.mapView.rotateEnabled = NO;
    self.mapView.pitchEnabled = NO;
    self.bounds = MGLCoordinateBoundsMake(CLLocationCoordinate2DMake(38.637206, -90.319410),CLLocationCoordinate2DMake(38.659962, -90.297445));
    
    
    self.mapView.visibleCoordinateBounds = self.bounds;
    
    self.mapView.minimumZoomLevel = self.mapView.zoomLevel;
    didLocateUser = NO;

    
    
    GlobalData *myData = [GlobalData sharedInstance];
    [myData.myDeliveries importMyDeliveries:YES andCompletion:^(BOOL completion){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tblDeliveries reloadData];
            
            [self.mapView removeAnnotations:self.myDeliveryAnnotations];
            [self.myDeliveryAnnotations removeAllObjects];
            for(FoodRequest *request in myData.myDeliveries.requests)
            {
                MGLPointAnnotation *annotation = [[MGLPointAnnotation alloc] init];
                annotation.coordinate = request.pickup_point;
                annotation.title = request.order.dining_location;
                if([request.order.otherLocations count] > 0)
                {
                    annotation.title = [annotation.title stringByAppendingString:@", Or..."];
                }
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"h:mm a"];
                annotation.subtitle = [dateFormatter stringFromDate:request.pickup_at];
                
                [self.mapView addAnnotation:annotation];
                [self.myDeliveryAnnotations addObject:annotation];
            }
        });
    }];
    [myData.unclaimedDeliveries queryUndeliveredRequestsWithTime:[NSDate date] andCompletion:^(BOOL completion){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tblDeliveries reloadData];
            
            
            [self.mapView removeAnnotations:self.undeliveredAnnotations];
            [self.undeliveredAnnotations removeAllObjects];
            for(FoodRequest *request in myData.unclaimedDeliveries.requests)
            {
                MGLPointAnnotation *annotation = [[MGLPointAnnotation alloc] init];
                annotation.coordinate = request.pickup_point;
                annotation.title = request.order.dining_location;
                if([request.order.otherLocations count] > 0)
                {
                    annotation.title = [annotation.title stringByAppendingString:@", Or..."];
                }
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"h:mm a"];
                annotation.subtitle = [dateFormatter stringFromDate:request.pickup_at];
                
                [self.mapView addAnnotation:annotation];
                [self.undeliveredAnnotations addObject:annotation];
            }
        });
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveUpdateNotification:) name:@"UpdateMyDeliveries" object:nil];

    // Do any additional setup after loading the view from its nib.
    self.tblDeliveries.backgroundColor = UIColorFromRGB(0x064065);
    [self.datePicker setValue:UIColorFromRGB(0xb9b8b8) forKey:@"textColor"];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
    [self.tabBarController.tabBar setHidden:NO];
    [self.tblDeliveries reloadData];
}

-(void)receiveUpdateNotification:(NSNotification *)notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tblDeliveries reloadData];
        GlobalData *myData = [GlobalData sharedInstance];
        
        
        [self.mapView removeAnnotations:self.myDeliveryAnnotations];
        [self.myDeliveryAnnotations removeAllObjects];
        for(FoodRequest *request in myData.myDeliveries.requests)
        {
            MGLPointAnnotation *annotation = [[MGLPointAnnotation alloc] init];
            annotation.coordinate = request.pickup_point;
            annotation.title = request.order.dining_location;
            if([request.order.otherLocations count] > 0)
            {
                annotation.title = [annotation.title stringByAppendingString:@", Or..."];
            }
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"h:mm a"];
            annotation.subtitle = [dateFormatter stringFromDate:request.pickup_at];
            
            [self.mapView addAnnotation:annotation];
            [self.myDeliveryAnnotations addObject:annotation];
        }

        [self.mapView removeAnnotations:self.undeliveredAnnotations];
        [self.undeliveredAnnotations removeAllObjects];
        for(FoodRequest *request in myData.unclaimedDeliveries.requests)
        {
            MGLPointAnnotation *annotation = [[MGLPointAnnotation alloc] init];
            annotation.coordinate = request.pickup_point;
            annotation.title = request.order.dining_location;
            if([request.order.otherLocations count] > 0)
            {
                annotation.title = [annotation.title stringByAppendingString:@", Or..."];
            }
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"h:mm a"];
            annotation.subtitle = [dateFormatter stringFromDate:request.pickup_at];
            
            [self.mapView addAnnotation:annotation];
            [self.undeliveredAnnotations addObject:annotation];
        }

    });
   
}


- (IBAction)displayFormatChange:(id)sender {
    UISegmentedControl *viewChanger = ((UISegmentedControl *) sender);
    
    if(viewChanger.selectedSegmentIndex == 0)
    {
        self.mapView.hidden = NO;
        self.tblDeliveries.hidden = YES;
    }
    else
    {
        self.mapView.hidden = YES;
        self.tblDeliveries.hidden = NO;
    }
}

- (BOOL)mapView:(MGLMapView *)mapView annotationCanShowCallout:(id<MGLAnnotation>)annotation
{
    return true;
}

- (UIView *)mapView:(MGLMapView *)mapView rightCalloutAccessoryViewForAnnotation:(id<MGLAnnotation>)annotation
{
    
    return [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
}

- (void)mapView:(MGLMapView *)mapView annotation:(id<MGLAnnotation>)annotation calloutAccessoryControlTapped:(UIControl *)control
{
    GlobalData *myData = [GlobalData sharedInstance];
    // hide the callout view
    [self.mapView deselectAnnotation:annotation animated:NO];
    if([self.myDeliveryAnnotations containsObject:annotation])
    {
        unsigned long index = [self.myDeliveryAnnotations indexOfObject:annotation];
        myData.currentFoodRequest = [myData.myDeliveries.requests objectAtIndex:index];
        self.navigationController.navigationBar.hidden = NO;
        
        [self.navigationController pushViewController:[[ReviewOrderViewController alloc] initWithNibName:@"ReviewOrderViewController" bundle:nil] animated:YES];
        
    }
    else if([self.undeliveredAnnotations containsObject:annotation])
    {
        unsigned long index = [self.undeliveredAnnotations indexOfObject:annotation];
        myData.currentFoodRequest = [myData.unclaimedDeliveries.requests objectAtIndex:index];
        self.navigationController.navigationBar.hidden = NO;
        
        [self.navigationController pushViewController:[[ReviewOrderViewController alloc] initWithNibName:@"ReviewOrderViewController" bundle:nil] animated:YES];
        
    }
    

}


-(void)mapView:(MGLMapView *)mapView didUpdateUserLocation:(MGLUserLocation *)userLocation
{
    
    if(!didLocateUser && [self point:self.mapView.userLocation.coordinate inCoordinateBounds:self.bounds])
    {
        self.mapView.centerCoordinate = self.mapView.userLocation.coordinate;
        [self.mapView setZoomLevel:self.mapView.zoomLevel+3 animated:NO];
    }
    
    didLocateUser = YES;
   
}


-(BOOL)point:(CLLocationCoordinate2D) pt inCoordinateBounds:(MGLCoordinateBounds)bound{
    if(pt.latitude > bound.sw.latitude && pt.latitude < bound.ne.latitude)
    {
        
        if(pt.longitude > bound.sw.longitude && pt.longitude < bound.ne.longitude)
        {
            return YES;
        }
        else{
            return NO;
        }
        
    }
    else{
        return NO;
        
    }
    
}
-(void)mapViewRegionIsChanging:(MGLMapView *)mapView
{
    
    if(self.mapView.centerCoordinate.latitude > self.bounds.ne.latitude)
    {
        [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(self.bounds.ne.latitude, self.mapView.centerCoordinate.longitude)];
    }
    if(self.mapView.centerCoordinate.longitude > self.bounds.ne.longitude)
    {
        [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(self.mapView.centerCoordinate.latitude, self.bounds.ne.longitude)];
    }
    if(self.mapView.centerCoordinate.latitude < self.bounds.sw.latitude)
    {
        [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(self.bounds.sw.latitude, self.mapView.centerCoordinate.longitude)];
        
    }
    if(self.mapView.centerCoordinate.longitude < self.bounds.sw.longitude)
    {
        [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(self.mapView.centerCoordinate.latitude, self.bounds.sw.longitude)];
    }
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;    //count of section
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return @"My Deliveries";
    }
    else
    {
        return @"Unclaimed Deliveries";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    GlobalData *myData = [GlobalData sharedInstance];
    if(section == 0)
    {
        return [myData.myDeliveries.requests count];
    }
    else{
        return [myData.unclaimedDeliveries.requests count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"MyIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:MyIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    
    
    // Here we use the provided setImageWithURL: method to load the web image
    // Ensure you use a placeholder image otherwise cells will be initialized with no image
    GlobalData *myData = [GlobalData sharedInstance];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE',' M/dd 'at' h:mm a"];
    FoodRequest *request = nil;
    if(indexPath.section == 0)
    {
        request = [myData.myDeliveries.requests objectAtIndex:indexPath.row];
    }
    else
    {
        request = [myData.unclaimedDeliveries.requests objectAtIndex:indexPath.row];
    }
    
    NSString *textString = request.order.dining_location;
    for(int i = 0; i < [request.order.otherLocations count]; ++i)
    {
        if(i == [request.order.otherLocations count] - 1)
        {
            if([request.order.otherLocations count]>1){
                textString = [textString stringByAppendingString:[NSString stringWithFormat:@", or %@", [request.order.otherLocations objectAtIndex:i]]];
            }
            else{
                textString = [textString stringByAppendingString:[NSString stringWithFormat:@" or %@", [request.order.otherLocations objectAtIndex:i]]];
            }
        }
        else{
            textString = [textString stringByAppendingString:[NSString stringWithFormat:@", %@", [request.order.otherLocations objectAtIndex:i]]];
        }
    }
    
    
    cell.textLabel.text = textString;
    NSString *detailTextString = [dateFormatter stringFromDate:request.pickup_at];
    
    cell.detailTextLabel.text = detailTextString;
    
    //edit layout and ui
    cell.textLabel.textColor = UIColorFromRGB(0xB9B8B8);
    cell.detailTextLabel.textColor = UIColorFromRGB(0xB9B8B8);
    cell.backgroundColor = UIColorFromRGB(0x064065);
    cell.textLabel.font = [UIFont fontWithName:@"Futura" size:18];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Futura" size:14];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GlobalData *myData = [GlobalData sharedInstance];
    if(indexPath.section == 0)
    {
        myData.currentFoodRequest = [myData.myDeliveries.requests objectAtIndex:indexPath.row];
    }
    else
    {
        myData.currentFoodRequest = [myData.unclaimedDeliveries.requests objectAtIndex:indexPath.row];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NULL];
    self.navigationController.navigationBar.hidden = NO;

    [self.navigationController pushViewController:[[ReviewOrderViewController alloc] initWithNibName:@"ReviewOrderViewController" bundle:nil] animated:YES];
}


- (IBAction)deliveryTimeChanged:(id)sender {
    GlobalData *myData = [GlobalData sharedInstance];
    UIDatePicker *selectedDate = (UIDatePicker *)sender;
    [myData.unclaimedDeliveries queryUndeliveredRequestsWithTime:[selectedDate date] andCompletion:^(BOOL completion){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tblDeliveries reloadData];
            
            
            [self.mapView removeAnnotations:self.undeliveredAnnotations];
            [self.undeliveredAnnotations removeAllObjects];
            for(FoodRequest *request in myData.unclaimedDeliveries.requests)
            {
                MGLPointAnnotation *annotation = [[MGLPointAnnotation alloc] init];
                annotation.coordinate = request.pickup_point;
                annotation.title = request.order.dining_location;
                if([request.order.otherLocations count] > 0)
                {
                    annotation.title = [annotation.title stringByAppendingString:@", Or..."];
                }
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"h:mm a"];
                annotation.subtitle = [dateFormatter stringFromDate:request.pickup_at];
                
                [self.mapView addAnnotation:annotation];
                [self.undeliveredAnnotations addObject:annotation];
            }

        });
    }
     ];
}

- (MGLAnnotationImage *)mapView:(MGLMapView *)mapView imageForAnnotation:(id <MGLAnnotation>)annotation
{
    // Try to reuse the existing ‘pisa’ annotation image, if it exists
    MGLAnnotationImage *annotationImage = [mapView dequeueReusableAnnotationImageWithIdentifier:@"smoke"];
    
    // If the ‘pisa’ annotation image hasn‘t been set yet, initialize it here
    if ( ! annotationImage)
    {
        // Leaning Tower of Pisa by Stefan Spieler from the Noun Project
        UIImage *image = [UIImage imageNamed:@"smallpin-01.png"];
        
        // The anchor point of an annotation is currently always the center. To
        // shift the anchor point to the bottom of the annotation, the image
        // asset includes transparent bottom padding equal to the original image
        // height.
        //
        // To make this padding non-interactive, we create another image object
        // with a custom alignment rect that excludes the padding.
        image = [image imageWithAlignmentRectInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        
        // Initialize the ‘pisa’ annotation image with the UIImage we just loaded
        annotationImage = [MGLAnnotationImage annotationImageWithImage:image reuseIdentifier:@"smoke"];
    }
    
    return annotationImage;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
