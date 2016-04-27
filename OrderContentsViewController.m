//
//  OrderContentsViewController.m
//  FoodEx
//
//  Created by Adam Gaynor on 3/2/16.
//  Copyright © 2016 FoodEx. All rights reserved.
//

#import "OrderContentsViewController.h"
#import "ItemAddViewController.h"
#import "ReviewOrderViewController.h"
#import "GlobalData.h"
#import "Item.h"
#import "DiningLocation.h"
@interface OrderContentsViewController ()

@end

@implementation OrderContentsViewController

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

- (void)viewDidLoad {
 
    [super viewDidLoad];
    [self setTitle:@"Add Items"];
    [self.navigationController setNavigationBarHidden:NO];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItem:)];
    
    self.navigationItem.rightBarButtonItem = addButton;
    self.tblItems.delegate = self;
    self.tblItems.dataSource = self;
    self.pickerDiningArea.delegate = self;
    self.pickerDiningArea.dataSource = self;
    self.lblTotalPrice.text =  @"Total Price: $0.00";
    self.tblItems.allowsMultipleSelectionDuringEditing = NO;
    
    GlobalData *myData = [GlobalData sharedInstance];
    Order *currentOrder = [myData currentFoodRequest].order;
    DiningLocation *loc = [myData.menu.menu objectAtIndex:0];
    
    [currentOrder setDining_location:loc.locationName];
    
    self.pickerDiningArea.backgroundColor = UIColorFromRGB(0x064065);
    self.pickerDiningArea.tintColor = UIColorFromRGB(0xb9b8b8);
    self.tblItems.backgroundColor = UIColorFromRGB(0x064065);
}

-(void)viewWillAppear:(BOOL)animated
{
    GlobalData *myData = [GlobalData sharedInstance];
    if([myData.currentFoodRequest.order.items count] != 0)
    {
        [self.pickerDiningArea setUserInteractionEnabled:NO];
    }
    [self.tblItems reloadData];
    self.lblTotalPrice.text =  [NSString stringWithFormat:@"Total Price: $%.2f", [myData.currentFoodRequest.order.price_total doubleValue]];

}

-(IBAction)addItem:(id)sender
{
    [self.navigationController pushViewController:[[ItemAddViewController alloc] initWithNibName:@"ItemAddViewController" bundle:nil] animated:YES];
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    GlobalData *myData = [GlobalData sharedInstance];
    return [myData.menu.menu count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    GlobalData *myData = [GlobalData sharedInstance];
    DiningLocation *loc = [myData.menu.menu objectAtIndex:row];
    
    return loc.locationName;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    GlobalData *myData = [GlobalData sharedInstance];
    Order *currentOrder = [myData currentFoodRequest].order;
    DiningLocation *loc = [myData.menu.menu objectAtIndex:row];

    [currentOrder setDining_location:loc.locationName];
    
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    GlobalData *myData = [GlobalData sharedInstance];
    DiningLocation *loc = [myData.menu.menu objectAtIndex:row];
    
    NSString *title = loc.locationName;;
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0xb9b8b8)}];
    
    return attString;
    
}

- (IBAction)placeOrderPressed:(id)sender {
    GlobalData *myData = [GlobalData sharedInstance];
    Order *currentOrder = [myData currentFoodRequest].order;
    NSArray *initialItemArray = ((Item *)[currentOrder.items objectAtIndex:0]).menuItem.otherLocations;
    
    NSMutableSet *intersection = [NSMutableSet setWithArray:initialItemArray];
    for(Item *item in currentOrder.items)
    {
        [intersection intersectSet:[NSSet setWithArray:item.menuItem.otherLocations]];
    }
    currentOrder.otherLocations = [NSMutableArray arrayWithArray:[intersection allObjects]];
    NSLog(@"%@", [currentOrder.otherLocations description]);
    [self.navigationController pushViewController:[[ReviewOrderViewController alloc] initWithNibName:@"ReviewOrderViewController" bundle:nil] animated:YES];
}


#pragma mark TableViewMethods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    GlobalData *myData = [GlobalData sharedInstance];
    return [myData.currentFoodRequest.order.items count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"MyIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                       reuseIdentifier:MyIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    
    // Here we use the provided setImageWithURL: method to load the web image
    // Ensure you use a placeholder image otherwise cells will be initialized with no image
    GlobalData *myData = [GlobalData sharedInstance];
    Item *item = [myData.currentFoodRequest.order.items objectAtIndex:indexPath.row];
    NSString *textString = [NSString stringWithFormat:@"%@ %@", item.quantity, item.name];
    cell.textLabel.text = textString;
    
    double totalPrice = [item.unit_price doubleValue] * [item.quantity intValue];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"$%.2f", totalPrice];

    //edit layout and ui
    cell.textLabel.textColor = UIColorFromRGB(0xB9B8B8);
    cell.detailTextLabel.textColor = UIColorFromRGB(0xB9B8B8);
    cell.backgroundColor = UIColorFromRGB(0x064065);
    cell.textLabel.font = [UIFont fontWithName:@"Futura" size:18];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Futura" size:14];
    
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        GlobalData *myData = [GlobalData sharedInstance];
        
        Item *removeItem = [myData.currentFoodRequest.order.items objectAtIndex:indexPath.row];
        
        double totalPrice = [removeItem.unit_price doubleValue] * [removeItem.quantity intValue];
        
        myData.currentFoodRequest.order.price_total = [NSNumber numberWithDouble:[myData.currentFoodRequest.order.price_total doubleValue]- totalPrice];
        
        self.lblTotalPrice.text =  [NSString stringWithFormat:@"Total Price: $%.2f", [myData.currentFoodRequest.order.price_total doubleValue]];

        [myData.currentFoodRequest.order.items removeObjectAtIndex:indexPath.row];
        if([myData.currentFoodRequest.order.items count] == 0)
        {
            [self.pickerDiningArea setUserInteractionEnabled:YES];
        }
        
        
        
        [tableView reloadData];
    }
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
