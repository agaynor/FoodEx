//
//  ProfileViewController.h
//  FoodEx
//
//  Created by Adam Gaynor on 3/1/16.
//  Copyright © 2016 FoodEx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *profilePic;

@property (weak, nonatomic) IBOutlet UILabel *lblUsername;
@property (weak, nonatomic) IBOutlet UILabel *lblLastName;


@property (weak, nonatomic) IBOutlet UITableView *tblPastTransactions;
@property (weak, nonatomic) IBOutlet UILabel *lblFirstName;
@end
