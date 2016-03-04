//
//  ReviewOrderViewController.m
//  FoodEx
//
//  Created by Adam Gaynor on 3/3/16.
//  Copyright © 2016 FoodEx. All rights reserved.
//

#import "ReviewOrderViewController.h"
#import "GlobalData.h"
@interface ReviewOrderViewController ()

@end

@implementation ReviewOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO];
    [self setTitle:@"Confirm Request"];
    
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)confirmOrderPressed:(id)sender {
    //ACTUALLY SUBMIT THE ORDER
    GlobalData *myData = [GlobalData sharedInstance];
    [myData.myOrders persist:myData.currentFoodRequest];
    [self.navigationController popToRootViewControllerAnimated:YES];
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
