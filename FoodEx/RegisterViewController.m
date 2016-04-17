//
//  RegisterViewController.m
//  FoodEx
//
//  Created by Adam Gaynor on 4/14/16.
//  Copyright © 2016 FoodEx. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()

@end

static NSString* const kBaseURL = @"http://ec2-54-92-150-113.compute-1.amazonaws.com:8000/";
static NSString* const kRegisterRequests = @"register";
static NSString* const kFiles = @"files";


@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.hasSelectedImage = NO;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)profilePicChanged:(id)sender {
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
- (IBAction)registerPressed:(id)sender {
    //first check to make sure everything has been filled out and image selected.
    
    //then register user, save image using user
    NSMutableDictionary *registerInfo = [[NSMutableDictionary alloc] init];
    registerInfo[@"username"] = [[self.txtUsername text] lowercaseString];
    registerInfo[@"password"] = [self.txtPassword text];
    registerInfo[@"first_name"] = [self.txtFirstName text];
    registerInfo[@"last_name"] = [self.txtLastName text];
    
    
    NSString *requestString = [kBaseURL stringByAppendingPathComponent:kRegisterRequests];
    NSURL *url = [NSURL URLWithString:requestString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    request.HTTPMethod = @"POST";
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:registerInfo options:0 error:NULL];
    
    request.HTTPBody = data;
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            long status = [httpResponse statusCode];
            
            //If register error
            if(status >= 400)
            {
                //Show alert with error
                NSString *registerError = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    
                    UIAlertController * alert=   [UIAlertController
                                                  alertControllerWithTitle:@"Register Failed"
                                                  message:registerError
                                                  preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* cancelButton = [UIAlertAction
                                                   actionWithTitle:@"Okay"
                                                   style:UIAlertActionStyleCancel
                                                   handler:nil];
                    
                    [alert addAction:cancelButton];
                    
                    [self presentViewController:alert animated:YES completion:^{
                
                    }];
                    
                });
                
                
                
            }
            
            //else register success
            else{
                
                //now we save the profile picture
                NSURL *url = [NSURL URLWithString:[kBaseURL stringByAppendingPathComponent:kFiles]];
                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
                request.HTTPMethod = @"POST";
                [request addValue:@"image/png" forHTTPHeaderField:@"Content-Type"];
                
                NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
                NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
                
               // NSData *bytes = UIImagePNGRepresentation(self.image);
                NSData *bytes = UIImageJPEGRepresentation(self.image, 0.5);
                NSURLSessionUploadTask* task = [session uploadTaskWithRequest:request fromData:bytes completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) { //5
                    if (error == nil && [(NSHTTPURLResponse*)response statusCode] < 300) {
                       //image saved successfully
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            
                            UIAlertController * alert=   [UIAlertController
                                                          alertControllerWithTitle:@"Register Success"
                                                          message:[NSString stringWithFormat:@"%@ now registered!", [self.txtUsername text]]
                                                          preferredStyle:UIAlertControllerStyleAlert];
                            
                            UIAlertAction* cancelButton = [UIAlertAction
                                                           actionWithTitle:@"Okay"
                                                           style:UIAlertActionStyleCancel
                                                           handler:nil];
                            
                            [alert addAction:cancelButton];
                            
                            [self presentViewController:alert animated:YES completion:^{
                                [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                                [self dismissViewControllerAnimated:YES completion:nil];

                            }];
                            
                            
                        });
                        
                    }
                    
                    else
                    {
                    }
                }];
                [task resume];
                
                
            }
            
            
        }
    }];
    
    [dataTask resume];

}

- (IBAction)cancelPressed:(id)sender {
}



- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [self dismissModalViewControllerAnimated:YES];
    self.image = image;
    [self.profilePic setImage:image forState:UIControlStateNormal];
    self.hasSelectedImage = YES;
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
