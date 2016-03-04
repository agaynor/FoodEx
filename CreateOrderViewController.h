//
//  CreateOrderViewController.h
//  FoodEx
//
//  Created by Adam Gaynor on 3/1/16.
//  Copyright © 2016 FoodEx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateOrderViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIDatePicker *datePickupTime;

@property (weak, nonatomic) IBOutlet UITextField *txtDiningArea;

@property (weak, nonatomic) IBOutlet UITextField *txtPickupLocation;


@end
