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
@interface OrderContentsViewController ()

@end

@implementation OrderContentsViewController

- (void)viewDidLoad {
 
    [super viewDidLoad];
    [self setTitle:@"Add Items"];
    [self.navigationController setNavigationBarHidden:NO];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItem:)];
    
    self.navigationItem.rightBarButtonItem = addButton;
    self.tblItems.delegate = self;
    self.tblItems.dataSource = self;
   
    self.tblItems.allowsMultipleSelectionDuringEditing = NO;

}

-(void)viewWillAppear:(BOOL)animated
{
    [self.tblItems reloadData];
}

-(IBAction)addItem:(id)sender
{
    [self.navigationController pushViewController:[[ItemAddViewController alloc] initWithNibName:@"ItemAddViewController" bundle:nil] animated:YES];
}


- (IBAction)placeOrderPressed:(id)sender {

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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                       reuseIdentifier:MyIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    
    // Here we use the provided setImageWithURL: method to load the web image
    // Ensure you use a placeholder image otherwise cells will be initialized with no image
    GlobalData *myData = [GlobalData sharedInstance];
    Item *item = [myData.currentFoodRequest.order.items objectAtIndex:indexPath.row];
    NSString *textString = [NSString stringWithFormat:@"%@ %@", item.quantity, item.name];
    cell.textLabel.text = textString;
    cell.detailTextLabel.text = item.comment;

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
        [myData.currentFoodRequest.order.items removeObjectAtIndex:indexPath.row];
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
