//
//  OrderViewController.m
//  FoodEx
//
//  Created by Adam Gaynor on 3/1/16.
//  Copyright © 2016 FoodEx. All rights reserved.
//

#import "OrderViewController.h"
#import "CreateOrderViewController.h"
#import "GlobalData.h"
#import "ReviewOrderViewController.h"
@interface OrderViewController ()

@end

@implementation OrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  /*  [[[GlobalData sharedInstance] myOrders] importMyOrders:^(BOOL completion){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tblMyOrders reloadData];
            
        });
    }];
*/
    self.tblMyOrders.dataSource = self;
    self.tblMyOrders.delegate = self;
    [self.navigationController setNavigationBarHidden:YES];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveUpdateNotification:) name:@"UpdateMyOrders" object:nil];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
    [self.tabBarController.tabBar setHidden:NO];
}


-(void)receiveUpdateNotification:(NSNotification *) notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tblMyOrders reloadData];
        
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)placeOrderPressed:(id)sender {
    [self.navigationController pushViewController:[[CreateOrderViewController alloc] initWithNibName:@"CreateOrderViewController" bundle:nil ] animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    GlobalData *myData = [GlobalData sharedInstance];
    return [myData.myOrders.requests count];
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
    FoodRequest *request = [myData.myOrders.requests objectAtIndex:indexPath.row];
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
    myData.currentFoodRequest = [myData.myOrders.requests objectAtIndex:indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:NULL];
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
