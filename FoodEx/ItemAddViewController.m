//
//  ItemAddViewController.m
//  FoodEx
//
//  Copyright © 2016 FoodEx. All rights reserved.
//

#import "ItemAddViewController.h"
#import "GlobalData.h"
#import "Item.h"
@interface ItemAddViewController ()

@end

@implementation ItemAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO];
    [self setTitle:@"New Item"];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)quantityChanged:(id)sender {
    [self.lblQuantity setText:[NSString stringWithFormat:@"%d",
                          [[NSNumber numberWithInt:[(UIStepper *)sender value]] intValue]]];
}

- (IBAction)addItemPressed:(id)sender {
    //TODO: TAKE STEPS TO ADD ITEM
    GlobalData *myData = [GlobalData sharedInstance];
    Item *newItem = [[Item alloc] init];
    [newItem setName:[self.txtName text]];
    double quantity = [self.stepperQuantity value];
    
    [newItem setQuantity:[NSNumber numberWithInt:quantity]];
    [newItem setComment:[self.txtComments text]];
    [[[myData currentFoodRequest] order] addItem:newItem];
    //NEED TO FIGURE OUT ITEM EDITING...MAYBE DON'T ALLOW EDITS, JUST DELETES
    [self.navigationController popViewControllerAnimated:YES];
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
