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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tblDeliveries.hidden = YES;
    self.mapView.hidden = NO;
    
    
    self.tblDeliveries.delegate = self;
    self.tblDeliveries.dataSource = self;
    
    
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
    [myData.myDeliveries importMyDeliveries:^(BOOL completion){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tblDeliveries reloadData];
            
        });
    }];
    [myData.unclaimedDeliveries queryUndeliveredRequests:^(BOOL completion){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tblDeliveries reloadData];
            
        });
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveUpdateNotification:) name:@"UpdateMyDeliveries" object:nil];

    // Do any additional setup after loading the view from its nib.
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
    [dateFormatter setDateFormat:@"yyyy-MM-dd 'at' HH:mm"];
    FoodRequest *request = nil;
    if(indexPath.section == 0)
    {
        request = [myData.myDeliveries.requests objectAtIndex:indexPath.row];
    }
    else
    {
        request = [myData.unclaimedDeliveries.requests objectAtIndex:indexPath.row];
    }
    NSString *textString = [NSString stringWithFormat:@"%@ at %@", request.pickup_location, [dateFormatter stringFromDate:request.pickup_at]];
    cell.textLabel.text = textString;
    NSString *detailTextString = [NSString stringWithFormat:@"From %@", request.order.dining_location];
    cell.detailTextLabel.text = detailTextString;
    
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
