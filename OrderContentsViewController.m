//
//  OrderContentsViewController.m
//  FoodEx
//
//  Created by Adam Gaynor on 3/2/16.
//  Copyright © 2016 FoodEx. All rights reserved.
//

#import "OrderContentsViewController.h"
#import "ItemAddViewController.h"
#import "ReviewOrderViewController.h"
@interface OrderContentsViewController ()

@end

@implementation OrderContentsViewController

- (void)viewDidLoad {
 
    [super viewDidLoad];
    [self setTitle:@"Add Items"];
    [self.navigationController setNavigationBarHidden:NO];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItem:)];
    
    self.navigationItem.rightBarButtonItem = addButton;
   
    
}

-(IBAction)addItem:(id)sender
{
    [self.navigationController pushViewController:[[ItemAddViewController alloc] initWithNibName:@"ItemAddViewController" bundle:nil] animated:YES];
}


- (IBAction)placeOrderPressed:(id)sender {
    //ACTUALLY SEND REQUEST HERE
    [self.navigationController pushViewController:[[ReviewOrderViewController alloc] initWithNibName:@"ReviewOrderViewController" bundle:nil] animated:YES];
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
