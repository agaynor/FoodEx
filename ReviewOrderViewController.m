//
//  ReviewOrderViewController.m
//  FoodEx
//
//  Created by Adam Gaynor on 3/3/16.
//  Copyright © 2016 FoodEx. All rights reserved.
//

#import "ReviewOrderViewController.h"
#import "GlobalData.h"
#import "OrderViewController.h"
#import "DeliveryViewController.h"
#import "FoodRequest.h"
#import "ViewProfileViewController.h"
@interface ReviewOrderViewController ()


@end

@implementation ReviewOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO];
    [self setTitle:@"Confirm Request"];
    
    GlobalData *myData = [GlobalData sharedInstance];
    FoodRequest *reviewRequest = myData.currentFoodRequest;
    
    self.lblDiningArea.text = reviewRequest.order.dining_location;
    self.lblPickupLocation.text = reviewRequest.pickup_location;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd 'at' HH:mm"];
    self.lblPickupTime.text = [dateFormatter stringFromDate:reviewRequest.pickup_at];
    
    [self.tabBarController.tabBar setHidden:YES];

    //Review request has been previously submitted
    if(reviewRequest.buyer_name)
    {
        self.lblOrderer.text = reviewRequest.buyer_name;
        //If the current logged in user submitted this request and it has not yet been picked up
        if([reviewRequest.buyer_name isEqualToString:myData.myUser.username] && !reviewRequest.deliverer_id)
        {
            //then we want to provide the option to delete the request
            [self.btnAction setTitle:@"Delete Request" forState:UIControlStateNormal];
        }
        //If the request has been picked up
        else if(reviewRequest.deliverer_id)
        {
            [self.btnAction setEnabled:NO];
            [self.btnAction setTitle:@"Request Claimed" forState:UIControlStateDisabled];
        }
        //If the request is not ours
        else{
            [self.btnAction setTitle:@"Claim Delivery" forState:UIControlStateNormal];
        }
    }
    //If the review request has not been previously submitted
    else{
        self.lblOrderer.text = myData.myUser.username;
    }
    
    
    if(reviewRequest.deliverer_name)
    {
        self.lblDeliverer.text = reviewRequest.deliverer_name;
    }
    else{
        self.lblDeliverer.text = @"Not Claimed";
    }
    
    self.tblItems.delegate = self;
    self.tblItems.dataSource = self;
    
    

    self.mapView.delegate = self;

    self.mapView.rotateEnabled = NO;
    self.mapView.pitchEnabled = NO;
    self.mapView.scrollEnabled = NO;
    self.mapView.zoomEnabled = NO;
    
    self.mapView.zoomLevel = 18;

    MGLPointAnnotation *orderLocation = [[MGLPointAnnotation alloc] init];
    orderLocation.coordinate = reviewRequest.pickup_point;
    orderLocation.title = @"View Profile";
    [self.mapView addAnnotation:orderLocation];
    self.mapView.centerCoordinate = orderLocation.coordinate;

    
    // Do any additional setup after loading the view from its nib.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    GlobalData *myData = [GlobalData sharedInstance];
    return [myData.currentFoodRequest.order.items count];
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    // Here we use the provided setImageWithURL: method to load the web image
    // Ensure you use a placeholder image otherwise cells will be initialized with no image
    GlobalData *myData = [GlobalData sharedInstance];
    Item *item = [myData.currentFoodRequest.order.items objectAtIndex:indexPath.row];
    NSString *textString = [NSString stringWithFormat:@"%@ %@", item.quantity, item.name];
    cell.textLabel.text = textString;
    cell.detailTextLabel.text = item.comment;
    
    return cell;
}


- (IBAction)confirmOrderPressed:(id)sender {
    //ACTUALLY SUBMIT THE ORDER
    GlobalData *myData = [GlobalData sharedInstance];
    FoodRequest *reviewRequest = myData.currentFoodRequest;

    //Review request has been previously submitted
    if(reviewRequest.buyer_name)
    {
        //If the current logged in user submitted this request and it has not yet been picked up
        if([reviewRequest.buyer_name isEqualToString:myData.myUser.username] && !reviewRequest.deliverer_id)
        {
            [myData.myOrders deleteRequest:reviewRequest andCompletion:^(BOOL completion){
                [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateMyOrders" object:self];
            }];
        }
        //If the request is not ours
        else{
            [myData.unclaimedDeliveries persist:reviewRequest withDeliveryAcceptTo:myData.myDeliveries andCompletion:^(BOOL completion){
                [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateMyDeliveries" object:self];
            }];
        }
    }
    //If the review request has not been previously submitted
    else{
        [myData.myOrders persist:reviewRequest andCompletion:^(BOOL completion){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateMyOrders" object:self];
        }];
    }
    
    [self.navigationController popToRootViewControllerAnimated:YES];

}


- (BOOL)mapView:(MGLMapView *)mapView annotationCanShowCallout:(id<MGLAnnotation>)annotation
{
    GlobalData *myData = [GlobalData sharedInstance];
    FoodRequest *reviewRequest = myData.currentFoodRequest;
    if(reviewRequest.deliverer_id)
    {
        NSLog(@"can show callout");
        return true;
    }
    else
    {
         NSLog(@"can't show callout");
        return false;
    }
}





- (UIView *)mapView:(MGLMapView *)mapView rightCalloutAccessoryViewForAnnotation:(id<MGLAnnotation>)annotation
{
    return [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
}

- (void)mapView:(MGLMapView *)mapView annotation:(id<MGLAnnotation>)annotation calloutAccessoryControlTapped:(UIControl *)control
{
  
    // hide the callout view
    [self.mapView deselectAnnotation:annotation animated:NO];
    
    self.navigationController.navigationBar.hidden = NO;
        
    [self.navigationController pushViewController:[[ViewProfileViewController alloc] initWithNibName:@"ViewProfileViewController" bundle:nil] animated:YES];
    
    
    
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
