//
//  ItemAddViewController.h
//  FoodEx
//
//  Created by Joshua Landman on 3/2/16.
//  Copyright © 2016 FoodEx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemAddViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *lblQuantity;

@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UIStepper *stepperQuantity;

@property (weak, nonatomic) IBOutlet UITextField *txtComments;


@end
