//
//  ViewProfileViewController.m
//  FoodEx
//
//  Created by Adam Gaynor on 4/17/16.
//  Copyright © 2016 FoodEx. All rights reserved.
//

#import "ViewProfileViewController.h"
#import "GlobalData.h"
@interface ViewProfileViewController ()

@end
static NSString* const kBaseURL = @"http://ec2-54-92-150-113.compute-1.amazonaws.com:8000/";
static NSString* const kUsers = @"users";
static NSString* const kFiles = @"files";
@implementation ViewProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    GlobalData *myData = [GlobalData sharedInstance];
    FoodRequest *myRequestInfo = myData.currentFoodRequest;
    
    NSString *requestString = [[kBaseURL stringByAppendingPathComponent:kUsers] stringByAppendingPathComponent:myRequestInfo.image_id];
    
    
    
    
    NSURL *url = [NSURL URLWithString:requestString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET";
    
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSURLSessionDataTask* dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil) {
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            NSLog(@"%@",[responseDict description]);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.lblUsername.text = responseDict[@"username"];
                self.lblFirstName.text = responseDict[@"first_name"];
                self.lblLastName.text = responseDict[@"last_name"];
                
            });

            
        }
    }];
    
    [dataTask resume];
    
    NSURL *fileurl = [NSURL URLWithString:[[kBaseURL stringByAppendingPathComponent:kFiles] stringByAppendingPathComponent:myRequestInfo.image_id]];
    
    NSURLSessionConfiguration *config2 = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session2 = [NSURLSession sessionWithConfiguration:config2];
    
    NSURLSessionDownloadTask* task = [session2 downloadTaskWithURL:fileurl completionHandler:^(NSURL *fileLocation, NSURLResponse *response, NSError *error) {
        if (!error) {
            NSData* imageData = [NSData dataWithContentsOfURL:fileLocation];
            UIImage* image = [UIImage imageWithData:imageData];
            if (!image) {
                NSLog(@"unable to build image");
            }
            dispatch_async(dispatch_get_main_queue(), ^{
               
                  self.profPic.image = image;
            });
          
        }
    }];
    
    [task resume];


    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
