//
//  CreateOrderViewController.m
//  FoodEx
//
//  Created by Adam Gaynor on 3/1/16.
//  Copyright © 2016 FoodEx. All rights reserved.
//

#import "CreateOrderViewController.h"
#import "OrderContentsViewController.h"
#import "GlobalData.h"
#import "Order.h"
@interface CreateOrderViewController ()

@end

@implementation CreateOrderViewController
{
    BOOL didLocateUser;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"Create Request"];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Request" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    [self.tabBarController.tabBar setHidden:YES];
    [self.navigationController setNavigationBarHidden:NO];
    // Do any additional setup after loading the view from its nib.
    GlobalData *myData = [GlobalData sharedInstance];
    [myData setCurrentFoodRequest:[[FoodRequest alloc] init]];
    Order *currentOrder = [[Order alloc] init];
    [[myData currentFoodRequest] setOrder:currentOrder];
    
    [self.datePickupTime setMinimumDate:[NSDate date]];
    
    
    //setup map information
    self.mapView.delegate = self;
    
    self.mapView.showsUserLocation = YES;
    self.mapView.rotateEnabled = NO;
    self.mapView.pitchEnabled = NO;
    self.bounds = MGLCoordinateBoundsMake(CLLocationCoordinate2DMake(38.637206, -90.319410),CLLocationCoordinate2DMake(38.659962, -90.297445));
    
    self.mapView.visibleCoordinateBounds = self.bounds;
    if(!self.pinImage.image)
    {
        self.pinImage.image = [UIImage imageNamed:@"pindouble.png"];
    }
    
    self.mapView.minimumZoomLevel = self.mapView.zoomLevel;
    
    
    
    didLocateUser = NO;


}

-(void)mapView:(MGLMapView *)mapView didUpdateUserLocation:(MGLUserLocation *)userLocation
{
    
    if(!didLocateUser && [self point:self.mapView.userLocation.coordinate inCoordinateBounds:self.bounds])
    {
        self.mapView.centerCoordinate = self.mapView.userLocation.coordinate;
        [self.mapView setZoomLevel:self.mapView.zoomLevel+3.5 animated:NO];
    }
   
    didLocateUser = YES;
     self.mapView.showsUserLocation = NO;
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addItemsPressed:(id)sender {
    
    GlobalData *myData = [GlobalData sharedInstance];
    [[myData currentFoodRequest] setPickup_at:[self.datePickupTime date]];
    [[myData currentFoodRequest] setPickup_point:self.mapView.centerCoordinate];
    [[myData currentFoodRequest] setPickup_location:[self.txtPickupInfo text]];
    
    
    [self.navigationController pushViewController:[[OrderContentsViewController alloc] initWithNibName:@"OrderContentsViewController" bundle:nil] animated:YES];
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
