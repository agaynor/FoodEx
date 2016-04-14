//
//  LoginViewController.m
//  FoodEx
//
//  Created by Adam Gaynor on 3/1/16.
//  Copyright © 2016 FoodEx. All rights reserved.
//

#import "LoginViewController.h"
#import "GlobalData.h"
@interface LoginViewController ()

@end

static NSString* const kBaseURL = @"http://ec2-54-92-150-113.compute-1.amazonaws.com:8000/";
static NSString* const kLoginRequests = @"login";
static NSString* const kRegisterRequests = @"register";

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
    
    NSString *requestString = [kBaseURL stringByAppendingPathComponent:kLoginRequests];
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
                NSArray* responseArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL]; //6
                
                GlobalData *myData = [GlobalData sharedInstance];
                myData.myUser = [[User alloc] initWithDictionary:[responseArray objectAtIndex:0]];
                NSLog(@"%@", [responseArray objectAtIndex:0][@"username"]);
                [myData.myOrders importMyOrders:YES andCompletion:^(BOOL completion){
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateMyOrders" object:self];
                }];
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
    
    NSMutableDictionary *registerInfo = [[NSMutableDictionary alloc] init];
    registerInfo[@"username"] = [self.txtUsername text];
    registerInfo[@"password"] = [self.txtPassword text];
    
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
                        [self.txtUsername setText:@""];
                        [self.txtPassword setText:@""];
                    }];
                    
                });
                
                
                
            }
            
            //else register success
            else{
                
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
                    }];
                    

                });
                
            }
            
            
        }
    }];
    
    [dataTask resume];
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
