//
//  ItemAddViewController.h
//  FoodEx
//
//  Created by Joshua Landman on 3/2/16.
//  Copyright © 2016 FoodEx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiningLocation.h"
#import "MenuItem.h"
@interface ItemAddViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *lblQuantity;

@property (weak, nonatomic) IBOutlet UIPickerView *pickerItemName;


@property (weak, nonatomic) IBOutlet UIStepper *stepperQuantity;


@property (weak, nonatomic) IBOutlet UITextField *txtComments;
@property (strong, nonatomic) DiningLocation *currentLocation;
@property (strong, nonatomic) MenuItem *selectedItem;
@property (weak, nonatomic) IBOutlet UILabel *lblUnitPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalPrice;

@end
