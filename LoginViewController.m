//
//  LoginViewController.m
//  FoodEx
//
//  Created by Adam Gaynor on 3/1/16.
//  Copyright © 2016 FoodEx. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

static NSString* const kBaseURL = @"http://ec2-54-92-150-113.compute-1.amazonaws.com:8000/";
static NSString* const kRequests = @"login";

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Send login information to server
- (IBAction)loginPressed:(id)sender {
    NSMutableDictionary *loginInfo = [[NSMutableDictionary alloc] init];
    loginInfo[@"username"] = [self.txtUsername text];
    loginInfo[@"password"] = [self.txtPassword text];
    
    NSString *requestString = [kBaseURL stringByAppendingPathComponent:kRequests];
    NSURL *url = [NSURL URLWithString:requestString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    request.HTTPMethod = @"POST";
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:loginInfo options:0 error:NULL];
    
    request.HTTPBody = data;
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            long status = [httpResponse statusCode];
            
            //If login error
            if(status > 400)
            {
                //Show alert with error
                NSString *loginError = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    
                    UIAlertController * alert=   [UIAlertController
                                                  alertControllerWithTitle:@"Login Failed"
                                                  message:loginError
                                                  preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* cancelButton = [UIAlertAction
                                                   actionWithTitle:@"Okay"
                                                   style:UIAlertActionStyleCancel
                                                   handler:nil];
                    
                    [alert addAction:cancelButton];
                    
                    [self presentViewController:alert animated:YES completion:^{
                        [self.txtUsername setText:@""];
                        [self.txtPassword setText:@""];
                    }];
                    
                });
  
                

            }
            
            //else login success
            else{
                [self dismissViewControllerAnimated:YES completion:nil];
                
            }
            
            
        }
        else {
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"Login Failed"
                                          message:@"Cannot connect to server..."
                                          preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* cancelButton = [UIAlertAction
                                           actionWithTitle:@"Okay"
                                           style:UIAlertActionStyleCancel
                                           handler:nil];
            
            [alert addAction:cancelButton];
            
            //Clear fields to try again
            [self presentViewController:alert animated:YES completion:^{
                [self.txtUsername setText:@""];
                [self.txtPassword setText:@""];
            }];
        }
    }];
    
    [dataTask resume];

    
}

//Send register information to server
- (IBAction)registerPressed:(id)sender {
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
