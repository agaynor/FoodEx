//
//  OrderContentsViewController.h
//  FoodEx
//
//  Created by Adam Gaynor on 3/2/16.
//  Copyright © 2016 FoodEx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderContentsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tblItems;

@property (weak, nonatomic) IBOutlet UITextField *txtDiningArea;
@end
