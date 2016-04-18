//
//  ViewProfileViewController.h
//  FoodEx
//
//  Created by Adam Gaynor on 4/17/16.
//  Copyright © 2016 FoodEx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewProfileViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *profPic;
@property (weak, nonatomic) IBOutlet UILabel *lblUsername;
@property (weak, nonatomic) IBOutlet UILabel *lblFirstName;
@property (weak, nonatomic) IBOutlet UILabel *lblLastName;
@property (weak, nonatomic) IBOutlet UITableView *tblReviews;

@end
