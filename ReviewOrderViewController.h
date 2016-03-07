//
//  ReviewOrderViewController.h
//  FoodEx
//
//  Created by Adam Gaynor on 3/3/16.
//  Copyright © 2016 FoodEx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReviewOrderViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *lblDiningArea;

@property (weak, nonatomic) IBOutlet UILabel *lblPickupLocation;

@property (weak, nonatomic) IBOutlet UILabel *lblPickupTime;

@property (weak, nonatomic) IBOutlet UILabel *lblOrderer;

@property (weak, nonatomic) IBOutlet UILabel *lblDeliverer;

@property (weak, nonatomic) IBOutlet UITableView *tblItems;

@property (weak, nonatomic) IBOutlet UILabel *lblTotalPrice;

@property (weak, nonatomic) IBOutlet UIButton *btnAction;


@end
