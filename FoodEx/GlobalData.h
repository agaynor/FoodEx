//
//  GlobalData.h
//  FoodEx
//
//  Created by Adam Gaynor on 3/3/16.
//  Copyright © 2016 FoodEx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FoodRequest.h"
#import "FoodRequests.h"
#import "User.h"
@interface GlobalData : NSObject

@property (nonatomic, strong) FoodRequest *currentFoodRequest;
@property (nonatomic, strong) FoodRequests *myOrders;
@property (nonatomic, strong) FoodRequests *myDeliveries;
@property (nonatomic, strong) FoodRequests *unclaimedDeliveries;
@property (nonatomic, strong) FoodRequests *pastOrders;
@property (nonatomic, strong) FoodRequests *pastDeliveries;
//@property (nonatomic, strong) NSString *myUsername;
@property (nonatomic, strong) User *myUser;
+(id)sharedInstance;

@end
