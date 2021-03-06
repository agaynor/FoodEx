//
//  DeliveryViewController.h
//  FoodEx
//
//  Created by Adam Gaynor on 3/1/16.
//  Copyright © 2016 FoodEx. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Mapbox;

@interface DeliveryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MGLMapViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tblDeliveries;

@property (weak, nonatomic) IBOutlet MGLMapView *mapView;
@property (nonatomic) MGLCoordinateBounds bounds;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (strong, nonatomic) NSMutableArray *myDeliveryAnnotations;

@property (strong, nonatomic) NSMutableArray *undeliveredAnnotations;



@end
