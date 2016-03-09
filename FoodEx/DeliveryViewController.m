//
//  DeliveryViewController.m
//  FoodEx
//
//  Created by Adam Gaynor on 3/1/16.
//  Copyright © 2016 FoodEx. All rights reserved.
//

#import "DeliveryViewController.h"
#import "GlobalData.h"
#import "ReviewOrderViewController.h"
@interface DeliveryViewController ()

@end

@implementation DeliveryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tblDeliveries.delegate = self;
    self.tblDeliveries.dataSource = self;
    
    GlobalData *myData = [GlobalData sharedInstance];
    [myData.myDeliveries importMyDeliveriesToTableView:self.tblDeliveries];
    [myData.unclaimedDeliveries queryUndeliveredRequestsToTableView:self.tblDeliveries];
    [self.tblDeliveries reloadData];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden:NO];
    [self.tblDeliveries reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;    //count of section
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return @"My Deliveries";
    }
    else
    {
        return @"Unclaimed Deliveries";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    GlobalData *myData = [GlobalData sharedInstance];
    if(section == 0)
    {
        return [myData.myDeliveries.requests count];
    }
    else{
        return [myData.unclaimedDeliveries.requests count];
    }
}

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
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd 'at' HH:mm"];
    FoodRequest *request = nil;
    if(indexPath.section == 0)
    {
        request = [myData.myDeliveries.requests objectAtIndex:indexPath.row];
    }
    else
    {
        request = [myData.unclaimedDeliveries.requests objectAtIndex:indexPath.row];
    }
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
        myData.currentFoodRequest = [myData.myDeliveries.requests objectAtIndex:indexPath.row];
    }
    else
    {
        myData.currentFoodRequest = [myData.unclaimedDeliveries.requests objectAtIndex:indexPath.row];
    }
    
    [self.navigationController pushViewController:[[ReviewOrderViewController alloc] initWithNibName:@"ReviewOrderViewController" bundle:nil] animated:YES];
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
