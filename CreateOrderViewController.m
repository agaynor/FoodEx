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

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addItemsPressed:(id)sender {
    
    GlobalData *myData = [GlobalData sharedInstance];
    [[myData currentFoodRequest] setPickup_at:[self.datePickupTime date]];
    [[myData currentFoodRequest] setPickup_location:[self.txtPickupLocation text]];
    Order *currentOrder = [myData currentFoodRequest].order;
    [currentOrder setDining_location:[self.txtDiningArea text]];
    
    NSLog(@"here");
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
