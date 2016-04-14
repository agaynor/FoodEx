//
//  CreateOrderViewController.h
//  FoodEx
//
//  Created by Adam Gaynor on 3/1/16.
//  Copyright © 2016 FoodEx. All rights reserved.
//

#import <UIKit/UIKit.h>


@import Mapbox;

@interface CreateOrderViewController : UIViewController <MGLMapViewDelegate>

@property (weak, nonatomic) IBOutlet UIDatePicker *datePickupTime;


@property (weak, nonatomic) IBOutlet UITextField *txtPickupInfo;

@property (weak, nonatomic) IBOutlet MGLMapView *mapView;

@property (weak, nonatomic) IBOutlet UIImageView *pinImage;

@property (nonatomic) MGLCoordinateBounds bounds;



@end
