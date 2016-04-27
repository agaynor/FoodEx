//
//  ItemAddViewController.m
//  FoodEx
//
//  Copyright © 2016 FoodEx. All rights reserved.
//

#import "ItemAddViewController.h"
#import "GlobalData.h"
#import "Item.h"

@interface ItemAddViewController ()

@end

@implementation ItemAddViewController

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO];
    [self setTitle:@"New Item"];
    
    self.pickerItemName.dataSource = self;
    self.pickerItemName.delegate = self;
    
    GlobalData *myData = [GlobalData sharedInstance];
    for (DiningLocation *loc in myData.menu.menu)
    {
        if([loc.locationName isEqualToString:myData.currentFoodRequest.order.dining_location])
        {
            self.currentLocation = loc;
        }
    }
    
    self.selectedItem = [self.currentLocation.menuItems objectAtIndex:0];
    self.lblUnitPrice.text = [NSString stringWithFormat:@"$%.2f",[self.selectedItem.price doubleValue]];
    self.lblTotalPrice.text = [NSString stringWithFormat:@"$%.2f",[self.selectedItem.price doubleValue]];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)quantityChanged:(id)sender {
    [self.lblQuantity setText:[NSString stringWithFormat:@"%d",
                          [[NSNumber numberWithInt:[(UIStepper *)sender value]] intValue]]];
    
    double totalPrice = [self.selectedItem.price doubleValue] * [self.stepperQuantity value];
    
    self.lblTotalPrice.text = [NSString stringWithFormat:@"$%.2f", totalPrice];
    
}

- (IBAction)addItemPressed:(id)sender {
    //TODO: TAKE STEPS TO ADD ITEM
    GlobalData *myData = [GlobalData sharedInstance];
    Item *newItem = [[Item alloc] init];
    [newItem setName:self.selectedItem.name];
    double quantity = [self.stepperQuantity value];
    
    [newItem setQuantity:[NSNumber numberWithInt:quantity]];
    [newItem setComment:[self.txtComments text]];
    [newItem setUnit_price:self.selectedItem.price];
    newItem.menuItem = self.selectedItem;
    [[[myData currentFoodRequest] order] addItem:newItem];
     double totalPrice = [newItem.unit_price doubleValue] * [newItem.quantity intValue];
    myData.currentFoodRequest.order.price_total = [NSNumber numberWithDouble:[myData.currentFoodRequest.order.price_total doubleValue] + totalPrice];
    //NEED TO FIGURE OUT ITEM EDITING...MAYBE DON'T ALLOW EDITS, JUST DELETES
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma Picker Delegate

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    GlobalData *myData = [GlobalData sharedInstance];
    for (DiningLocation *loc in myData.menu.menu)
    {
        if([loc.locationName isEqualToString:myData.currentFoodRequest.order.dining_location])
        {
            return [loc.menuItems count];
        }
    }
    return 0;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.selectedItem = [self.currentLocation.menuItems objectAtIndex:row];
    
    self.lblUnitPrice.text = [NSString stringWithFormat:@"$%.2f",[self.selectedItem.price doubleValue]];
    
    double totalPrice = [self.selectedItem.price doubleValue] * [self.stepperQuantity value];
    
    self.lblTotalPrice.text = [NSString stringWithFormat:@"$%.2f", totalPrice];

}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    MenuItem *rowItem = [self.currentLocation.menuItems objectAtIndex:row];
    return rowItem.name;
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    MenuItem *item = [self.currentLocation.menuItems objectAtIndex:row];
    
    NSString *title = item.name;
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0xb9b8b8)}];
    
    return attString;
    
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
