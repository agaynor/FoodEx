//
//  RegisterViewController.h
//  FoodEx
//
//  Created by Adam Gaynor on 4/14/16.
//  Copyright © 2016 FoodEx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>


@property (weak, nonatomic) IBOutlet UITextField *txtUsername;

@property (weak, nonatomic) IBOutlet UITextField *txtFirstName;

@property (weak, nonatomic) IBOutlet UITextField *txtLastName;

@property (weak, nonatomic) IBOutlet UITextField *txtPassword;


@property (weak, nonatomic) IBOutlet UIButton *profilePic;

@property (strong, nonatomic) UIImage *image;



@property (nonatomic, assign) BOOL hasSelectedImage;
@end
