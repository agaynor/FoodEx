//
//  ProfileViewController.m
//  FoodEx
//
//  Created by Adam Gaynor on 3/1/16.
//  Copyright © 2016 FoodEx. All rights reserved.
//

#import "ProfileViewController.h"
#import "GlobalData.h"
#import "ReviewOrderViewController.h"
@interface ProfileViewController ()

@end

static NSString* const kBaseURL = @"http://ec2-54-92-150-113.compute-1.amazonaws.com:8000/";
static NSString* const kFiles = @"files";

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GlobalData *myData = [GlobalData sharedInstance];
    [self.profilePic setImage:myData.myUser.image forState:UIControlStateNormal];
    self.lblFirstName.text = myData.myUser.firstName;
    self.lblLastName.text = myData.myUser.lastName;
    self.lblUsername.text = myData.myUser.username;
    
    self.tblPastTransactions.delegate = self;
    self.tblPastTransactions.dataSource = self;
    
    [myData.pastDeliveries importMyDeliveries:NO andCompletion:^(BOOL completion){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tblPastTransactions reloadData];
            
        });
    }];
    
    [myData.pastOrders importMyOrders:NO andCompletion:^(BOOL completion){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tblPastTransactions reloadData];
            
        });
    }];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = YES;
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



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;    //count of section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    GlobalData *myData = [GlobalData sharedInstance];
    
    if(section == 0)
    {
        return [myData.pastOrders.requests count];
    }
    else{
         return [myData.pastDeliveries.requests count];
    }
   

}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return @"Past Orders";
    }
    else{
       return @"Past Deliveries";;
    }}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"MyIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:MyIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    
    
    // Here we use the provided setImageWithURL: method to load the web image
    // Ensure you use a placeholder image otherwise cells will be initialized with no image
    GlobalData *myData = [GlobalData sharedInstance];
    FoodRequest *request;
    if(indexPath.section == 0)
    {
        request = [myData.pastOrders.requests objectAtIndex:indexPath.row];
    }
    else
    {
        request = [myData.pastDeliveries.requests objectAtIndex:indexPath.row];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd 'at' HH:mm"];
    
    
    NSString *textString = [NSString stringWithFormat:@"%@ at %@", request.pickup_location, [dateFormatter stringFromDate:request.pickup_at]];
    cell.textLabel.text = textString;
    NSString *detailTextString = [NSString stringWithFormat:@"From %@", request.order.dining_location];
    cell.detailTextLabel.text = detailTextString;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GlobalData *myData = [GlobalData sharedInstance];
    if(indexPath.section == 0)
    {
        myData.currentFoodRequest = [myData.pastOrders.requests objectAtIndex:indexPath.row];

    }
    else{
         myData.currentFoodRequest = [myData.pastDeliveries.requests objectAtIndex:indexPath.row];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NULL];
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController pushViewController:[[ReviewOrderViewController alloc] initWithNibName:@"ReviewOrderViewController" bundle:nil] animated:YES];
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
