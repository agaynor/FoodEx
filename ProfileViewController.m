//
//  ProfileViewController.m
//  FoodEx
//
//  Created by Adam Gaynor on 3/1/16.
//  Copyright © 2016 FoodEx. All rights reserved.
//

#import "ProfileViewController.h"
#import "GlobalData.h"

@interface ProfileViewController ()

@end

static NSString* const kBaseURL = @"http://ec2-54-92-150-113.compute-1.amazonaws.com:8000/";
static NSString* const kFiles = @"files";

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GlobalData *myData = [GlobalData sharedInstance];
    [self.profilePic setImage:myData.myUser.image forState:UIControlStateNormal];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)changeProfPic:(id)sender {
    UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    
    //May do this stuff later for taking picture, for now just use photo lib
    /*
     if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
     imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
     } else {
     imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
     }
     */
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:imagePicker animated:YES completion:^{
        
    }];

    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [self dismissModalViewControllerAnimated:YES];
    
    //now we save the profile picture
    NSURL *url = [NSURL URLWithString:[kBaseURL stringByAppendingPathComponent:kFiles]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    [request addValue:@"image/png" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSData *bytes = UIImageJPEGRepresentation(image, 0.5);
    NSURLSessionUploadTask* task = [session uploadTaskWithRequest:request fromData:bytes completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) { //5
        if (error == nil && [(NSHTTPURLResponse*)response statusCode] < 300) {
            //image saved successfully
            GlobalData *myData = [GlobalData sharedInstance];
            myData.myUser.image = image;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.profilePic setImage:image forState:UIControlStateNormal];
                
                
            });
            
        }
        
        else
        {
        }
    }];
    [task resume];
    
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
